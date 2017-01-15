" Michael's .vimrc
" (https://github.com/kmhofmann/dotfiles)
" =======================================
"
" Should work under Linux and Mac OS X. Not so much tested under Windows or GUI
" versions of vim, but it may also work.
"
" Installation:
" * $ cp .vimrc ~
" * At first call of vim with this .vimrc, the plugin manager vim-plug will be
"   bootstrapped. Then, issue ':PlugInstall' as an Ex command to install the
"   specified plugins.
" * You may alter the list of plugins on a higher level by editing the
"   'plugin_categories' list below. For example, you might not want to install
"   the extended development plugins on an embedded device." After installation
"   of the plugins, just restart vim.
" * All mentioned plugins will be installed from GitHub. Check their respective
"   pages for functionality and documentation.

" Plugin management
"=======================================

let plugin_categories = ['ext', 'dev', 'dev_ext', 'col']

" Bootstrap vim-plug, if not already present
if has("unix") || has("macunix")
  if empty(glob("~/.vim/autoload/plug.vim"))
    execute '!mkdir -p ~/.vim/autoload && curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  endif
endif

function! BuildYCM(info)  " See https://github.com/junegunn/vim-plug
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer
  endif
endfunction

call plug#begin()
" Basic plugins
Plug 'drmikehenry/vim-fixkey'         " Permits mapping more classes of characters (e.g. <Alt-?>)
Plug 'tpope/vim-eunuch'               " Syntactic sugar for some UNIX shell commands
Plug 'tpope/vim-repeat'               " Remaps . such that plugin maps can use it
Plug 'tpope/vim-surround'             " 'surrounding' motion
Plug 'tpope/vim-unimpaired'           " Provide pairs of mappings for []
Plug 'bronson/vim-visual-star-search' " Lets * and # perform search in visual mode
Plug 'justinmk/vim-sneak'             " f-like search using two letters
Plug 'moll/vim-bbye'                  " Adds :Bdelete command to close buffer but keep window
Plug 'jeetsukumaran/vim-buffergator'  " Select, list and switch between buffers easily
Plug 'Valloric/ListToggle'            " Easily display or hide quickfix or location list

if index(plugin_categories, 'ext') >= 0
  " Extended plugins
  "  Plug 'tpope/vim-sleuth'               " Adjust indentation settings automatically
  Plug 'vim-airline/vim-airline'        " Status/tabline
  Plug 'vim-airline/vim-airline-themes' " Themes for vim-airline
  Plug 'mileszs/ack.vim'                " Wrapper for ack (grep-like tool)
  Plug 'ctrlpvim/ctrlp.vim'             " Fuzzy file finder
  Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeFind', 'NERDTreeToggle'] }  " Better file explorer
  Plug 'mhinz/vim-startify'             " A fancy start screen
  Plug 'godlygeek/tabular'              " Text alignment made easy
  let have_airline = 1
  let have_ack = 1
  let have_ctrlp = 1
  let have_nerdtree = 1
endif

if index(plugin_categories, 'dev') >= 0
  " Basic development plugins
  Plug 'scrooloose/nerdcommenter'       " Commenting code
  Plug 'tpope/vim-fugitive'             " Git wrapper
  Plug 'vim-gitgutter'                  " Show visual git diff in the gutter
  Plug 'nacitar/a.vim'                  " Easy switching between header and translation unit
endif

if index(plugin_categories, 'dev_ext') >= 0
  " Extended bevelopment plugins
  Plug 'Chiel92/vim-autoformat', { 'on': 'Autoformat' }  " Trigger code formatting engines
  Plug 'jmcantrell/vim-virtualenv'      " Improved working with virtualenvs
  Plug 'vim-syntastic/syntastic'        " Syntax checking for many languages
  if has("unix") || has("macunix")
    Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }  " Syntax completion engine
  endif
  let have_syntastic = 1
  let have_ycm = 1
endif

if index(plugin_categories, 'col') >= 0
  " Color schemes
  Plug 'tomasr/molokai'
  Plug 'sjl/badwolf'
  Plug 'nanotech/jellybeans.vim'
  Plug 'chriskempson/base16-vim'        " Set of color schemes; see https://chriskempson.github.io/base16/
endif

if index(plugin_categories, 'annoying') >= 0
  " Annoying plugins
  Plug 'takac/vim-hardtime'             " Enables a hard time
  let have_hardtime = 1
endif
call plug#end()

" General
"=======================================

set timeoutlen=500
set ttimeoutlen=10
set updatetime=250

