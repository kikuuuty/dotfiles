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

local function cpp_indent()
  local lnum = vim.v.lnum
  local indent = vim.fn.cindent(lnum)

  indent = matching_initializer_indent(lnum) or indent

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
