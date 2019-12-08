" Michael's .vimrc
" (https://github.com/kmhofmann/dotfiles)
" =======================================
"
" Installation:
"
" * $ cp .vimrc ~
"
" * If not present yet, the plugin manager vim-plug will be bootstrapped.
"   See https://github.com/junegunn/vim-plug on how to use vim-plug.
"
" * You can alter the list of plugins by editing the 's:plugin_categories' list
"   below. After installation of new plugins, just restart vim.
"
" * All mentioned plugins will be installed from GitHub. Check their respective
"   pages for functionality and documentation.
"
" * coc.nvim requires language servers to be installed; see http://langserver.org/.
"   For example:
"   - ccls (https://github.com/MaskRay/ccls)
"     - Setup using CMake and add binary to PATH.
"   - python-language-server
"     $ pip install --user --upgrade python-language-server
"     $ pip install --user --upgrade 'python-language-server[all]'
"     - Add $HOME/.local/bin to the PATH.
"
" * coc.nvim itself requires some setup.
"   - node.js needs to be present.
"   - Set up language servers, e.g.:
"     - https://github.com/neoclide/coc.nvim/wiki/Language-servers#ccobjective-c
"     - https://github.com/neoclide/coc.nvim/wiki/Language-servers#python
"       - :CocInstall coc-python
"
" * nvim: You may have to install the Python 'pynvim' package for some plugins to
"         work correctly.
"   $ pip install --user --upgrade pynvim

" Plugin management
"=======================================

" Activate or deactivate categories here:
let s:plugin_categories  = ['colorschemes']
let s:plugin_categories += ['basic']
let s:plugin_categories += ['textsearch']
let s:plugin_categories += ['textediting']
let s:plugin_categories += ['ui_additions']
let s:plugin_categories += ['filesearch']
let s:plugin_categories += ['sessions']
let s:plugin_categories += ['formatting']
let s:plugin_categories += ['version_control']
let s:plugin_categories += ['development']
let s:plugin_categories += ['semantic_highlighting']
let s:plugin_categories += ['linting_completion']
let s:plugin_categories += ['misc']
"let s:plugin_categories += ['disabled']

let s:colorscheme_use_base16 = 1
let s:colorscheme = 'vim-monokai-tasty'

" Set these options to your liking
let s:faster_redraw = 0      " Faster redraw disables relative line numbers and cursorline
let s:remap_cursor_keys = 0  " Remap cursor keys

" Bootstrap vim-plug automatically, if not already present
if has("unix") || has("macunix")
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    "autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
elseif has("win32")
  if empty(glob('~/vimfiles/autoload/plug.vim'))
    echo "You will need to install vim-plug manually for this .vimrc to work."
    echo "(https://github.com/junegunn/vim-plug)"
    exit
  endif
endif

call plug#begin()
if index(s:plugin_categories, 'colorschemes') >= 0
  Plug 'sjl/badwolf'
  Plug 'tomasr/molokai'
  Plug 'patstockwell/vim-monokai-tasty'
  Plug 'erichdongubler/vim-sublime-monokai'
  Plug 'euclio/vim-nocturne'
  Plug 'nanotech/jellybeans.vim'
  Plug 'altercation/vim-colors-solarized'
  Plug 'lifepillar/vim-solarized8'
  Plug 'google/vim-colorscheme-primary'
  Plug 'larsbs/vimterial_dark'
  Plug 'bluz71/vim-moonfly-colors'
  Plug 'dracula/vim', { 'as': 'dracula' }
  Plug 'TroyFletcher/vim-colors-synthwave'
  Plug 'rhysd/vim-color-spring-night'
  Plug 'Nequo/vim-allomancer'
  Plug 'flrnprz/plastic.vim'
  Plug 'chriskempson/base16-vim'         " Set of color schemes; see https://chriskempson.github.io/base16/
endif

if index(s:plugin_categories, 'basic') >= 0
  if !has('nvim')
    Plug 'drmikehenry/vim-fixkey'          " Permits mapping more classes of characters (e.g. <Alt-?>)
  endif
  Plug 'tpope/vim-eunuch'                " Syntactic sugar for some UNIX shell commands
  Plug 'tpope/vim-repeat'                " Remaps . such that plugin maps can use it
  Plug 'machakann/vim-sandwich'          " better 'surrounding' motion (conflicts with vim-sneak)
  Plug 'tpope/vim-unimpaired'            " Provide pairs of mappings for []
  Plug 'embear/vim-localvimrc'           " Read local .lvimrc files up the directory tree
  Plug 'tpope/vim-obsession', { 'on': ['Obsess'] }  " Easier session handling
  let s:have_localvimrc = 1
  Plug 'drzel/vim-split-line'
  let s:have_splitline = 1
  Plug 'moll/vim-bbye', { 'on': ['Bdelete'] }  " Adds :Bdelete command to close buffer but keep window
  let s:have_bbye = 1
