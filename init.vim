" Michael's init.vim
" (https://github.com/kmhofmann/dotfiles)
" =======================================
"
" Installation:
"
" * $ cp init.vim ~/.config/nvim/
"
" * If not present yet, the plugin manager vim-plug will be bootstrapped.
"   See https://github.com/junegunn/vim-plug on how to use vim-plug.
"
" * You can alter the list of plugins by editing the 's:plugin_categories' list below. After installation of new
"   plugins, just restart vim.
"
" * All mentioned plugins will be installed from GitHub. Check their respective pages for functionality and
"   documentation.
"
" * Some language servers:   (see also here for a good overview: https://github.com/neovim/nvim-lsp)
"   - Bash:       yarn global add bash-language-server
"   - CSS:        yarn global add vscode-css-languageserver-bin
"   - C++:        See https://github.com/MaskRay/ccls
"   - Dockerfile: yarn global add dockerfile-language-server-nodejs
"   - JSON:       yarn global add vscode-json-languageserver
"   - LaTeX:      cargo install --git https://github.com/latex-lsp/texlab.git --locked
"   - (( Python:     pip install python-lsp-server pyls-mypy pyls-isort pyls-black ))
"   - Python:     yarn global add pyright
"   - TypeScript: yarn global add typescript-language-server
"   - Vim:        yarn global add vim-language-server
"   - Vue:        yarn global add vls
"   - YAML:       yarn global add yaml-language-server
"   - ...
"   For all servers installed with 'yarn global add', $HOME/.yarn/bin needs to be in the $PATH.
"
" * Some linters:
"   - Prettier:   yarn global add prettier
"
" * nvim: You may have to install the Python 'pynvim' package for some plugins to work correctly.
"   $ pip install [--user] --upgrade pynvim

" Plugin management
"=======================================

" **************************************************
" PLugins to look at:
" https://github.com/nvim-lualine/lualine.nvim
" https://github.com/lewis6991/gitsigns.nvim
" https://github.com/AckslD/swenv.nvim
" **************************************************

" Activate or deactivate categories here:
let s:plugin_categories  = ['colorschemes']
let s:plugin_categories += ['basic']
let s:plugin_categories += ['textsearch']
let s:plugin_categories += ['textediting']
let s:plugin_categories += ['statusline']
let s:plugin_categories += ['ui_additions']
let s:plugin_categories += ['filesearch']
let s:plugin_categories += ['formatting']
let s:plugin_categories += ['version_control']
let s:plugin_categories += ['development']
let s:plugin_categories += ['linting_completion']
let s:plugin_categories += ['copyleft_licensed_plugins']

let s:set_t_8f_t_8b_options = 0
let s:colorscheme_use_base16 = 0
"let s:colorscheme = 'vim-monokai-tasty'
let s:colorscheme = 'catppuccin'

" Bootstrap vim-plug automatically, if not already present
if has("unix") || has("macunix")
  let s:vim_plug_autoload_file = '~/.config/nvim/autoload/plug.vim'
  if empty(glob(s:vim_plug_autoload_file))
    execute "!curl -fLo " . s:vim_plug_autoload_file .
        \ " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  endif
endif

call plug#begin()
if index(s:plugin_categories, 'colorschemes') >= 0
  "Plug 'chriskempson/base16-vim' " Set of color schemes; see http://chriskempson.com/projects/base16/; License: MIT
  Plug 'catppuccin/nvim', { 'as': 'catppuccin' }  " License: MIT
  Plug 'dracula/vim', { 'as': 'dracula' }  " License: MIT
  Plug 'bluz71/vim-moonfly-colors'       " License: MIT
  Plug 'bluz71/vim-nightfly-guicolors'   " License: MIT
  Plug 'jaredgorski/spacecamp'           " License: MIT

  Plug 'tomasr/molokai'                 " License: MIT
  Plug 'rhysd/vim-color-spring-night'   " License: MIT
  Plug 'flrnprz/plastic.vim'            " License: MIT
  Plug 'larsbs/vimterial_dark'          " License: MIT
  Plug 'erichdongubler/vim-sublime-monokai'  " License: MIT
  Plug 'euclio/vim-nocturne'             " License: MIT

  " Enable these if desired:
  "Plug 'patstockwell/vim-monokai-tasty'  " License: None
  "Plug 'morhetz/gruvbox'                " License: None
  "Plug 'altercation/vim-colors-solarized'  " License: None
  "Plug 'nanotech/jellybeans.vim'        " License: None
  "Plug 'Nequo/vim-allomancer'           " License: None
  "Plug 'lifepillar/vim-solarized8'      " License: None
  "Plug 'TroyFletcher/vim-colors-synthwave'  " License: Coffee
  "Plug 'google/vim-colorscheme-primary'  " License: Apache 2.0
endif

