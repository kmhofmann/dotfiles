" Michael's init.vim
" (https://github.com/kmhofmann/dotfiles)
" =======================================
"
" Installation:
"
" * $ cp init.vim ~/.config/nvim/
"
" * Although not tested as extensively, this file should be also usable as a .vimrc for Vim 8+.
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
" * Language server support can be either provided by LanguageClient_Neovim, coc.nvim, or the build-in Neovim LSP
"   client. Choose exactly one below.
"
" * Some language servers:   (see also here for a good overview: https://github.com/neovim/nvim-lsp)
"   - C++:        See https://github.com/MaskRay/ccls
"   - Python:     pip install python-language-server pyls-mypy pyls-isort pyls-black
"   - TypeScript: yarn global add typescript-language-server
"   - Bash:       yarn global add bash-language-server
"   - Vim:        yarn global add vim-language-server
"   - CSS:        yarn global add vscode-css-languageserver-bin
"   - JSON:       yarn global add vscode-json-languageserver
"   - YAML:       yarn global add yaml-language-server
"   - Dockerfile: yarn global add dockerfile-language-server-nodejs
"   - ...
"   For all servers installed with 'yarn global add', $HOME/.yarn/bin needs to be in the $PATH.
"
" * coc.nvim requires node.js and yarn to be installed.
"   Some language support (Python, YAML, HTML, CSS, ...?) is being installed as explicit plugins below.
"   Other languages may require language servers to be installed; see http://langserver.org/.
"   For example, ccls (https://github.com/MaskRay/ccls) for C++. Install using CMake and add binary to PATH.
"
" * nvim: You may have to install the Python 'pynvim' package for some plugins to work correctly.
"   $ pip install [--user] --upgrade pynvim

" Plugin management
"=======================================

" Activate or deactivate categories here:
let s:plugin_categories  = ['colorschemes']
let s:plugin_categories += ['basic']
let s:plugin_categories += ['textsearch']
let s:plugin_categories += ['textediting']
let s:plugin_categories += ['ui_additions']
let s:plugin_categories += ['filesearch']
let s:plugin_categories += ['formatting']
let s:plugin_categories += ['version_control']
let s:plugin_categories += ['development']
let s:plugin_categories += ['linting_completion']
let s:plugin_categories += ['semantic_highlighting']
"let s:plugin_categories += ['julia']
"let s:plugin_categories += ['markdown']
"let s:plugin_categories += ['misc']
"let s:plugin_categories += ['latex']
"let s:plugin_categories += ['disabled']

let s:set_t_8f_t_8b_options = 0
let s:colorscheme_use_base16 = 1
let s:colorscheme = 'vim-monokai-tasty'

" Set these options to your liking
let s:faster_redraw = 0      " Faster redraw disables relative line numbers and cursorline
let s:remap_cursor_keys = 1  " Remap cursor keys

" Choose maximum one of these.
let s:use_nvim_lsp = 0  " Direct Neovim LSP support is very promising, but still a bit new and experimental...
let s:use_languageclient = 1
let s:use_coc_nvim = 0

" Disable a few providers -- enable when needed
if has('nvim')
  let g:loaded_python_provider = 0
  let g:loaded_ruby_provider = 0
  let g:loaded_node_provider = 0
  let g:loaded_perl_provider = 0
endif

" Bootstrap vim-plug automatically, if not already present
if has("unix") || has("macunix")
  if has('nvim')
    let s:vim_plug_autoload_file = '~/.config/nvim/autoload/plug.vim'
  else
    let s:vim_plug_autoload_file = '~/.vim/autoload/plug.vim'
  endif

  if empty(glob(s:vim_plug_autoload_file))
    execute "!curl -fLo " . s:vim_plug_autoload_file .
        \ " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  endif
endif

