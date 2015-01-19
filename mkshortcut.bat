
mkdir %HOMEPATH%"\.vim"
mklink %HOMEPATH%"\.vimrc" %HOMEPATH%"\dotfiles\.vimrc"
mklink %HOMEPATH%"\.gvimrc" %HOMEPATH%"\dotfiles\.gvimrc"
mklink /D %HOMEPATH%"\.vim\colors" %HOMEPATH%"\dotfiles\colors"