set history=500       " Sets how many lines of history VIM has to remember
set autoread          " Set to auto read when a file is changed from the outside
set encoding=utf8     " Set utf8 as standard encoding and en_US as the standard language
set ffs=unix,dos,mac  " Use Unix as the standard file type

if has("unix") || has("macunix")
  set backupdir=$HOME/.vim/backup//,.
  set directory=$HOME/.vim/swp//,.
endif

set swapfile
set nobackup
set nowritebackup

" Tabbing and indentation
"=======================================

set tabstop=8       " number of visual spaces per TAB
set softtabstop=2   " number of spaces in tab when editing
set shiftwidth=2
set shiftround      " Always indent by multiple of shiftwidth
set smarttab        " Be smart when using tabs
set expandtab       " Tabs are spaces
set smartindent
set autoindent

" Searching
"=======================================

set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase          " Ignore case when searching
set smartcase           " When searching try to be smart about cases
set magic               " For regular expressions turn magic on
set infercase           " Infer case for completions

" Color scheme
"=======================================

syntax enable           " Enable syntax highlighting
set background=dark     " Dark background color

if index(plugin_categories, 'col') >= 0
  " Use the base16 color schemes, with a fallback to 'molokai'.
  " To make this work, follow the instructions here: https://github.com/chriskempson/base16-shell
  if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
  else
    colorscheme molokai " Fallback
  endif
endif

" UI configuration
"=======================================

set backspace=eol,start,indent  " Configure backspace so it acts as it should act
set laststatus=2        " Always show the status line
set scrolloff=5         " Set 5 lines to the cursor - when moving vertically using j/k
set hidden              " A buffer becomes hidden when it is abandoned
set number              " Show line numbers
set relativenumber      " Show relative line numbers
set showcmd             " Show command in bottom bar
set cursorline          " Highlight current line
set ruler               " Always show current position
set nowrap              " Don't wrap overly long lines
set wildmode=longest,list
" set wildmenu            " Visual autocomplete for command menu
" set wildmode=full
set lazyredraw          " Redraw only when we need to.
set showmatch           " Highlight matching [{()}]
set mat=2               " How many tenths of a second to blink when matching brackets
set splitbelow          " New horizontal splits open below
set splitright          " New vertical splits open to the right

" Better font in Windows GUI
if has("gui_running") && has("win32")
  set guifont=Consolas:h11
endif

if !has("win32") && !has("gui_running")
  set term=screen-256color
endif
set t_ut=

" File type specific settings
"=======================================

autocmd Filetype python setlocal ts=4 sw=4 expandtab colorcolumn=120
autocmd Filetype cpp    setlocal colorcolumn=120
autocmd Filetype cmake  setlocal colorcolumn=120
autocmd Filetype vim    setlocal colorcolumn=120

" tmux specific settings
"=======================================

" Allow cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Functions for later use
"=======================================

" See https://technotales.wordpress.com/2010/03/31/preserve-a-vim-function-that-keeps-your-state
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" Jump to first non-whitespace on line, or to begining of line if already at first non-whitespace
function! LineHome()
  let x = col('.')
  execute "normal ^"
  if x == col('.')
    execute "normal 0"
  endif
  return ""
endfunction

" Key mappings
"=======================================

" Map leader key to <Space>
let mapleader = "\<Space>"

" Use 'jj' to exit insert mode
inoremap jj <Esc>

" Allow the . to execute once for each line of a visual selection
vnoremap . :normal .<cr>

" Disable Shift-K in normal mode
nnoremap <S-k> <nop>

" Move vertically by visual line
nnoremap j gj
nnoremap k gk

" Scroll 4 lines up and down
noremap <C-d> 4<C-d>
noremap <C-u> 4<C-u>

" Move lines up or down with Alt-j/k
" (http://vim.wikia.com/wiki/Moving_lines_up_or_down)
if has("macunix")
  nnoremap ∆ :m .+1<cr>==
  nnoremap ˚ :m .-2<cr>==
  inoremap ∆ <Esc>:m .+1<cr>==gi
  inoremap ˚ <Esc>:m .-2<cr>==gi
  vnoremap ∆ :m '>+1<cr>gv=gv
  vnoremap ˚ :m '<-2<cr>gv=gv
else
  nnoremap <A-j> :m .+1<cr>==
  nnoremap <A-k> :m .-2<cr>==
  inoremap <A-j> <Esc>:m .+1<cr>==gi
  inoremap <A-k> <Esc>:m .-2<cr>==gi
  vnoremap <A-j> :m '>+1<cr>gv=gv
  vnoremap <A-k> :m '<-2<cr>gv=gv
endif