call plug#begin()
if index(s:plugin_categories, 'colorschemes') >= 0
  Plug 'chriskempson/base16-vim'         " Set of color schemes; see http://chriskempson.com/projects/base16/
  Plug 'patstockwell/vim-monokai-tasty'
  Plug 'morhetz/gruvbox'
  Plug 'jaredgorski/spacecamp'

  " Enable these if desired:
  "Plug 'altercation/vim-colors-solarized'
  "Plug 'tomasr/molokai'
  "Plug 'nanotech/jellybeans.vim'
  "Plug 'rhysd/vim-color-spring-night'
  "Plug 'Nequo/vim-allomancer'
  "Plug 'flrnprz/plastic.vim'
  "Plug 'dracula/vim', { 'as': 'dracula' }

  "Plug 'lifepillar/vim-solarized8'
  "Plug 'larsbs/vimterial_dark'
  "Plug 'TroyFletcher/vim-colors-synthwave'
  "Plug 'bluz71/vim-moonfly-colors'
  "Plug 'google/vim-colorscheme-primary'
  "Plug 'erichdongubler/vim-sublime-monokai'
  "Plug 'euclio/vim-nocturne'
endif

if index(s:plugin_categories, 'basic') >= 0
  if !has('nvim')
    Plug 'drmikehenry/vim-fixkey'          " Permits mapping more classes of characters (e.g. <Alt-?>)
  endif
  Plug 'tpope/vim-eunuch'                " Syntactic sugar for some UNIX shell commands
  Plug 'tpope/vim-repeat'                " Remaps . such that plugin maps can use it
  Plug 'tpope/vim-unimpaired'            " Provide pairs of mappings for []
  Plug 'embear/vim-localvimrc'           " Read local .lvimrc files up the directory tree
  let s:have_localvimrc = 1
  Plug 'schickling/vim-bufonly', { 'on': ['Bonly', 'BOnly', 'Bufonly'] }  " Close all buffers but the current one
  Plug 'moll/vim-bbye', { 'on': ['Bdelete'] }  " Adds :Bdelete command to close buffer but keep window
  let s:have_bbye = 1
  Plug 'tpope/vim-obsession', { 'on': ['Obsess'] }  " Easier session handling
endif

if index(s:plugin_categories, 'textsearch') >= 0
  Plug 'haya14busa/is.vim'               " Improved incremental search
  Plug 'andymass/vim-matchup'            " Improved % motion
  Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }  " Easier grepping
  let s:have_grepper = 1
endif

if index(s:plugin_categories, 'textediting') >= 0
  Plug 'machakann/vim-sandwich'          " better 'surrounding' motion (conflicts with vim-sneak)
  Plug 'drzel/vim-split-line'
  let s:have_splitline = 1
  Plug 'AndrewRadev/sideways.vim'        " Move function arguments sideways
  let s:have_sideways = 1
  Plug 'svermeulen/vim-easyclip'         " Improved clipboard functionality
  let s:have_easyclip = 1
endif

if index(s:plugin_categories, 'ui_additions') >= 0
  Plug 'itchyny/lightline.vim'           " Statusline
  let s:have_lightline = 1
  Plug 'Valloric/ListToggle'             " Easily display or hide quickfix or location list
  let s:have_listtoggle = 1
  Plug 'mbbill/undotree', { 'on': ['UndotreeToggle'] }  " Visualize and act upon undo tree
  let s:have_undotree = 1
  Plug 'Yggdroot/indentLine'
  let s:have_indent_line = 1
  Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
  let s:have_which_key = 1
endif

if index(s:plugin_categories, 'filesearch') >= 0
  if !has("win32")
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    let s:have_fzf = 1
  endif
  Plug 'tpope/vim-vinegar'
  Plug 'scrooloose/nerdtree', { 'on': ['NERDTree', 'NERDTreeFind', 'NERDTreeToggle', 'NERDTreeFocus'] }  " Better file explorer
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTree', 'NERDTreeFind', 'NERDTreeToggle', 'NERDTreeFocus'] }
  let s:have_nerdtree = 1
