mkdir %HOMEPATH%"\.vim"
mklink %HOMEPATH%"\.vimrc" %HOMEPATH%"\dotfiles\.vimrc"
mklink %HOMEPATH%"\.gvimrc" %HOMEPATH%"\dotfiles\.gvimrc"
mklink /D %HOMEPATH%"\.vim\colors" %HOMEPATH%"\dotfiles\colors"
mklink /D %HOMEPATH%"\.vim\ftdetect" %HOMEPATH%"\dotfiles\ftdetect"
mklink /D %HOMEPATH%"\.vim\ftplugin" %HOMEPATH%"\dotfiles\ftplugin"
mklink /D %HOMEPATH%"\.vim\plugin" %HOMEPATH%"\dotfiles\plugin"
mklink /D %HOMEPATH%"\.vim\syntax" %HOMEPATH%"\dotfiles\syntax"
