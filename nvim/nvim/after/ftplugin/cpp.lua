vim.opt_local.cindent = true
vim.opt_local.cinoptions = 'g0,N-s,:0,(0'

local function matching_initializer_indent(lnum)
  if not vim.fn.getline(lnum):match('^%s*%.') then
    return nil
  end

  local prev = vim.fn.prevnonblank(lnum - 1)
  if prev == 0 or not vim.fn.getline(prev):match('^%s*}%s*,%s*$') then
    return nil
  end

  local balance = 0
  for i = prev, 1, -1 do
    local line = vim.fn.getline(i)
    for j = #line, 1, -1 do
      local char = line:sub(j, j)
      if char == '}' then
        balance = balance + 1
      elseif char == '{' then
        balance = balance - 1
        if balance == 0 then
          return vim.fn.indent(i)
        end
      end
    end
  end

  return nil
end

local function is_constructor_declaration(line)
  return line:match('%)%s*[%w_:&*<>%s]*$') ~= nil
end

local function constructor_initializer_indent(lnum)
  local line = vim.fn.getline(lnum)
  local first_initializer = lnum

  if line:match('^%s*$') then
    local prev = vim.fn.prevnonblank(lnum - 1)
    if prev == 0 or not vim.fn.getline(prev):match('^%s*[:,]') then
      return nil
    end
    first_initializer = prev
  elseif not line:match('^%s*[:,]') then
    return nil
  end

  while first_initializer > 1 do
    local prev = vim.fn.prevnonblank(first_initializer - 1)
    if prev == 0 or not vim.fn.getline(prev):match('^%s*[:,]') then
      break
    end
    first_initializer = prev
  end

  local declaration = vim.fn.prevnonblank(first_initializer - 1)
  if declaration == 0 or not is_constructor_declaration(vim.fn.getline(declaration)) then
    return nil
  end

  return vim.fn.indent(declaration) + vim.fn.shiftwidth()
end

local function constructor_body_indent(lnum)
  local stack = {}

  for i = 1, lnum - 1 do
    local line = vim.fn.getline(i)
    for col = 1, #line do
      local char = line:sub(col, col)
      if char == '{' then
        table.insert(stack, { line = i })
      elseif char == '}' then
        table.remove(stack)
      end
    end
  end

  if #stack == 0 then
    return nil
  end

  local open_line_number = stack[#stack].line
  local open_line = vim.fn.getline(open_line_number)
  if not open_line:match('^%s*[:,]') or not open_line:match('{%s*$') then
    return nil
  end

  local first_initializer = open_line_number
  while first_initializer > 1 do
    local prev = vim.fn.prevnonblank(first_initializer - 1)
    if prev == 0 or not vim.fn.getline(prev):match('^%s*[:,]') then
      break
    end
    first_initializer = prev
  end

  local declaration = vim.fn.prevnonblank(first_initializer - 1)
  if declaration == 0 or not is_constructor_declaration(vim.fn.getline(declaration)) then
    return nil
  end

  if vim.fn.getline(lnum):match('^%s*}') then
    return vim.fn.indent(declaration)
  end

  return vim.fn.indent(declaration) + vim.fn.shiftwidth()
end

local function is_lambda_opening(line, col)
  local before = line:sub(1, col - 1)
  return before:match('%b[]%s*$') ~= nil
      or before:match('%b[]%s*%b()%s*[%w%s_:&*<>%-]*$') ~= nil
end

local function multiline_lambda_indent(lnum, line, col)
  local before = line:sub(1, col - 1)
  local lambda_start = before:find('%b[]%s*%b()%s*[%w%s_:&*<>%-]*$')
      or before:find('%b[]%s*$')
  if not lambda_start or before:sub(1, lambda_start - 1):match('%S') then
    return nil
  end

  return vim.fn.indent(lnum)
end

local function inline_lambda_indent(lnum, line, col)
  local before = line:sub(1, col - 1)
  local lambda_start = before:find('%b[]%s*%b()%s*[%w%s_:&*<>%-]*$')
      or before:find('%b[]%s*$')
  if not lambda_start or not before:sub(1, lambda_start - 1):match('%S') then
    return nil
  end

  local line_indent = vim.fn.indent(lnum)
  if lambda_start <= line_indent + vim.fn.shiftwidth() * 2 then
    return nil
  end

  return line_indent
end

local function lambda_argument_indent(lnum)
  local line = vim.fn.getline(lnum)
  if not line:match('^%s*%b[]%s*%b()%s*[%w%s_:&*<>%-]*{') then
    return nil
  end

  local prev = vim.fn.prevnonblank(lnum - 1)
  if prev == 0 or not vim.fn.getline(prev):match('%(%s*$') then
    return nil
  end

  return vim.fn.indent(prev) + vim.fn.shiftwidth()
end

local function lambda_body_indent(lnum)
  local stack = {}

  for i = 1, lnum - 1 do
    local line = vim.fn.getline(i)
    for col = 1, #line do
      local char = line:sub(col, col)
      if char == '{' then
        table.insert(stack, {
          line = i,
          col = col,
          lambda = is_lambda_opening(line, col),
          indent = multiline_lambda_indent(i, line, col) or inline_lambda_indent(i, line, col),
        })
      elseif char == '}' then
        table.remove(stack)
      end
    end
  end

  local lambda_indent = nil
  for _, item in ipairs(stack) do
    if item.lambda then
      lambda_indent = item.indent
    end
  end

  if not lambda_indent or #stack == 0 then
    return nil
  end

  local current = vim.fn.getline(lnum)
  local block_start = stack[#stack]
  if current:match('^%s*}') then
    if block_start.lambda then
      return lambda_indent
    end

    return vim.fn.indent(block_start.line)
  end

  local parens = 0
  for i = block_start.line, lnum - 1 do
    local line = vim.fn.getline(i)
    if i == block_start.line then
      line = line:sub(block_start.col + 1)
    end

    for char in line:gmatch('[()]') do
      if char == '(' then
        parens = parens + 1
      elseif parens > 0 then
        parens = parens - 1
      end
    end
  end

  if parens > 0 then
    return nil
  end

  if block_start.lambda then
    return lambda_indent + vim.fn.shiftwidth()
  end

  return vim.fn.indent(block_start.line) + vim.fn.shiftwidth()
end

local function cpp_indent()
  local lnum = vim.v.lnum
  local indent = vim.fn.cindent(lnum)

  indent = matching_initializer_indent(lnum) or constructor_initializer_indent(lnum) or constructor_body_indent(lnum) or lambda_argument_indent(lnum) or lambda_body_indent(lnum) or indent

  if lnum > 1 then
    local prev = vim.fn.prevnonblank(lnum - 1)
    local prevline = prev > 0 and vim.fn.getline(prev) or ''
    if prevline:match('^%s*%[%[.-%]%]%s*$') or prevline:match('^%s*template%s*<.->%s*$') then
      indent = indent - vim.fn.shiftwidth()
    end
  end

  return math.max(0, indent)
end

_G.dotfiles_cpp_indent = cpp_indent
vim.opt_local.indentexpr = 'v:lua.dotfiles_cpp_indent()'