endif

if index(s:plugin_categories, 'formatting') >= 0
  Plug 'junegunn/vim-easy-align'         " Text alignment made easy
  let s:have_easy_align = 1
  "Plug 'tpope/vim-sleuth'                " Detect and set automatic indentation
  Plug 'Chiel92/vim-autoformat', { 'on': 'Autoformat' }  " Trigger code formatting engines
endif

if index(s:plugin_categories, 'version_control') >= 0
  Plug 'airblade/vim-rooter'             " Changes working directory to project root
  let s:have_vim_rooter = 1
  Plug 'tpope/vim-fugitive'              " Git wrapper
  let s:have_fugitive = 1
  Plug 'rbong/vim-flog', { 'on': ['Flog', 'Flogsplit'] }  " Git commit graph viewer
  Plug 'mhinz/vim-signify'               " Show visual git diff in the gutter
  let s:have_signify = 1
  Plug 'rhysd/git-messenger.vim'
endif

if index(s:plugin_categories, 'development') >= 0
  Plug 'scrooloose/nerdcommenter'        " Commenting code
  Plug 'liuchengxu/vista.vim'
  let s:have_vista = 1

  if has("python") || has("python3")
    Plug 'plytophogy/vim-virtualenv', { 'on': ['VirtualEnvList', 'VirtualEnvActivate', 'VirtualEnvDeactivate'] }  " Improved working with virtualenvs
    Plug 'psf/black'
  endif
endif

if index(s:plugin_categories, 'linting_completion') >= 0 && (v:version >= 800)
  Plug 'dense-analysis/ale'            " Asynchronous Lint Engine
  let s:have_ale = 1

  if exists('s:have_lightline')
    Plug 'maximbaz/lightline-ale'      " ALE indicator for Lightline
    let s:have_lightline_ale = 1
  endif

  if s:use_nvim_lsp && has('nvim-0.5')
    Plug 'neovim/nvim-lsp'             " Configurations for the Neovim LSP client
    let s:have_nvim_lsp = 1
  endif

  if s:use_languageclient
    Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }  " Popular LSP client implementation
    let s:have_language_client_neovim = 1
  endif

  if s:use_coc_nvim
    Plug 'neoclide/coc.nvim', {'branch': 'release'}  " Full Intellisense-style engine implementation, including LSP client
    let s:have_coc_nvim = 1

    if executable('yarn')
      Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
      Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
      Plug 'neoclide/coc-html', {'do': 'yarn install --frozen-lockfile'}
      Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
      Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
    endif
  endif

  " Install Deoplete for nvim-lsp and LanguageClient-neovim.
  if exists('s:have_nvim_lsp') || exists('s:use_languageclient')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }  " Asynchronous completion framework
    Plug 'Shougo/deoplete-lsp'  " ...and integration of LSP support
    if !has('nvim')
      Plug 'roxma/nvim-yarp'
      Plug 'roxma/vim-hug-neovim-rpc'
    endif
    let s:have_deoplete = 1

    if has('nvim-0.4')
      Plug 'ncm2/float-preview.nvim'  " Nicer completion preview window
      let s:have_float_preview = 1
    endif
  endif
endif

if index(s:plugin_categories, 'semantic_highlighting') >= 0
  if has('nvim')
    Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}  " Semantic highlighting of Python code in Neovim
    let s:have_semshi = 1
    "Plug 'arakashic/chromatica.nvim', { 'do': ':UpdateRemotePlugins', 'on': ['ChromaticaStart', 'ChromaticaStop', 'ChromaticaToggle', 'ChromaticaShowInfo', 'ChromaticaDbgAST', 'ChromaticaEnableLog'] }
    "let s:have_chromatica = 1
  endif
  Plug 'jackguo380/vim-lsp-cxx-highlight'  " Semantic highlighting for C++
  let s:have_vim_lsp_cxx_highlight = 1
endif