endif

if index(s:plugin_categories, 'textsearch') >= 0
  Plug 'bronson/vim-visual-star-search'  " Lets * and # perform search in visual mode
  Plug 'haya14busa/is.vim'               " Improved incremental search
  Plug 'andymass/vim-matchup'            " Improved % motion
  Plug 'rhysd/clever-f.vim'              " extend f/F/t/T to also repeat search
  let s:have_clever_f = 1
  Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }  " Easier grepping
  let s:have_grepper = 1
endif

if index(s:plugin_categories, 'textediting') >= 0
  Plug 'svermeulen/vim-easyclip'         " Improved clipboard functionality
  let s:have_easyclip = 1
  Plug 'AndrewRadev/sideways.vim'        " Move function arguments sideways
  let s:have_sideways = 1
endif

if index(s:plugin_categories, 'ui_additions') >= 0
  Plug 'itchyny/lightline.vim'           " Statusline
  let s:have_lightline = 1
  Plug 'Valloric/ListToggle'             " Easily display or hide quickfix or location list
  let s:have_listtoggle = 1
  Plug 'mbbill/undotree', { 'on': ['UndotreeToggle'] }  " Visualize and act upon undo tree
  let s:have_undotree = 1
  Plug 'mhinz/vim-startify'              " A fancy start screen
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
  Plug 'tpope/vim-sleuth'                " Detect and set automatic indentation
  Plug 'Chiel92/vim-autoformat', { 'on': 'Autoformat' }  " Trigger code formatting engines
endif

if index(s:plugin_categories, 'version_control') >= 0
  Plug 'airblade/vim-rooter'             " Changes working directory to project root
  Plug 'tpope/vim-fugitive'              " Git wrapper
  let s:have_fugitive = 1
  Plug 'mhinz/vim-signify'               " Show visual git diff in the gutter
  let s:have_signify = 1
endif

if index(s:plugin_categories, 'development') >= 0
  Plug 'scrooloose/nerdcommenter'        " Commenting code
  if has("python") || has("python3")
    Plug 'plytophogy/vim-virtualenv', { 'on': ['VirtualEnvList', 'VirtualEnvActivate', 'VirtualEnvDeactivate'] }  " Improved working with virtualenvs
  endif
endif

if index(s:plugin_categories, 'semantic_highlighting') >= 0
  if has('nvim')
    Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}  " Semantic highlighting in Neovim
    Plug 'arakashic/chromatica.nvim', { 'do': ':UpdateRemotePlugins', 'on': ['ChromaticaStart', 'ChromaticaStop', 'ChromaticaToggle', 'ChromaticaShowInfo', 'ChromaticaDbgAST', 'ChromaticaEnableLog'] }
    let s:have_chromatica = 1
  endif
endif

if index(s:plugin_categories, 'linting_completion') >= 0
  if (v:version >= 800)
    Plug 'w0rp/ale'                      " Asynchronous Lint Engine
    let s:have_ale = 1

    if exists('s:have_lightline')
      Plug 'maximbaz/lightline-ale'      " ALE indicator for Lightline
      let s:have_lightline_ale = 1
    endif

    Plug 'neoclide/coc.nvim', {'do': './install.sh'}
    let s:have_coc_nvim = 1
  endif
endif

if index(s:plugin_categories, 'misc') >= 0
  Plug 'junegunn/limelight.vim', { 'on': ['Limelight'] }  " Paragraph-based syntax highlighting
  Plug 'junegunn/goyo.vim', { 'on': ['Goyo'] }  " Distraction-free editing
  let s:have_goyo = 1
endif

if index(s:plugin_categories, 'disabled') >= 0
  Plug 'airblade/vim-accent'             " Easy selection of accented characters (e.g. with <C-X><C-U>)
  Plug 'tpope/vim-surround'              " 'surrounding' motion
  Plug 'jeetsukumaran/vim-buffergator'   " Select, list and switch between buffers easily
  let s:have_buffergator = 1
  Plug 'ConradIrwin/vim-bracketed-paste' " Automatically set paste mode
  Plug 'Yilin-Yang/vim-markbar'          " Display accessible marks and surrounding lines in collapsible sidebar
  let s:have_vim_markbar = 1
  Plug 'schickling/vim-bufonly', { 'on': ['Bonly', 'BOnly', 'Bufonly'] }  " Close all buffers but the current one
  Plug 'wincent/scalpel'                 " Faster within-file word replacement
  Plug 'nacitar/a.vim', { 'on': ['A'] }  " Easy switching between header and translation unit
  Plug 'SirVer/ultisnips'
  "Plug 'honza/vim-snippets'
  if has("unix") || has("macunix")
    Plug 'jez/vim-superman'              " Read man pages with vim (vman command)
  endif
  Plug 'psliwka/vim-smoothie'            " Smooth scrolling done right
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