if index(s:plugin_categories, 'basic') >= 0
  Plug 'tpope/vim-eunuch'                " Syntactic sugar for some UNIX shell commands. License: Vim
  Plug 'tpope/vim-repeat'                " Remaps . such that plugin maps can use it. License: Vim
  Plug 'tpope/vim-unimpaired'            " Provide pairs of mappings for []. License: Vim
  Plug 'tpope/vim-obsession', { 'on': ['Obsess'] }  " Easier session handling. License: Vim
endif

if index(s:plugin_categories, 'textsearch') >= 0
  Plug 'andymass/vim-matchup'            " Improved % motion. License: MIT
  Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }  " Easier grepping. License: MIT
  let s:have_grepper = 1
endif

if index(s:plugin_categories, 'textediting') >= 0
  Plug 'wellle/targets.vim'              " Add various text objects to give more targets to operate on. License: MIT
  Plug 'drzel/vim-split-line'            " Easier line splitting. License: MIT
  let s:have_splitline = 1
  Plug 'AndrewRadev/sideways.vim'        " Move function arguments sideways. License: MIT
  let s:have_sideways = 1
  Plug 'svermeulen/vim-cutlass'
  let s:have_cutlass = 1
  Plug 'svermeulen/vim-yoink'
  let s:have_yoink = 1
  Plug 'svermeulen/vim-subversive'
  let s:have_subversive = 1
endif

if index(s:plugin_categories, 'statusline') >= 0
  Plug 'itchyny/lightline.vim'           " Statusline. License: MIT
  let s:have_lightline = 1
endif

if index(s:plugin_categories, 'ui_additions') >= 0
  Plug 'mbbill/undotree', { 'on': ['UndotreeToggle'] }  " Visualize and act upon undo tree. License: BSD-3-Clause
  let s:have_undotree = 1
  Plug 'Yggdroot/indentLine'              " License: MIT
  let s:have_indent_line = 1
  Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }  " License: MIT
  let s:have_which_key = 1
endif

if index(s:plugin_categories, 'filesearch') >= 0
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }  " License: MIT
  Plug 'junegunn/fzf.vim'              " License: MIT
  let s:have_fzf = 1
  Plug 'preservim/nerdtree', { 'on': ['NERDTree', 'NERDTreeFind', 'NERDTreeToggle', 'NERDTreeFocus'] }  " Better file explorer. License: WTFPL
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTree', 'NERDTreeFind', 'NERDTreeToggle', 'NERDTreeFocus'] }  " License: WTFPL
  let s:have_nerdtree = 1
endif

if index(s:plugin_categories, 'formatting') >= 0
  Plug 'junegunn/vim-easy-align'         " Text alignment made easy. License: MIT
  let s:have_easy_align = 1
  Plug 'Chiel92/vim-autoformat', { 'on': 'Autoformat' }  " Trigger code formatting engines: License: MIT
endif

if index(s:plugin_categories, 'version_control') >= 0
  Plug 'airblade/vim-rooter'             " Changes working directory to project root. License: MIT
  let s:have_vim_rooter = 1
  Plug 'tpope/vim-fugitive'              " Git wrapper. License: Vim
  let s:have_fugitive = 1
  Plug 'mhinz/vim-signify'               " Show visual git diff in the gutter. License: MIT
  let s:have_signify = 1
  Plug 'rhysd/git-messenger.vim'         " Show last commit in popup window. License: MIT
endif

if index(s:plugin_categories, 'development') >= 0
  Plug 'scrooloose/nerdcommenter'        " Commenting code. License: CC0-1.0
  Plug 'sbdchd/neoformat'                " (Re)Formatting code. License: BSD-2-Clause
  let s:have_neoformat = 1

  if has("python") || has("python3")
    Plug 'plytophogy/vim-virtualenv', { 'on': ['VirtualEnvList', 'VirtualEnvActivate', 'VirtualEnvDeactivate'] }  " Improved working with virtualenvs. License: WTFPL
    Plug 'psf/black'                     " License: MIT
  endif
endif

if index(s:plugin_categories, 'linting_completion') >= 0
  Plug 'dense-analysis/ale'            " Asynchronous Lint Engine. License: BSD-2-Clause
  let s:have_ale = 1

  if exists('s:have_lightline')
    Plug 'maximbaz/lightline-ale'      " ALE indicator for Lightline. License: ISC
    let s:have_lightline_ale = 1
  endif

  Plug 'neovim/nvim-lspconfig'             " Configurations for the Neovim LSP client. License: Apache 2.0

  " Install Deoplete for nvim-lsp and LanguageClient-neovim.
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }  " Asynchronous completion framework. License: MIT
  Plug 'Shougo/deoplete-lsp'  " ...and integration of LSP support. License: MIT
  let s:have_deoplete = 1

  Plug 'ncm2/float-preview.nvim'  " Nicer completion preview window. License: MIT
  let s:have_float_preview = 1
endif