if index(s:plugin_categories, 'julia') >= 0
  Plug 'JuliaEditorSupport/julia-vim'
endif

if index(s:plugin_categories, 'markdown') >= 0
  if executable('yarn')
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
  endif
endif

if index(s:plugin_categories, 'latex') >= 0
  Plug 'lervag/vimtex'
endif

if index(s:plugin_categories, 'misc') >= 0
  Plug 'junegunn/limelight.vim', { 'on': ['Limelight'] }  " Paragraph-based syntax highlighting
  Plug 'junegunn/goyo.vim', { 'on': ['Goyo'] }  " Distraction-free editing
  let s:have_goyo = 1
endif

if index(s:plugin_categories, 'disabled') >= 0
  "Plug 'rhysd/clever-f.vim'              " extend f/F/t/T to also repeat search
  "let s:have_clever_f = 1
  "Plug 'airblade/vim-accent'             " Easy selection of accented characters (e.g. with <C-X><C-U>)
  "Plug 'tpope/vim-surround'              " 'surrounding' motion
  "Plug 'jeetsukumaran/vim-buffergator'   " Select, list and switch between buffers easily
  "let s:have_buffergator = 1
  "Plug 'ConradIrwin/vim-bracketed-paste' " Automatically set paste mode
  "Plug 'Yilin-Yang/vim-markbar'          " Display accessible marks and surrounding lines in collapsible sidebar
  "let s:have_vim_markbar = 1
  "Plug 'wincent/scalpel'                 " Faster within-file word replacement
  "Plug 'nacitar/a.vim', { 'on': ['A'] }  " Easy switching between header and translation unit
  "Plug 'SirVer/ultisnips'
  ""Plug 'honza/vim-snippets'
  "if has("unix") || has("macunix")
  "  Plug 'jez/vim-superman'              " Read man pages with vim (vman command)
  "endif
  "Plug 'psliwka/vim-smoothie'            " Smooth scrolling done right
  "Plug 'justinmk/vim-dirvish' ", { 'on': ['Dirvish'] }
  "Plug 'kristijanhusak/vim-dirvish-git' ", { 'on': ['Dirvish'] }
  "Plug 'mhinz/vim-startify'              " A fancy start screen
  "Plug 'dstein64/vim-win'
  "Plug 'nathanaelkane/vim-indent-guides', { 'on': ['IndentGuidesEnable', 'IndentGuidesDisable', 'IndentGuidesToggle'] }
endif

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

autocmd Filetype python setlocal softtabstop=4 shiftwidth=4 colorcolumn=120 expandtab
autocmd Filetype cpp    setlocal softtabstop=2 shiftwidth=2 colorcolumn=120 expandtab
autocmd Filetype cmake  setlocal softtabstop=4 shiftwidth=4 colorcolumn=120 expandtab
autocmd Filetype json   setlocal softtabstop=2 shiftwidth=2 colorcolumn=80  expandtab
autocmd Filetype sh     setlocal softtabstop=2 shiftwidth=2 colorcolumn=80  expandtab
autocmd Filetype vim    setlocal softtabstop=2 shiftwidth=2 colorcolumn=120 expandtab textwidth=120

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
if exists('s:set_t_8f_t_8b_options') && (s:set_t_8f_t_8b_options > 0)
  " See :help xterm-true-color
  let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
  let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
endif

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
if !s:faster_redraw
  set relativenumber    " Show relative line numbers
  set cursorline        " Highlight current line
endif

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
  "autocmd VimResized * wincmd =

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

function! s:CheckLastCharIsWhitespace() abort
  let cursor_col = col('.') - 1
  return !cursor_col || getline('.')[cursor_col - 1]  =~# '\s'
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

if !exists('s:have_easyclip')
  " Paste from yank register with <leader>p/P
  noremap <leader>p "0p
  noremap <leader>P "0P

  " Map Y to behave like C, D
  nmap Y y$
endif

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