if !has("gui_running") && !has('nvim')
  set term=screen-256color
  set t_Co=256
endif

if index(s:plugin_categories, 'colorschemes') >= 0
  let g:solarized_termcolors=256 " Use the inaccurate 256 color scheme for solarized.
  if has('nvim')
    set termguicolors
  endif

  if (exists('s:colorscheme_use_base16') && s:colorscheme_use_base16 == 1 && !has("gui_running") && filereadable(expand("~/.vimrc_background")))
    " Use the base16 color schemes, if available. See https://github.com/chriskempson/base16-shell.
    let base16colorspace=256
    source ~/.vimrc_background
  else
    " Use the color scheme defined above.
    execute 'colorscheme ' . s:colorscheme
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
set lazyredraw          " Redraw only when we need to.
set showmatch           " Highlight matching [{()}]
set mat=2               " How many tenths of a second to blink when matching brackets
set splitbelow          " New horizontal splits open below
set splitright          " New vertical splits open to the right
set foldenable          " Enable folding
set synmaxcol=300       " Highlight up to 300 columns

set number              " Show line numbers
if !s:faster_redraw
  set relativenumber    " Show relative line numbers
  set cursorline        " Highlight current line
endif

" Allow mapping of meta/option key in MacVim
if has("macunix") && has("gui_running")
  set macmeta
endif

" Better font in Windows GUI
if has("win32") && has("gui_running")
  set guifont=Consolas:h11
endif

augroup MichaelAutocmnds
  " Resize splits when window gets resized
  autocmd VimResized * wincmd =
  " Disable paste mode when leaving insert mode
  autocmd InsertLeave * set nopaste
augroup END

" netrw
let g:netrw_liststyle = 1   " 'long' listing, with file details

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

function! ToggleTextWidth()
  if &textwidth == 0
    let x = 80
  elseif &textwidth == 80
    let x = 120
  elseif &textwidth == 120
    let x = 0
  endif
  let &textwidth = x
  let &colorcolumn = x
  echo "Set textwidth and colorcolumn to" x
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

" Use 'jj'/'jk' to exit insert mode; en-/disable as desired
inoremap jj <Esc>
"inoremap jk <Esc>
inoremap § <Esc>

" Disable K (might be mapped for LanguageClient_neovim)
noremap K <nop>

" Disable Q (to be mapped sensibly otherwise?)
nnoremap Q <nop>

" Disable ZZ and ZQ
nnoremap ZZ <nop>
nnoremap ZQ <nop>

" Allow the . to execute once for each line of a visual selection
vnoremap . :normal .<cr>

" Possibly faster file-level word replacement (https://youtu.be/7Bx_mLDBtRc)
nnoremap c* *Ncgn

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

" Scroll 5 lines up and down
noremap <C-d> 5<C-d>
noremap <C-u> 5<C-u>

" When using clever-f, , and ; can be remapped to something else
if exists('s:have_clever_f')
  if exists('s:have_fzf')
    nnoremap <silent> , :Buffers<cr>
  elseif exists('s:have_buffergator')
    nnoremap <silent> , :BuffergatorOpen<cr>
  endif
  nnoremap <silent> ; :b#<cr>
endif

" Switch to previous/next buffer
"noremap <silent> <A-j> :bprevious<cr>
"noremap <silent> <A-k> :bnext<cr>

" Quick switching to alternate buffer
"noremap <silent> <A-l> :b#<cr>
"nnoremap <silent> <leader>a :b#<cr>

" Move to beginning of line/first whitespace character or end of line
noremap <leader>0 :call LineHome()<cr>:echo<cr>
noremap <Home> :call LineHome()<cr>:echo<cr>
inoremap <Home> <C-R>=LineHome()<cr>

" Quick window switching with Ctrl-h/j/k/l
noremap  <C-h>  <C-w>h
noremap  <C-j>  <C-w>j
noremap  <C-k>  <C-w>k
noremap  <C-l>  <C-w>l

" Movement in insert mode with Ctrl-h/j/k/l
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" Don't lose selection when shifting sidewards
xnoremap <  <gv
xnoremap >  >gv