" Movement in insert mode with Ctrl-h/j/k/l
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" Quick window switching with Ctrl-h/j/k/l
nnoremap  <C-h>  <C-w>h
nnoremap  <C-j>  <C-w>j
nnoremap  <C-k>  <C-w>k
nnoremap  <C-l>  <C-w>l

" Quick switching to alternate buffer
nnoremap <silent> <leader>a :b#<cr>

" Shortcuts for window handling
nnoremap <leader>r <C-w>r  " rotate windows
nnoremap <leader>w <C-w>q  " close current window
nnoremap <leader>o <C-w>o  " make current one the only window

" Disable highlighting of search results
nnoremap <silent> <leader><Space> :nohlsearch<cr>

" F1: Switch line numbering
noremap <F1> :set number!<cr>

" F2: Switch relative line numbering
noremap <F2> :set relativenumber!<cr>

" F3: Switch display of unprintable characters
nnoremap <F3> :set list!<cr>

" F4: Switch text wrapping
nnoremap <F4> :set wrap!<cr>

" F5: Switch paste mode
nnoremap <F5> :setlocal paste!<cr>

" F10: Strip trailing whitespaces
nnoremap <silent> <F10> :call Preserve("%s/\\s\\+$//e")<cr>

" F11: Switch gvim to fullscreen (requires wmctrl)
if has("unix") && has("gui_running")
  noremap <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<cr>
endif

" F12: Source currently loaded file (such as the .vimrc)
nnoremap <silent> <F12> :source %<cr>

" Miscellaneous settings
"=======================================

" Disable visually confusing match highlighting (can still use % to jump to matching parentheses)
let loaded_matchparen = 1

" Expand '%%' to path of current file (see Practical Vim, pg. 101)
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Alternate mappings for combined 0/^ (first non-whitespace character)
noremap <leader>0 :call LineHome()<cr>:echo<cr>
noremap <Home> :call LineHome()<cr>:echo<cr>
inoremap <Home> <C-R>=LineHome()<cr>

" Paste from yank register with <leader>p
noremap <leader>p "0p

" Plugin configurations
"=======================================

" ListToggle
" - Height of the location list window
let g:lt_height = 10

" buffergator
" - Width of the buffergator window
let g:buffergator_split_size = 50

" Quick buffer deletion with <Space><Backspace> (using vim-bbye)
nnoremap <silent> <leader><Bs> :Bdelete<cr>

if exists('have_airline')
  " vim-airline
  let airline_themes = {
      \'base16-solarized-dark': 'base16_solarized',
      \'base16-monokai': 'base16_monokai'}
  if exists('g:colors_name') && has_key(airline_themes, g:colors_name)
    let g:airline_theme=airline_themes[g:colors_name]
  endif
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#show_buffers = 1
  let g:airline#extensions#tabline#show_splits = 1
  let g:airline#extensions#tabline#show_tabs = 1
endif

if exists('have_nerdtree')
  " NERDTree
  nnoremap <silent> <C-n> :NERDTreeToggle<cr>
  let g:NERDTreeShowHidden=1
  let g:NERDTreeStatusline="%f"
  let g:NERDTreeWinPos="left"
  let g:NERDTreeWinSize=40
  let NERDTreeIgnore = ['\.pyc$', '__pycache__', '.swp']
  " - Close vim if the only window left is a NERDTree
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif

if exists('have_ycm')
  " YouCompleteMe
  let g:ycm_confirm_extra_conf = 0
  nnoremap <silent> <Leader>yg :YcmCompleter GoTo<cr>
  nnoremap <silent> <Leader>yi :YcmCompleter GoToInclude<cr>>
  nnoremap <silent> <Leader>yc :YcmCompleter GoToDeclaration<cr>
  nnoremap <silent> <Leader>yf :YcmCompleter GoToDefinition<cr>
  nnoremap <silent> <Leader>yt :YcmCompleter GetType<cr>
  nnoremap <silent> <Leader>yd :YcmCompleter GetDoc<cr>
endif

if exists('have_syntastic')
  " Syntastic
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
  let g:syntastic_loc_list_height = 5
endif

if exists('have_ack')
  " Ack
  " - Use ag with :Ack, if available
  if executable('ag')
    let g:ackprg = 'ag --vimgrep'
  endif
endif

if exists('have_ctrlp')
  " CtrlP
  " - Start CtrlP in mixed mode
  let g:ctrlp_cmd = 'CtrlPMixed'
endif

if exists('have_hardtime')
  " vim-hardtime
  let g:hardtime_default_on = 1
  let g:hardtime_ignore_quickfix = 1
  let g:hardtime_allow_different_key = 1
  let g:hardtime_maxcount = 2
endif