" Window switching using <leader><number> (Source: http://stackoverflow.com/a/6404246/151007)
"let i = 1
"while i <= 9
"  execute 'nnoremap <silent> <leader>'.i.' :'.i.'wincmd w<cr>'
"  let i = i + 1
"endwhile

" Use | and _ to split windows (while preserving original behaviour of [count]bar and [count]_).
" (http://howivim.com/2016/andy-stewart/)
nnoremap <expr><silent> <Bar> v:count == 0 ? "<C-W>v<C-W><Right>" : ":<C-U>normal! 0".v:count."<Bar><cr>"
nnoremap <expr><silent> _     v:count == 0 ? "<C-W>s<C-W><Down>"  : ":<C-U>normal! ".v:count."_<cr>"

" Shortcuts for tab handling (:tabprevious and :tabnext are already mapped to C-PgUp and C-PgDn)
"nnoremap <A-n> :tabnew<cr>
"nnoremap <A-c> :tabclose<cr>

if s:remap_cursor_keys
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
endif

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
  nnoremap <silent> <leader> :<C-u>WhichKey '<Space>'<cr>
endif

if exists('s:have_grepper')
  " Maps the Grepper operator for normal and visual mode
  nmap gs <plug>(GrepperOperator)
  xmap gs <plug>(GrepperOperator)
  let g:grepper = {'tools': ['rg', 'grep', 'git']}

  " Fast search within the file (results opening in quickfix list)
  nnoremap <C-s> :Grepper -buffer<cr>
  " Fast global search (results opening in quickfix list)
  nnoremap <C-q> :Grepper<cr>
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

  if exists('s:have_coc_nvim')
    function! CocCurrentFunction()
      return get(b:, 'coc_current_function', '')
    endfunction

    let g:lightline.component_function.coc_status = 'coc#status'
    let g:lightline.component_function.coc_currentfunction = 'CocCurrentFunction'

    autocmd User CocStatusChange, CocDiagnosticChange call lightline#update()
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

  nnoremap <silent> <leader>fh :History<cr>
  nnoremap <silent> <leader>fb :Buffers<cr>
  nnoremap <silent> <leader>ff :Files<cr>
  nnoremap <silent> <leader>fl :Lines<cr>

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
  "nnoremap <silent> <C-\> :GFiles?<cr>
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
  "let g:indentLine_setColors = 0
  "let g:indentLine_char = '┆'
endif

if exists('s:have_easyclip')
  nnoremap gm m
  let g:EasyClipAlwaysMoveCursorToEndOfPaste = 1
endif

if exists('s:have_splitline')
  nnoremap S :SplitLine<cr>
endif

if exists('s:have_sideways')
  nnoremap g< :SidewaysLeft<cr>
  nnoremap g> :SidewaysRight<cr>
endif

if exists('s:have_semshi')
  " We'll let the LSP server take care of that.
  let g:semshi#error_sign = v:false
endif

