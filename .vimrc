
set nocompatible

set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932,euc-jp
scriptencoding utf-8
"set bomb

"----------------------------
" NeoBundle

"----------------------------
" ファイル
set fileformats=dos,unix,mac			" 改行コードの自動認識
set fileformat=dos						" 改行コードを設定する
set confirm								" 保存されていないファイルがある場合は事前に保存確認
set hidden								" 保存されていないファイルがある場合でも別のファイルを開けるようにする
set autoread							" 外部でファイルが変更された場合は読み直す
set nobackup							" ファイル保存時にバックアップファイルを作らない
set noswapfile							" ファイル編集中にスワップファイルを作らない
set shellslash							" Windowsでディレクトリパスの区切り文字に'/'を使えるようにする
set autochdir							" カレントディレクトリを開いたファイルのディレクトリへ移動する

"----------------------------
" 一般
set history=50							" コマンド、検索パターンの履歴保存数
set t_Co=256							" 256色化
set nowrap								" テキストの折り返しはしない
set shortmess+=I						" 起動時のメッセージを表示しない
set visualbell t_vb=					" ビープ音もフラッシュもしない

"----------------------------
" 検索
set incsearch							" インクリメンタルサーチを行う
set ignorecase							" 大文字と小文字を区別しない
set smartcase							" 大文字と小文字が混在した場合は区別する
set wrapscan							" 検索が最後尾まで到達したら先頭へ戻る

"----------------------------
" 編集
set smarttab							" 
set noexpandtab							" タブをスペースに展開しない
set tabstop=4							" タブ幅
set shiftwidth=4						" オートインデントの幅
set backspace=indent,eol,start			" バックスペースでインデントや改行を削除できるようにする
set cindent								" Cの自動インデントを有効化する
set cinoptions=:0,g0					" インデントスタイルを設定
set nrformats-=octal					" <C-a>,<C-x>の際に8進数を無効にする
set ambiwidth=double					" □や○の文字があってもカーソル位置がずれないようにする
if has('win32')
	set iminsert=0						" 挿入モード時のデフォルトのIMEの挙動を設定
	set imsearch=-1						" iminsertに合わせる
endif
set lazyredraw							" マクロなどの途中経過を再描画しない
set formatoptions+=mM					" 日本語の行の連結時には空白を入力しない
augroup CustomFileType 
	autocmd!
	autocmd FileType * setlocal formatoptions-=t formatoptions+=rol
augroup END

"----------------------------
" 装飾
set number								" 行番号を表示
set cursorline							" カーソル行を強調表示する
set notitle								" タイトルを表示しない
set ruler								" カーソルが何行目の何列目に置かれているかを表示する
set showcmd								" 入力中のコマンドをステータスに表示する
set nolist								" タブや改行などの不可視文字を表示しない
set showmatch							" 対応する括弧を強調表示
set matchpairs& matchpairs+=<:>			" 対応する括弧に<>を追加
set wildmenu							" 補完候補をリスト表示
set laststatus=2						" 常にステータス行を表示する
set cmdheight=1							" コマンドラインの高さ

"----------------------------
" フォント
set guifont=Consolas
set guifontwide=TakaoGothic:h11
set linespace=4							" 行間の指定

"----------------------------
" シンタックスハイライト
if &t_Co > 2 || has('gui_running')
	syntax enable						" シンタックスハイライトを有効にする
	set hlsearch						" 検索文字列をハイライトする
endif

let g:solarized_termcolors=256
set background=light
colorscheme solarized

"----------------------------
" マウス
set mouse=a								" どのモードでもマウスを使えるようにする
set nomousefocus						" マウスの移動でフォーカスを自動的に切り替えない
set mousehide							" 入力時にマウスポインタを隠す

"----------------------------
" GUI
if has('gui_running')
	set columns=126						" ウィンドウの幅
	set lines=999						" ウィンドウの高さ
	winpos 1002 0						" ウィンドウの位置
	set guioptions-=m
	set guioptions-=T
endif