" Shortcuts for window handling
"nnoremap <leader>r <C-w>r  " rotate windows
nnoremap <leader>w <C-w>c  " close current window

" Window switching using <leader><number> (Source: http://stackoverflow.com/a/6404246/151007)
let i = 1
while i <= 9
  execute 'nnoremap <silent> <leader>'.i.' :'.i.'wincmd w<cr>'
  let i = i + 1
endwhile

" Use | and _ to split windows (while preserving original behaviour of [count]bar and [count]_).
" (http://howivim.com/2016/andy-stewart/)
" (currently deactivated because of unwanted interactions e.g. with 'f_' when '_' is not contained in line)
"nnoremap <expr><silent> <Bar> v:count == 0 ? "<C-W>v<C-W><Right>" : ":<C-U>normal! 0".v:count."<Bar><cr>"
"nnoremap <expr><silent> _     v:count == 0 ? "<C-W>s<C-W><Down>"  : ":<C-U>normal! ".v:count."_<cr>"

" Disable highlighting of search results
nnoremap <silent><expr> <leader><Space> (&hls && v:hlsearch ? ':nohlsearch' : ':set hlsearch')."\n"

" Cursor keys for nicer quickfix list handling
if s:remap_cursor_keys
  nnoremap <silent> <Up> :cprevious<cr>
  nnoremap <silent> <Down> :cnext<cr>
  nnoremap <silent> <Left> :cpfile<cr>
  nnoremap <silent> <Right> :cnfile<cr>
endif

" F1: Switch line numbering
noremap <F1> :set number!<cr>:set number?<cr>

" F2: Switch relative line numbering
noremap <F2> :set relativenumber!<cr>:set relativenumber?<cr>

" F3: Switch display of unprintable characters
noremap <F3> :set list!<cr>:set list?<cr>

" F4: Switch text wrapping
noremap <F4> :set wrap!<cr>:set wrap?<cr>

" F5: Switch paste mode
noremap <F5> :setlocal paste!<cr>:setlocal paste?<cr>

" F6: Toggle text width
noremap <silent> <F6> :call ToggleTextWidth()<cr>

" F7-F10 mapped by coc.nvim below
" F11: usually mapped to 'full screen' by terminal emulator

" F12: Source .vimrc
noremap <silent> <F12> :source $MYVIMRC<cr>

" Miscellaneous settings
"=======================================

" Disable visually confusing match highlighting (can still use % to jump to matching parentheses)
let loaded_matchparen = 1

" Expand '%%' to path of current file (see Practical Vim, pg. 101)
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Plugin configurations
"=======================================

if exists('s:have_splitline')
  nnoremap S :SplitLine<cr>
endif

if exists('s:have_grepper')
  " Maps the Grepper operator for normal and visual mode
  nmap gs <plug>(GrepperOperator)
  xmap gs <plug>(GrepperOperator)
  let g:grepper = {'tools': ['rg', 'ag', 'ack', 'grep', 'findstr', 'pt', 'git']}

  " Fast search within the file (results opening in quickfix list)
  nnoremap <C-s> :Grepper -buffer -query 
  " Fast global search (results opening in quickfix list)
  nnoremap <C-q> :Grepper -query 
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

if exists('s:have_signify')
  let g:signify_vcs_list = ['git']
  let g:signify_realtime = 1
endif

if exists('s:have_fzf')
  nnoremap <silent> <C-p> :FZF<cr>
  nnoremap <silent> <leader>ff :Files<cr>
  nnoremap <silent> <leader>fb :Buffers<cr>
  nnoremap <silent> <leader>fw :Windows<cr>
  nnoremap <silent> <leader>fm :Marks<cr>
  nnoremap <silent> <leader>fh :History<cr>
  nnoremap <silent> <leader>fl :Lines<cr>
  nnoremap <silent> <leader>fc :Commits<cr>

  nnoremap <silent> \ :Buffers<cr>
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
      "wincmd =
    else
      :NERDTreeFocus
      "wincmd =
    endif
  endfunction

  " Open or focus NERDTree with Ctrl-n, or close it if already focused
  "nnoremap <silent> <expr> <C-n> bufname('') =~ "^NERD_tree_" ? ':NERDTreeClose<cr>' : ':NERDTreeFocus<cr>'
  nnoremap <silent> <C-n> :call FocusOrCloseNERDTree()<cr>
  " Find current file in NERDTree
  "noremap <silent> <F9> :NERDTreeFind<cr>
  let g:NERDTreeShowHidden=1
  let g:NERDTreeStatusline="%f"
  let g:NERDTreeWinPos="left"
  let NERDTreeIgnore = ['\.pyc$', '__pycache__', '.swp']
  " - Close vim if the only window left is a NERDTree
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif

if exists('s:have_undotree')
  nnoremap <silent> <Leader>u :UndotreeToggle<cr>
  let g:undotree_WindowLayout = 3
endif

if exists('s:have_easyclip')
  nnoremap gm m
  let g:EasyClipAlwaysMoveCursorToEndOfPaste = 1
endif

if exists('s:have_sideways')
  nnoremap g< :SidewaysLeft<cr>
  nnoremap g> :SidewaysRight<cr>
endif

if exists('s:have_chromatica')
  let g:chromatica#libclang_path = fnamemodify(system("which clang"), ":p:h:h") . "/lib/libclang.so"
  let g:chromatica#enable_at_startup=0
  let g:chromatica#highlight_feature_level=1
  let g:chromatica#responsive_mode=1
endif

if exists('s:have_ale')
  " - Enable some linters. Note that for proper C and C++ support, one should provide a .lvimrc file in the project
  "   root directory, with the proper g:ale_c??_[clang|g++]_options settings. Basic options are set here, but they
  "   most likely aren't sufficient for most projects (no include paths provided here).
  let g:ale_linters = {
        \ 'json': 'all',
        \ 'markdown': 'all',
        \ 'python': ['flake8', 'autopep8', 'mypy', 'black'],
        \ 'tex': 'all',
        \ 'vim': 'all',
        \ 'c': ['clang', 'gcc'],
        \ 'cpp': ['clang', 'clangtidy', 'g++'],
        \ }

  "let g:ale_fixers = {
  "      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  "      \ 'cpp': ['clang-format'],
  "      \ }

  "let g:ale_open_list = 0
  "let g:ale_lint_delay = 1500

  "let s:ale_c_opts = '-std=c11 -Wall -Wextra -Werror'
  "let g:ale_c_gcc_options = s:ale_c_opts
  "let g:ale_c_clang_options = s:ale_c_opts

  "let s:ale_cpp_opts = '-std=c++17 -Wall -Wextra -Werror -fexceptions'
  "let g:ale_cpp_gcc_options = s:ale_cpp_opts
  "let g:ale_cpp_clang_options = s:ale_cpp_opts
  "let g:ale_cpp_clangtidy_options = s:ale_cpp_opts
endif

if exists('s:have_coc_nvim')
  " See https://github.com/neoclide/coc.nvim for example options.

  function! s:check_whitespace_backwards() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Use TAB to trigger completion, and navigate through list. (Use ':verbose imap <tab>' to ensure TAB is not mapped.)
  inoremap <silent><expr> <tab> pumvisible() ? "\<C-n>" : <SID>check_whitespace_backwards() ? "\<tab>" : coc#refresh()
  inoremap <silent><expr><S-tab> pumvisible() ? "\<C-p>" : "\<C-h>"

  " Use Ctrl-Space to trigger completion.
  inoremap <silent><expr> <C-space> coc#refresh()

  " Use Enter to confirm completion.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<cr>"

  " Use `[c` and `]c` to navigate diagnostics
  nmap <silent> [c <Plug>(coc-diagnostic-prev)
  nmap <silent> ]c <Plug>(coc-diagnostic-next)

  " Map function keys for LSP functionality
  nmap <silent> <F7> <Plug>(coc-definition)
  nmap <silent> <F8> <Plug>(coc-type-definition)
  nmap <silent> <F9> <Plug>(coc-implementation)
  nmap <silent> <F10> <Plug>(coc-references)

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Remap for rename current word
  nmap <leader>rn <Plug>(coc-rename)

  " Remap for format selected region
  xmap <leader>fo <Plug>(coc-format-selected)
  nmap <leader>fo <Plug>(coc-format-selected)
endif

if exists('s:have_goyo')
  let g:goyo_width = 120
  autocmd! User GoyoEnter Limelight
  autocmd! User GoyoLeave Limelight!
endif

"if exists('s:have_buffergator')
"  " - Width of the buffergator window
"  let g:buffergator_viewport_split_policy = "B"
"  let g:buffergator_split_size = 16
"  let g:buffergator_autoupdate = 1
"  let g:buffergator_sort_regime = "mru"
"  let g:buffergator_suppress_mru_switching_keymaps = 1
"endif

"if exists('s:have_vim_markbar')
"  map <Leader>m <Plug>ToggleMarkbar
"  let g:markbar_width = 40
"  let g:markbar_num_lines_context = 3
"  "let g:markbar_marks_to_display = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
"endif