if exists('s:have_chromatica')
  if has("unix") || has("macunix")
    " Yay, an elaborate scheme to find libclang.so, including caching the found location
    let g:chromatica#libclang_path = ""
    let s:vim_home = expand('<sfile>:p:h')  " (n)vim configuration directory
    let s:libclang_path_cache_file = s:vim_home . '/libclang_location_cache'
    if empty(glob(s:libclang_path_cache_file))
      " Find clang, get its base path (one dir up), and try to find libclang.so
      let s:clang_base_path = fnamemodify(system("which clang"), ":p:h:h")
      let s:libclang_paths = systemlist('find ' . s:clang_base_path . '/lib -name "libclang.so"')
      if len(s:libclang_paths) > 0
        " Pick the last, hoping that the list is already sorted (by version number)
        let g:chromatica#libclang_path = s:libclang_paths[-1]
      endif
      " Write out the path to a cache file
      call writefile(split(g:chromatica#libclang_path, "\n"), s:libclang_path_cache_file)
    else
      " Read the cache file
      let s:libclang_path_cache_file = readfile(s:libclang_path_cache_file)
      if len(s:libclang_path_cache_file) > 0
        let g:chromatica#libclang_path = s:libclang_path_cache_file[0]
      endif
    endif
  endif

  let g:chromatica#enable_at_startup=0
  let g:chromatica#highlight_feature_level=1
  let g:chromatica#responsive_mode=1
endif

if exists('s:have_vista')
  let g:vista_sidebar_position = "vertical botright"
  let g:vista_sidebar_width = 42
  let g:vista_echo_cursor_strategy = "floating_win"

  nnoremap <silent> <C-\> :Vista!!<cr>
endif

if exists('s:have_vim_lsp_cxx_highlight')
  "let g:lsp_cxx_hl_log_file = '/tmp/vim-lsp-cxx-hl.log'
  "let g:lsp_cxx_hl_verbose_log = 1
endif

if exists('s:have_ale')
  " Enable some linters. Note that for proper C and C++ support, one should provide a .lvimrc file in the project
  " root directory, with the proper g:ale_c??_[clang|g++]_options settings.
  let g:ale_linters = {
        \ 'json': 'all',
        \ 'markdown': 'all',
        \ 'python': ['flake8', 'mypy'],
        \ 'tex': 'all',
        \ 'vim': 'all',
        \ 'c': ['clangtidy'],
        \ 'cpp': ['clangtidy'],
        \ }

  let g:ale_fixers = {
        \ 'c': ['clangtidy'],
        \ 'cpp': ['clangtidy'],
        \ 'python': ['black', 'isort'],
        \ }

  let g:ale_open_list = 0
  let g:ale_lint_delay = 500
  let g:ale_disable_lsp = 1
endif

if exists('s:have_coc_nvim')
  " See https://github.com/neoclide/coc.nvim for example options.

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Use TAB to trigger completion, and navigate through list. (Use ':verbose imap <tab>' to ensure TAB is not mapped.)
  inoremap <silent><expr> <tab> pumvisible() ? "\<C-n>" : <SID>CheckLastCharIsWhitespace() ? "\<tab>" : coc#refresh()
  inoremap <silent><expr> <S-tab> pumvisible() ? "\<C-p>" : "\<C-h>"

  " Use Enter to confirm completion
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<cr>"

  " Use `[c` and `]c` to navigate diagnostics
  nmap <silent> [c <Plug>(coc-diagnostic-prev)
  nmap <silent> ]c <Plug>(coc-diagnostic-next)

  " Map function keys for LSP functionality
  nmap <silent> <F6>  <Plug>(coc-rename)
  nmap <silent> <F7>  <Plug>(coc-type-definition)
  nmap <silent> <F8>  <Plug>(coc-definition)
  nmap <silent> <F9>  <Plug>(coc-references)
  nmap <silent> <F10> <Plug>(coc-implementation)

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <sid>show_documentation()<cr>

  " Remap for format selected region
  xmap <leader>fo <Plug>(coc-format-selected)
  nmap <leader>fo <Plug>(coc-format-selected)

  if exists('s:have_vista')
    let g:vista_default_executive = "coc"
  endif
endif

let s:have_nvim_lsp_installed = isdirectory(expand('<sfile>:p:h') . '/plugged/nvim-lsp')

if exists('s:have_nvim_lsp') && (s:have_nvim_lsp_installed)
  " First, let's check for some common language servers and enable support for them.
  " Feel free to comment out the ones that are not used...

  if executable('ccls')
    "call luaeval("require'nvim_lsp'.ccls.setup{}")
lua <<EOF
require'nvim_lsp'.ccls.setup{
  init_options = {
    highlight = {
      lsRanges = true;
    }
  }
}
EOF
    autocmd Filetype cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc
  endif

  if executable('pyls')
    call luaeval("require'nvim_lsp'.pyls.setup{}")
    autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
  endif

  if executable('bash-language-server')
    call luaeval("require'nvim_lsp'.bashls.setup{}")
    autocmd Filetype bash setlocal omnifunc=v:lua.vim.lsp.omnifunc
  endif

  if executable('vim-language-server')
    call luaeval("require'nvim_lsp'.vimls.setup{}")
    autocmd Filetype vim setlocal omnifunc=v:lua.vim.lsp.omnifunc
  endif

  if executable('css-languageserver')
    call luaeval("require'nvim_lsp'.cssls.setup{}")
    autocmd Filetype css setlocal omnifunc=v:lua.vim.lsp.omnifunc
  endif

  if executable('vscode-json-languageserver')
    call luaeval("require'nvim_lsp'.jsonls.setup{}")
    autocmd Filetype json setlocal omnifunc=v:lua.vim.lsp.omnifunc
  endif

  if executable('yaml-language-server')
    call luaeval("require'nvim_lsp'.yamlls.setup{}")
    autocmd Filetype yaml setlocal omnifunc=v:lua.vim.lsp.omnifunc
  endif

  if executable('docker-langserver')
    call luaeval("require'nvim_lsp'.dockerls.setup{}")
    autocmd Filetype dockerfile setlocal omnifunc=v:lua.vim.lsp.omnifunc 
  endif

  nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<cr>
  "nnoremap <silent> <F6>  <cmd>lua vim.lsp.buf.rename()<cr>
  nnoremap <silent> <F7>  <cmd>lua vim.lsp.buf.type_definition()<cr>
  nnoremap <silent> <F8>  <cmd>lua vim.lsp.buf.definition()<cr>
  nnoremap <silent> <F9>  <cmd>lua vim.lsp.buf.references()<cr>
  nnoremap <silent> <F10> <cmd>lua vim.lsp.buf.implementation()<cr>

  "inoremap <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : <sid>CheckLastCharIsWhitespace() ? "\<Tab>" : "\<C-x>\<C-o>"
  "inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"

  "inoremap <silent> <C-Space> <C-x><C-o>

  if exists('s:have_vista')
    let g:vista_default_executive = "nvim_lsp"
  endif
endif

if exists('s:have_language_client_neovim')
  let g:LanguageClient_serverCommands = {}
  let g:LanguageClient_rootMarkers = {}
  if executable('ccls')
    let s:ccls_settings = {
        \ 'highlight': { 'lsRanges' : v:true },
        \ }
    let g:LanguageClient_serverCommands.c = ['ccls', '-init=' . json_encode(s:ccls_settings)]
    let g:LanguageClient_serverCommands.cpp = ['ccls', '-init=' . json_encode(s:ccls_settings)]
    let g:LanguageClient_serverCommands.cuda = ['ccls', '-init=' . json_encode(s:ccls_settings)]
    let g:LanguageClient_serverCommands.objc = ['ccls', '-init=' . json_encode(s:ccls_settings)]
    let g:LanguageClient_rootMarkers['c'] = ['compile_commands.json', '.ccls', '.ccls_root']
    let g:LanguageClient_rootMarkers['cpp'] = ['compile_commands.json', '.ccls', '.ccls_root']
    let g:LanguageClient_rootMarkers['cuda'] = ['compile_commands.json', '.ccls', '.ccls_root']
    let g:LanguageClient_rootMarkers['objc'] = ['compile_commands.json', '.ccls', '.ccls_root']
  endif
  if executable('pyls')
    let g:LanguageClient_serverCommands.python = ['pyls']
  endif
  if executable('bash-language-server')
    let g:LanguageClient_serverCommands.sh = ['bash-language-server', 'start']
  endif
  if executable('vim-language-server')
    let g:LanguageClient_serverCommands.vim = ['vim-language-server', '--stdio']
  endif
  if executable('css-languageserver')
    let g:LanguageClient_serverCommands.css = ['css-languageserver', '--stdio']
  endif
  if executable('vscode-json-languageserver')
    let g:LanguageClient_serverCommands.json = ['vscode-json-languageserver]', '--stdio']
  endif
  if executable('yaml-language-server')
    let g:LanguageClient_serverCommands.yaml = ['yaml-language-server', '--stdio']
  endif
  if executable('docker-langserver')
    let g:LanguageClient_serverCommands.dockerfile = ['docker-langserver', '--stdio']
  endif

  " Does not work as-is...
  "if index(s:plugin_categories, 'julia') >= 0
  "  "let g:default_julia_version = '1.0'
  "  let g:LanguageClient_serverCommands.julia =
  "    \ ['julia', '--startup-file=no', '--history-file=no', '-e', '
  "    \   using LanguageServer;
  "    \   using Pkg;
  "    \   import StaticLint;
  "    \   import SymbolServer;
  "    \   debug = true; 
  "    \   env_path = dirname(Pkg.Types.Context().env.project_file);
  "    \   server = LanguageServer.LanguageServerInstance(stdin, stdout, debug, env_path, "");
  "    \   server.runlinter = true;
  "    \   run(server); ']
  "endif

  let g:LanguageClient_selectionUI = "location-list"
  "let g:LanguageClient_useVirtualText = "Diagnostics"

  "let s:vim_home = expand('<sfile>:p:h')  " (n)vim configuration directory
  "let g:LanguageClient_loadSettings = 1
  "let g:LanguageClient_settingsPath = s:vim_home . '/language_client_settings.json'
  "let g:LanguageClient_loggingFile = s:vim_home . '/language_client_log.txt'

  "setlocal completefunc=LanguageClient#complete
  setlocal formatexpr=LanguageClient_textDocument_rangeFormatting()

  function LC_maps()
    if has_key(g:LanguageClient_serverCommands, &filetype)
      nnoremap <silent> K     :call LanguageClient_textDocument_hover()<cr>
      nnoremap <silent> <F6>  :call LanguageClient_textDocument_rename()<cr>
      nnoremap <silent> <F7>  :call LanguageClient_textDocument_typeDefinition()<cr>
      nnoremap <silent> <F8>  :call LanguageClient_textDocument_definition()<cr>
      nnoremap <silent> <F9>  :call LanguageClient_textDocument_references()<cr>
      nnoremap <silent> <F10> :call LanguageClient_textDocument_implementation()<cr>
    endif
  endfunction

  autocmd FileType * call LC_maps()

  if exists('s:have_vista')
    let g:vista_default_executive = "lcn"
  endif
endif

if exists('s:have_deoplete')
  let g:deoplete#enable_at_startup = 1
  " Close preview window automatically when completion is finished.
  autocmd InsertLeave * if pumvisible() == 0 | pclose | endif

  inoremap <silent><expr> <Tab> pumvisible() ? deoplete#complete_common_string() : "\<Tab>"
  inoremap <silent><expr> <C-h> deoplete#smart_close_popup()."\<C-h>"
  inoremap <silent><expr> <bs>  deoplete#smart_close_popup()."\<C-h>"

  set completeopt+=menuone,noselect
  set completeopt-=preview
  set shortmess+=c

  let s:deoplete_enabled = 1
  function! CheckDeopleteStatus()
    if s:deoplete_enabled == 1
      :call deoplete#disable()
      echo "Deoplete disabled."
    else
      :call deoplete#enable()
      echo "Deoplete enabled."
    endif
    let s:deoplete_enabled = 1 - s:deoplete_enabled
  endfunction

  " Shortcut to disable Deoplete
  nnoremap Q :call CheckDeopleteStatus()<cr>
endif

if exists('s:have_float_preview')
  let g:float_preview#auto_close = 0
  autocmd InsertLeave * :call float_preview#close()
endif

if exists('s:have_goyo')
  let g:goyo_width = 120
  autocmd! User GoyoEnter Limelight
  autocmd! User GoyoLeave Limelight!
endif