if index(s:plugin_categories, 'copyleft_licensed_plugins') >= 0
  Plug 'schickling/vim-bufonly', { 'on': ['Bonly', 'BOnly', 'Bufonly'] }  " Close all buffers but the current one. License: None
  Plug 'moll/vim-bbye', { 'on': ['Bdelete'] }  " Adds :Bdelete command to close buffer but keep window. License: AGPL v3
  let s:have_bbye = 1

  Plug 'embear/vim-localvimrc'           " Read local .lvimrc files up the directory tree. License: GPL v3
  let s:have_localvimrc = 1

  Plug 'machakann/vim-sandwich'          " Better 'surrounding' motion (conflicts with vim-sneak); License: None

  Plug 'Valloric/ListToggle'             " Easily display or hide quickfix or location list. License: GPL v3
  let s:have_listtoggle = 1

  Plug 'rbong/vim-flog', { 'on': ['Flog', 'Flogsplit'] }  " Git commit graph viewer. License: None
endif

"if index(s:plugin_categories, 'disabled') >= 0
  ""Plug 'airblade/vim-accent'             " Easy selection of accented characters (e.g. with <C-X><C-U>)
  ""Plug 'tpope/vim-surround'              " 'surrounding' motion
  ""Plug 'jeetsukumaran/vim-buffergator'   " Select, list and switch between buffers easily
  ""let s:have_buffergator = 1
  ""Plug 'ConradIrwin/vim-bracketed-paste' " Automatically set paste mode
  ""Plug 'Yilin-Yang/vim-markbar'          " Display accessible marks and surrounding lines in collapsible sidebar
  ""let s:have_vim_markbar = 1
  ""Plug 'wincent/scalpel'                 " Faster within-file word replacement
  ""Plug 'nacitar/a.vim', { 'on': ['A'] }  " Easy switching between header and translation unit
  ""Plug 'SirVer/ultisnips'
  """Plug 'honza/vim-snippets'
  ""if has("unix") || has("macunix")
  ""  Plug 'jez/vim-superman'              " Read man pages with vim (vman command)
  ""endif
  ""Plug 'psliwka/vim-smoothie'            " Smooth scrolling done right
  ""Plug 'justinmk/vim-dirvish' ", { 'on': ['Dirvish'] }
  ""Plug 'kristijanhusak/vim-dirvish-git' ", { 'on': ['Dirvish'] }
  ""Plug 'mhinz/vim-startify'              " A fancy start screen
  ""Plug 'dstein64/vim-win'
  ""Plug 'nathanaelkane/vim-indent-guides', { 'on': ['IndentGuidesEnable', 'IndentGuidesDisable', 'IndentGuidesToggle'] }

  "Plug 'rhysd/clever-f.vim'              " extend f/F/t/T to also repeat search
  "let s:have_clever_f = 1
  ""Plug 'lifepillar/vim-cheat40'
  "Plug 'junegunn/limelight.vim', { 'on': ['Limelight'] }  " Paragraph-based syntax highlighting
  "Plug 'junegunn/goyo.vim', { 'on': ['Goyo'] }  " Distraction-free editing
  "let s:have_goyo = 1

  "Plug 'haya14busa/is.vim'               " Improved incremental search; License: MIT
  "Plug 'tpope/vim-vinegar'
  "Plug 'tpope/vim-sleuth'                " Detect and set automatic indentation
  "Plug 'liuchengxu/vista.vim'            " License: MIT
  "let s:have_vista = 1                   " NB: Deleted plugin configuration below.

  "Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}  " Semantic highlighting of Python code in Neovim. License: None
  "let s:have_semshi = 1
  "Plug 'jackguo380/vim-lsp-cxx-highlight'  " Semantic highlighting for C++
  "let s:have_vim_lsp_cxx_highlight = 1
"endif

call plug#end()

" General
"=======================================

set timeoutlen=1000
set ttimeoutlen=10
set updatetime=500    " Time until CursorHold autocommand is triggered (when nothing is typed).
                      " Also affects swapfile writing.

set history=500       " Sets how many lines of history VIM has to remember
set autoread          " Set to auto read when a file is changed from the outside
set encoding=utf8     " Set utf8 as standard encoding and en_US as the standard language
set ffs=unix,dos,mac  " Use Unix as the standard file type

if has("unix") || has("macunix")
  if !isdirectory($HOME . '/.vim/backup')
    silent call mkdir($HOME . '/.vim/backup', 'p')
  endif
  set backupdir=$HOME/.vim/backup/,.

  if !isdirectory($HOME . '/.vim/swp')
    silent call mkdir($HOME . '/.vim/swp', 'p')
  endif
  set directory=$HOME/.vim/swp/,.
endif

if has("persistent_undo")
  if !isdirectory($HOME . '/.vim/undo')
    silent call mkdir($HOME . '/.vim/undo', 'p')
  endif
  set undodir=$HOME/.vim/undo/
  set undofile
endif

set swapfile       " Use a swapfile for the buffer
set nobackup       " Don't keep backups around
set nowritebackup  " Don't make backups before overwriting a file

set linebreak      " Wrap long lines by default (for display purposes only)
set nolist         " Don't display list characters by default
set listchars=tab:>-,trail:~,extends:>,precedes:<   " Set of list characters
set noemoji        " Fix emoji display (https://youtu.be/F91VWOelFNE)

" Tabbing and indentation
"=======================================

set tabstop=8       " Number of visual spaces per TAB
set softtabstop=2   " Number of spaces in tab when editing
set shiftwidth=2    " Number of spaces to use for each step of (auto)indent
set shiftround      " Always indent by multiple of shiftwidth
set smarttab        " Be smart when using tabs
set expandtab       " Tabs are spaces
set autoindent      " Copy indent from current line when starting a new line
set nojoinspaces    " Do not insert two spaces when using join command (J), just one

autocmd Filetype python setlocal softtabstop=4 shiftwidth=4 colorcolumn=88  expandtab
autocmd Filetype cpp    setlocal softtabstop=2 shiftwidth=2 colorcolumn=100 expandtab
autocmd Filetype cmake  setlocal softtabstop=4 shiftwidth=4 colorcolumn=100 expandtab
autocmd Filetype json   setlocal softtabstop=2 shiftwidth=2 colorcolumn=80  expandtab
autocmd Filetype sh     setlocal softtabstop=2 shiftwidth=2 colorcolumn=80  expandtab
autocmd Filetype vim    setlocal softtabstop=2 shiftwidth=2 colorcolumn=100 expandtab textwidth=100

" Searching
"=======================================

set incsearch           " Search as characters are entered
set hlsearch            " Highlight matches
set ignorecase          " Ignore case when searching
set smartcase           " When searching try to be smart about cases
set magic               " For regular expressions turn magic on
set infercase           " Infer case for completions
if has('nvim')
  set inccommand=nosplit   " Shows the effects of a command incrementally, as you type
endif

" Color scheme
"=======================================

syntax enable           " Enable syntax highlighting
set background=dark     " Dark background color

set termguicolors
"if exists('s:set_t_8f_t_8b_options') && (s:set_t_8f_t_8b_options > 0)
"  " See :help xterm-true-color
"  let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
"  let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
"endif

if index(s:plugin_categories, 'colorschemes') >= 0
  if (!has("gui_running") && exists('s:colorscheme_use_base16') && s:colorscheme_use_base16 == 1 && filereadable(expand("~/.vimrc_background")))
    " Use the base16 color schemes, if available. See https://github.com/chriskempson/base16-shell.
    "let base16colorspace=256   " Seems not needed for true color terminals
    source ~/.vimrc_background
  else
    " Use the color scheme defined above.
    execute 'silent! colorscheme ' . s:colorscheme
  endif
endif

" UI configuration
"=======================================

set backspace=eol,start,indent  " Configure backspace so it acts as it should act
set laststatus=2        " Always show the status line
set scrolloff=0         " Set 0 lines to the cursor - when moving vertically using j/k
set hidden              " A buffer becomes hidden when it is abandoned
set showcmd             " Show command in bottom bar
set ruler               " Always show current position
set nowrap              " Don't wrap overly long lines
set wildmode=list:longest  " Visual autocomplete for command menu
" set wildmenu
" set wildmode=full
set pumblend=20

set lazyredraw          " Redraw only when we need to.
set showmatch           " Highlight matching [{()}]
set mat=2               " How many tenths of a second to blink when matching brackets
set splitbelow          " New horizontal splits open below
set splitright          " New vertical splits open to the right
set synmaxcol=300       " Highlight up to 300 columns

set foldenable          " Enable folding
set foldmethod=indent   " Fold by indentation
set foldlevelstart=99
"set foldcolumn=2

set number              " Show line numbers
set relativenumber    " Show relative line numbers
set cursorline        " Highlight current line

" Allow mapping of meta/option key in MacVim
if has("macunix") && has("gui_running")
  set macmeta
endif

" Activate mouse support (can be temporarily deactivated by holding Shift)
"set mouse=nv            " Activate mouse support in normal and visual modes
"set mousefocus=off      " Do not move focus when moving mouse
"set mousemodel=extend   " Keep default mouse model

augroup MichaelAutocmnds
  au!
  " Resize splits when window gets resized
  autocmd VimResized * wincmd =

  " Disable paste mode when leaving insert mode
  "autocmd InsertLeave * set nopaste
augroup END

" netrw
let g:netrw_liststyle = 3   " tree-style listing

" Functions for later use
"=======================================

" Jump to first non-whitespace on line, or to begining of line if already at first non-whitespace
function! LineHome()
  let x = col('.')
  execute "normal ^"
  if x == col('.')
    execute "normal 0"
  endif
  return ""
endfunction

function! CycleThroughTextWidths()
  if &textwidth == 0
    let x = 80
  elseif &textwidth == 80
    let x = 88
  elseif &textwidth == 88  " Black (Python)
    let x = 120
  elseif &textwidth == 120
    let x = 0
  endif
  let &textwidth = x
  let &colorcolumn = x
  echo "Set textwidth and colorcolumn to" x
endfunction

function! CycleThroughLineNumberingModes()
  if (&number == 0) && (&relativenumber == 0)
    set number
  elseif (&number == 1) && (&relativenumber == 0)
    set relativenumber
  elseif (&number == 1) && (&relativenumber == 1)
    set nonumber
  elseif (&number == 0) && (&relativenumber == 1)
    set norelativenumber
  endif
  echo "Set number=" . &number . ", relativenumber=" . &relativenumber
endfunction

" See https://github.com/bronson/vim-visual-star-search/blob/master/plugin/visual-star-search.vim
function! VisualStarSearchSet(cmdtype,...)
  let temp = @"
  normal! gvy
  if !a:0 || a:1 != 'raw'
    let @" = escape(@", a:cmdtype.'\*')
  endif
  let @/ = substitute(@", '\n', '\\n', 'g')
  let @/ = substitute(@/, '\[', '\\[', 'g')
  let @/ = substitute(@/, '\~', '\\~', 'g')
  let @" = temp
endfunction

function! DeleteAllRegisters()
  let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
  for r in regs
    call setreg(r, [])
  endfor
endfunction

command! DeleteRegisters silent :call DeleteAllRegisters()

" Key mappings
"=======================================

" Map leader key to <Space>
let mapleader = "\<Space>"

" Use jj/jk/Ctrl-c to exit insert mode; en-/disable as desired
"inoremap jj <Esc>
"inoremap jk <Esc>
inoremap <C-c> <Esc>

" For the iPad Pro keyboard without an Esc key and awkward Ctrl placement
inoremap § <Esc>

" Disable K (will be mapped later for LSP support)
noremap K <nop>

" Disable Q (will be mapped later for Deoplete)
nnoremap Q <nop>

" Disable ZZ and ZQ
nnoremap ZZ <nop>
nnoremap ZQ <nop>

" Allow the . to execute once for each line of a visual selection
vnoremap . :normal .<cr>

" Possibly faster file-level word replacement (https://youtu.be/7Bx_mLDBtRc)
nnoremap c* *Ncgn

" Lets * and # perform search in visual mode
xnoremap * :<C-u>call VisualStarSearchSet('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call VisualStarSearchSet('?')<CR>?<C-R>=@/<CR><CR>

"if !exists('s:have_easyclip')
"  " Paste from yank register with <leader>p/P
"  noremap <leader>p "0p
"  noremap <leader>P "0P

"  " Map Y to behave like C, D
"  nmap Y y$
"endif

" Move vertically by visual line
noremap j gj
noremap k gk

" Scroll 5 lines up and down ('set scroll=5' gets reset as soon as window is resized)
nnoremap <C-d> 5<C-d>
nnoremap <C-u> 5<C-u>

vnoremap <C-d> 5<C-d>
vnoremap <C-u> 5<C-u>

" Don't store motions with { or } in the jumplist
nnoremap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}"<cr>
nnoremap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{"<cr>

" Move to beginning of line/first whitespace character or end of line
noremap <leader>0 :call LineHome()<cr>:echo<cr>
noremap <Home> :call LineHome()<cr>:echo<cr>
inoremap <Home> <C-R>=LineHome()<cr>

" Disable highlighting of search results
nnoremap <silent><expr> <leader><Space> (&hls && v:hlsearch ? ':nohlsearch' : ':set hlsearch')."\n"

" Start a new undo sequence when using Ctrl-w (delete last word) or Ctrl-u (delete line) in insert mode
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" Don't lose selection when shifting sidewards
xnoremap <  <gv
xnoremap >  >gv

" Buffer handling shortcuts
" - Switch to previous/next buffer
"nnoremap <leader>[ :bprevious<cr>
"nnoremap <leader>] :bnext<cr>
noremap <silent> <A-j> :bprevious<cr>
noremap <silent> <A-k> :bnext<cr>

" - Quick switching to alternate buffer
nnoremap <silent> \ :b#<cr>

" Shortcuts for window handling
" - Close current window
nnoremap <leader>w <C-w>c

" Use | and _ to split windows (while preserving original behaviour of [count]bar and [count]_).
" (http://howivim.com/2016/andy-stewart/)
nnoremap <expr><silent> <Bar> v:count == 0 ? "<C-W>v<C-W><Right>" : ":<C-U>normal! 0".v:count."<Bar><cr>"
nnoremap <expr><silent> _     v:count == 0 ? "<C-W>s<C-W><Down>"  : ":<C-U>normal! ".v:count."_<cr>"

" Remap cursor keys for faster window switching
nnoremap <silent> <Up> <C-w>k
nnoremap <silent> <Down> <C-w>j
nnoremap <silent> <Left> <C-w>h
nnoremap <silent> <Right> <C-w>l

" Remap cursor keys for nicer quickfix list handling
nnoremap <silent> <leader><Up> :cprevious<cr>
nnoremap <silent> <leader><Down> :cnext<cr>
nnoremap <silent> <leader><Left> :cpfile<cr>
nnoremap <silent> <leader><Right> :cnfile<cr>

" F1: Cycle through (relative) line numbering modes
noremap <F1> :call CycleThroughLineNumberingModes()<cr>

" F2: Toggle text width
noremap <silent> <F2> :call CycleThroughTextWidths()<cr>

" F3: Switch display of unprintable characters
noremap <F3> :set list!<cr>:set list?<cr>

" F4: Switch text wrapping
noremap <F4> :set wrap!<cr>:set wrap?<cr>

" F5: Switch paste mode
noremap <F5> :setlocal paste!<cr>:setlocal paste?<cr>

" F6-F10 mapped by language server client; see below

" F11: usually mapped to 'full screen' by terminal emulator

" F12: Source $MYVIMRC
noremap <silent> <F12> :source $MYVIMRC<cr>:echo "Sourced " . $MYVIMRC . ". (" . strftime('%c'). ")"<cr>

" Shortcut to quickly change/edit $MYVIMRC
nnoremap <silent> <Leader>vc :edit $MYVIMRC<cr>
nnoremap <silent> <Leader>vv :source $MYVIMRC<cr>:echo "Sourced " . $MYVIMRC . ". (" . strftime('%c'). ")"<cr>

" Miscellaneous settings
"=======================================

" Disable visually confusing match highlighting (can still use % to jump to matching parentheses)
let loaded_matchparen = 1

" Expand '%%' to path of current file (see Practical Vim, pg. 101)
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Plugin configurations
"=======================================

if exists('s:have_which_key')
  "nnoremap <silent> <leader> :<C-u>WhichKey '<Space>'<cr>
  nnoremap <silent> <leader>\ :<C-u>WhichKey '<Space>'<cr>
endif

if exists('s:have_grepper')
  " Maps the Grepper operator for normal and visual mode
  nmap gs <plug>(GrepperOperator)
  xmap gs <plug>(GrepperOperator)
  let g:grepper = {'tools': ['rg', 'grep', 'git']}

  " Automatically jump to the first match.
  "let g:grepper.jump = 1

  " Fast search within the file (results opening in quickfix list)
  nnoremap <C-s> :Grepper -buffer<cr>

  " Fast global search (results opening in quickfix list)
  nnoremap <C-q> :Grepper<cr>

  " Invoke search on the word under the cursor
  "nnoremap gs :Grepper -cword -noprompt<cr>
  "xmap gs <Plug>(GrepperOperator)
  nnoremap <Leader>/ :Grepper -cword -noprompt<cr>
  xmap <Leader>/ <Plug>(GrepperOperator)
endif

if exists('s:have_clever_f')
  let g:clever_f_across_no_line = 1  " only search on current line
endif

if exists('s:have_listtoggle')
  " - Height of the location list window
  let g:lt_height = 10
endif

if exists('s:have_bbye')
  " Quick buffer deletion with <Space><Backspace> (using vim-bbye)
  nnoremap <silent> <leader><Bs> :Bdelete<cr>
endif

if exists('s:have_localvimrc')
  let g:localvimrc_ask = 0
  let g:localvimrc_persistent = 1
endif

if exists('s:have_lightline')
  let g:lightline = {}

  let s:lightline_colorschemes = ['wombat', 'solarized', 'powerline', 'powerlineish', 'jellybeans', 'molokai',
    \ 'seoul256', 'darcula', 'selenized_dark', 'Tomorrow', 'Tomorrow_Night', 'Tomorrow_Night_Blue',
    \ 'Tomorrow_Night_Bright', 'Tomorrow_Night_Eighties', 'PaperColor', 'landscape', 'one', 'materia', 'material',
    \ 'OldHope', 'nord', 'deus', 'srcery_drk', 'ayu_mirage', '16color', 'deus']  " According to its doc

  " Colorscheme options include molokai, solarized, jellybeans, wombat, one
  if (s:colorscheme =~ 'solarized' || s:colorscheme =~ 'spring-night')
    let g:lightline.colorscheme = 'solarized'
  elseif (s:colorscheme =~ 'moonfly')
    let g:lightline.colorscheme = 'jellybeans'
  elseif (s:colorscheme =~ 'dracula')
    let g:lightline.colorscheme = 'darcula'
  elseif (s:colorscheme =~ 'vim-monokai-tasty')
    let g:lightline.colorscheme = 'monokai_tasty'
  elseif (index(s:lightline_colorschemes, s:colorscheme) >= 0)
    let g:lightline.colorscheme = s:colorscheme
  endif

  let g:lightline.component_function = {}
  let g:lightline.component_expand = {}
  let g:lightline.component_type = {}

  if exists('s:have_lightline_ale')
    let g:lightline.component_expand.linter_checking = 'lightline#ale#checking'
    let g:lightline.component_expand.linter_errors = 'lightline#ale#errors'
    let g:lightline.component_expand.linter_warnings = 'lightline#ale#warnings'
    let g:lightline.component_expand.linter_ok = 'lightline#ale#ok'

    let g:lightline.component_type.linter_checking = 'left'
    let g:lightline.component_type.linter_errors = 'error'
    let g:lightline.component_type.linter_warning = 'warning'
    let g:lightline.component_type.linter_ok = 'left'
  endif

  if exists('s:have_fugitive')
    let g:lightline.component_function.gitbranch = 'fugitive#head'
  endif

  let g:lightline.active = {
    \   'left':  [
    \              [ 'mode', 'paste' ],
    \              [ 'readonly', 'filename', 'modified', 'gitbranch' ],
    \              [ 'coc_status', 'coc_currentfunction' ],
    \            ],
    \   'right': [
    \              [ 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'fileformat', 'fileencoding', 'filetype' ],
    \              [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
    \            ],
    \ }

  let g:lightline.inactive = {
    \   'left':  [
    \              [ 'readonly', 'filename', 'modified', 'gitbranch' ],
    \            ],
    \   'right': [
    \              [ 'lineinfo' ],
    \              [ 'percent' ],
    \            ],
    \ }

  set noshowmode  " No need to display mode on last line - already on status line
endif

if exists('s:have_vim_rooter')
  let g:rooter_manual_only = 1
  nnoremap <silent> <Leader>r :echo ":Rooter -> no effect (" . getcwd() . ")"<cr> :Rooter<cr>
endif

if exists('s:have_signify')
  let g:signify_vcs_list = ['git']
  let g:signify_realtime = 1
endif

if exists('s:have_fzf')
  if has('nvim')
    " Put fzf in a popup
    " (https://github.com/junegunn/fzf.vim/issues/821#issuecomment-581481211)
    let g:fzf_layout = { 'window': { 'width': 0.85, 'height': 0.75, 'highlight': 'Visual' } }
  endif

  let g:fzf_commits_log_options = '--graph --color=always
    \ --format="%C(yellow)%h%C(red)%d%C(reset)
    \ %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'

  nnoremap <silent> <leader>fh :History<cr>
  nnoremap <silent> <leader>fb :Buffers<cr>
  nnoremap <silent> <leader>ff :Files<cr>
  nnoremap <silent> <leader>fl :Lines<cr>
  " "Sibling" files (files in the same directory as the current.
  nnoremap <silent> <Leader>fs :Files <C-r>=expand("%:h")<cr>/<cr>

  nnoremap <silent> <leader>fw :Windows<cr>
  nnoremap <silent> <leader>fc :Commits<cr>
  nnoremap <silent> <leader>fm :Marks<cr>
  nnoremap <silent> <leader>fp :Maps<cr>
  nnoremap <silent> <leader>fo :Commands<cr>
  nnoremap <silent> <leader>f: :History:<cr>
  nnoremap <silent> <leader>f/ :History/<cr>
  nnoremap <silent> <leader>fg :GFiles?<cr>

  nnoremap <silent> <C-h> :History<cr>
  nnoremap <silent> <C-j> :Buffers<cr>
  nnoremap <silent> <C-k> :Files<cr>
  nnoremap <silent> <C-l> :Lines<cr>
  nnoremap <silent> <C-p> :BLines<cr>

  nnoremap <silent> <C-Space> :Buffers<cr>
endif

if exists('s:have_easy_align')
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
endif

if exists('s:have_nerdtree')
  function! FocusOrCloseNERDTree()
    if bufname('') =~ "^NERD_tree_"
      :NERDTreeToggle
    else
      :NERDTreeFocus
    endif
  endfunction

  function! NTFindOrCloseNERDTree()
    if bufname('') =~ "^NERD_tree_"
      :NERDTreeToggle
    else
      :NERDTreeFind
    endif
  endfunction

  " Open or focus NERDTree with Ctrl-n, or close it if already focused
  nnoremap <silent> <C-n> :call FocusOrCloseNERDTree()<cr>
  nnoremap <silent> <leader>n :call NTFindOrCloseNERDTree()<cr>

  let g:NERDTreeShowHidden=1
  let g:NERDTreeQuitOnOpen = 3
  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeHijackNetrw = 0

  let g:NERDTreeWinPos="left"
  let g:NERDTreeWinSize=28

  let NERDTreeIgnore = ['\.pyc$', '__pycache__', '.swp']

  " - Close vim if the only window left is a NERDTree
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif

if exists('s:have_undotree')
  nnoremap <silent> <Leader>u :UndotreeToggle<cr>
  let g:undotree_WindowLayout = 3
endif

if exists('s:have_indent_line')
  let g:indentLine_enabled = 0
  nnoremap <silent> <Leader>i :IndentLinesToggle<cr>
  let g:indentLine_char = '┆'
endif

if exists('s:have_cutlass')
  " Either, remap m/M key...
  nnoremap gm m

  nnoremap m d
  xnoremap m d

  nnoremap mm dd
  nnoremap M D

  " Or, remap x/X key...
  "nnoremap x d
  "xnoremap x d

  "nnoremap xx dd
  "nnoremap X D
endif

if exists('s:have_yoink')
  let g:yoinkIncludeDeleteOperations = 1

  nmap <c-n> <plug>(YoinkPostPasteSwapBack)
  nmap <c-p> <plug>(YoinkPostPasteSwapForward)

  nmap p <plug>(YoinkPaste_p)
  nmap P <plug>(YoinkPaste_P)

  " Also replace the default gp with yoink paste so we can toggle paste in this case too
  nmap gp <plug>(YoinkPaste_gp)
  nmap gP <plug>(YoinkPaste_gP)

  nmap [y <plug>(YoinkRotateBack)
  nmap ]y <plug>(YoinkRotateForward)

  nmap <c-=> <plug>(YoinkPostPasteToggleFormat)

  nmap y <plug>(YoinkYankPreserveCursorPosition)
  xmap y <plug>(YoinkYankPreserveCursorPosition)
endif

if exists('s:have_subversive')
  " s for substitute
  nmap s <plug>(SubversiveSubstitute)
  nmap ss <plug>(SubversiveSubstituteLine)
  nmap S <plug>(SubversiveSubstituteToEndOfLine)
endif

if exists('s:have_splitline')
  nnoremap <leader>S :SplitLine<cr>
endif

if exists('s:have_sideways')
  nnoremap g< :SidewaysLeft<cr>
  nnoremap g> :SidewaysRight<cr>
endif

if exists('s:have_neoformat')
  let g:neoformat_enabled_python = ['black']
endif

if exists('s:have_ale')
  " Enable some linters. Note that for proper C and C++ support, one should provide a .lvimrc file in the project
  " root directory, with the proper g:ale_c??_[clang|g++]_options settings.
  let g:ale_linters = {
        \ 'json': 'all',
        \ 'markdown': 'all',
        \ 'tex': 'all',
        \ 'vim': 'all',
        \ 'c': ['clangtidy'],
        \ 'cpp': ['clangtidy'],
        \ 'python': [],
        \ }
        "\ 'python': ['flake8', 'mypy'],

  let g:ale_fixers = {
        \ 'c': ['clangtidy'],
        \ 'cpp': ['clangtidy'],
        \ 'python': ['black', 'isort'],
        \ }

  let g:ale_open_list = 0
  let g:ale_lint_delay = 500
  let g:ale_disable_lsp = 1
endif

let s:have_nvim_lsp_installed = isdirectory(expand('<sfile>:p:h') . '/plugged/nvim-lspconfig')

if (s:have_nvim_lsp_installed)
lua << EOF
  require'lspconfig'.ccls.setup{
    init_options = {
      highlight = {
        lsRanges = true;
      }
    }
  }
  require'lspconfig'.pylsp.setup{}
  --require'lspconfig'.pyright.setup{}
  require'lspconfig'.bashls.setup{}
  require'lspconfig'.vimls.setup{}
  require'lspconfig'.cssls.setup{}
  require'lspconfig'.jsonls.setup{}
  require'lspconfig'.yamlls.setup{}
  require'lspconfig'.dockerls.setup{}
  require'lspconfig'.vuels.setup{}
EOF

  autocmd Filetype cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd Filetype bash setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd Filetype vim setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd Filetype css setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd Filetype json setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd Filetype yaml setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd Filetype dockerfile setlocal omnifunc=v:lua.vim.lsp.omnifunc 
  autocmd Filetype dockerfile setlocal omnifunc=v:lua.vim.lsp.omnifunc 

  nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<cr>
  "nnoremap <silent> <F6>  <cmd>lua vim.lsp.buf.rename()<cr>
  nnoremap <silent> <F7>  <cmd>lua vim.lsp.buf.type_definition()<cr>
  nnoremap <silent> <F8>  <cmd>lua vim.lsp.buf.definition()<cr>
  nnoremap <silent> <F9>  <cmd>lua vim.lsp.buf.references()<cr>
  nnoremap <silent> <F10> <cmd>lua vim.lsp.buf.implementation()<cr>
endif

if exists('s:have_float_preview')
  let g:float_preview#auto_close = 0
  autocmd InsertLeave * :call float_preview#close()
endif
