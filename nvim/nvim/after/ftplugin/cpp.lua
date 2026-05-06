vim.opt_local.cindent = true
vim.opt_local.cinoptions = 'g0,N-s,:0'

local function cpp_indent()
  local lnum = vim.v.lnum
  local indent = vim.fn.cindent(lnum)

  if lnum > 1 then
    local prev = vim.fn.prevnonblank(lnum - 1)
    if prev > 0 and vim.fn.getline(prev):match('^%s*%[%[.-%]%]%s*$') then
      indent = indent - vim.fn.shiftwidth()
    end
  end

  return math.max(0, indent)
end

_G.dotfiles_cpp_indent = cpp_indent
vim.opt_local.indentexpr = 'v:lua.dotfiles_cpp_indent()'
