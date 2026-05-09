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

local function is_lambda_opening(line, col)
  local before = line:sub(1, col - 1)
  return before:match('%b[]%s*$') ~= nil
      or before:match('%b[]%s*%b()%s*[%w%s_:&*<>%-]*$') ~= nil
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
        })
      elseif char == '}' then
        table.remove(stack)
      end
    end
  end

  local in_lambda = false
  for _, item in ipairs(stack) do
    if item.lambda then
      in_lambda = true
      break
    end
  end

  if not in_lambda or #stack == 0 then
    return nil
  end

  local current = vim.fn.getline(lnum)
  local block_start = stack[#stack]
  if current:match('^%s*}') then
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

  return vim.fn.indent(block_start.line) + vim.fn.shiftwidth()
end

local function cpp_indent()
  local lnum = vim.v.lnum
  local indent = vim.fn.cindent(lnum)

  indent = matching_initializer_indent(lnum) or lambda_body_indent(lnum) or indent

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
