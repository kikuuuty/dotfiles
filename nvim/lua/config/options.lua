
-- =====================================
-- 1) 文字コード / 改行コード / ファイルI/O
-- =====================================
vim.opt.encoding      = 'utf-8'                             -- 内部エンコーディング
vim.opt.fileencoding  = 'utf-8'                             -- 保存時の既定文字コード
vim.opt.fileencodings = { 'utf-8', 'cp932', 'euc-jp' }      -- 自動判別候補
vim.opt.bomb          = true                                -- UTF-8 BOM付与（必要に応じてfalse）
vim.opt.fileformats   = { 'dos', 'unix', 'mac' }            -- 改行コードの自動認識順
vim.opt.fileformat    = 'dos'                               -- 新規ファイルの改行コード
vim.opt.autoread      = true                                -- 外部変更を自動読込
vim.opt.backup        = false                               -- バックアップファイルを作らない
vim.opt.swapfile      = false                               -- スワップファイルを作らない
vim.opt.undofile      = false                                -- 永続アンドゥを無効化
vim.opt.undodir       = vim.fn.stdpath('state') .. '/undo'  -- nvim-data/state/undo に保存
vim.opt.confirm       = true                                -- 未保存時は保存確認

-- =====================================
-- 2) バッファ/ディレクトリ挙動
-- =====================================
vim.opt.hidden     = true                                   -- 未保存でもバッファ切替可
vim.opt.autochdir  = true                                   -- ファイルのディレクトリへ自動移動
vim.opt.shellslash = true                                   -- Windowsでも'/'区切りを許可
vim.opt.history    = 50                                     -- コマンド/検索履歴数

-- =====================================
-- 3) 編集体験（言語非依存）
-- =====================================
vim.opt.expandtab    = true                                 -- Tabをスペース化
vim.opt.tabstop      = 4                                    -- タブ表示幅（共通既定）
vim.opt.softtabstop  = 4                                    -- Tab入力/削除の見かけ幅
vim.opt.shiftwidth   = 4                                    -- 自動インデント幅（共通既定）
vim.opt.smarttab     = true                                 -- 行頭<Tab>でshiftwidthを使用
vim.opt.backspace    = { 'indent', 'eol', 'start' }         -- BSでインデント/改行/開始位置を削除
vim.opt.nrformats:remove('octal')                           -- <C-A>/<C-X>で8進数を無効
vim.opt.ambiwidth    = 'double'                             -- 全角不定幅文字を2桁扱い
vim.opt.lazyredraw   = true                                 -- マクロ等で再描画を省略

-- =====================================
-- 4) 検索
-- =====================================
vim.opt.incsearch  = true                                   -- インクリメンタルサーチ
vim.opt.ignorecase = true                                   -- 大小無視
vim.opt.smartcase  = true                                   -- 大文字含む検索語では区別
vim.opt.wrapscan   = true                                   -- 末尾到達で先頭へ
vim.opt.hlsearch   = true                                   -- ハイライト

-- =====================================
-- 5) 表示/UI
-- =====================================
vim.opt.number        = true                                -- 行番号
vim.opt.cursorline    = false                               -- カーソル行強調
vim.opt.wrap          = false                               -- 自動折返し無効
vim.opt.title         = false                               -- タイトル更新しない
vim.opt.ruler         = true                                -- ステータスに行/列
vim.opt.showcmd       = true                                -- 入力中コマンド表示
vim.opt.list          = false                               -- 制御文字の可視化オフ
vim.opt.showmatch     = true                                -- 対応括弧の一時ハイライト
vim.opt.matchpairs    = vim.opt.matchpairs + { '<:>' }      -- 追加マッチペア
vim.opt.wildmenu      = true                                -- コマンドライン補完メニュー
vim.opt.wildmode      = 'longest:full,full'                 -- 補完モード
vim.opt.laststatus    = 2                                   -- ステータスライン常時表示（必要なら3へ）
vim.opt.cmdheight     = 1                                   -- コマンドライン高さ
vim.opt.shortmess:append('I')                               -- 起動メッセージ抑制
vim.opt.shortmess:append('c')                               -- 補完メッセージ簡素化
vim.opt.splitright    = true                                -- 垂直分割は右に開く
vim.opt.splitbelow    = true                                -- 水平分割は下に開く
vim.opt.signcolumn    = 'yes'                               -- サインカラム固定
vim.opt.termguicolors = true                                -- 24bitカラー
vim.opt.scrolloff     = 5                                   -- 上下の余白
vim.opt.sidescrolloff = 8                                   -- 左右の余白
vim.opt.pumheight     = 15                                  -- 補完メニュー最大行数
vim.opt.showtabline   = 0                                   -- タブラインを表示しない
--vim.opt.clipboard  = 'unnamedplus'                          -- OSクリップボード共有

-- =====================================
-- 6) シンタックス/ファイルタイプ
-- =====================================
vim.cmd('syntax enable')                                    -- シンタックス
vim.cmd('filetype plugin on')                               -- filetype検出/プラグイン

-- =====================================
-- 7) マウス
-- =====================================
vim.opt.mouse      = 'a'                                    -- 全モードでマウス
vim.opt.mousefocus = false                                  -- マウス移動でフォーカス移動しない

-- =====================================
-- 8) 書式/コメントの自動調整
-- =====================================
vim.opt.formatoptions:append({ 'm','M' })                   -- 日本語連結時の空白抑制など
--local ft_au = vim.api.nvim_create_augroup('CustomFileType', { clear = true })
--vim.api.nvim_create_autocmd('FileType', {
--  group = ft_au,
--  pattern = '*',
--  callback = function()
--    vim.opt_local.formatoptions:remove('t')                 -- テキスト自動折返し無効
--    vim.opt_local.formatoptions:append({ 'r','o','l' })     -- コメント継続など
--  end,
--})

-- =====================================
-- 9) QuickFix / grep 連携
-- =====================================
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    pattern = { '*grep*' },
    callback = function()
        vim.cmd('cwindow')                                  -- grep後にQuickFixを開く
    end,
})
--vim.opt.grepprg    = 'rg --vimgrep --smart-case'             -- ripgrep を既定に
--vim.opt.grepformat = '%f:%l:%c:%m'                           -- QuickFix 用の書式

-- =====================================
-- 10) タグ/ナビゲーション
-- =====================================
--vim.opt.tags = { './.tags;,./tags;' }                        -- 親方向にtags探索
vim.opt.inccommand  = 'split'                               -- :s 置換のプレビュー
vim.opt.updatetime  = 300                                   -- 診断/補完の反応速度
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }     -- 補完ポップアップの挙動

-- =====================================
-- 11) 折り畳み
-- =====================================
vim.opt.foldenable     = true                               -- 折り畳みを有効化
vim.opt.foldlevel      = 99                                 -- 現在のウィンドウを全展開状態に
vim.opt.foldlevelstart = 99                                 -- 新規ウィンドウも全展開状態で開く
