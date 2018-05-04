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
" * The LanguageClient-neovim plugin can make use of several language servers,
"   according to the Language Server Protocol (LSP).
"   See also http://langserver.org/.
"   Below, 'cquery' and 'python-language-server' are preconfigured.
"   To install them on the system (on a per-user level), perform the following
"   steps (or similar):
"   - Install cquery:
"     $ git clone --recursive https://github.com/cquery-project/cquery.git
"     $ mkdir -p ./cquery/build && cd ./cquery/build
"     $ cmake -DCMAKE_BUILD_TYPE=Release \
"             -DCMAKE_INSTALL_PREFIX=$HOME/local/cquery \
"             -DCMAKE_EXPORT_COMPILE_COMMANDS=YES \
"             ..
"     $ make -j$(nproc) && make install
"     - Add $HOME/local/cquery/bin to the $PATH.
"   - Install python-language-server:
"     $ pip install --user --upgrade python-language-server
"     $ pip install --user --upgrade 'python-language-server[all]'
"     - Add $HOME/.local/bin to the $PATH.
"
" * Deoplete requires the Python 'neovim' package to be installed. This applies
"   both to Neovim as well vim8!
"   $ pip install --user --upgrade neovim
"   $ pip3 install --user --upgrade neovim

" Plugin management
"=======================================

" Activate or deactivate categories here:
let s:plugin_categories  = ['colorschemes']
let s:plugin_categories += ['basic']
let s:plugin_categories += ['buffers']
let s:plugin_categories += ['textsearch']

let s:plugin_categories += ['copypaste']
let s:plugin_categories += ['ui_additions']
let s:plugin_categories += ['filesearch']
let s:plugin_categories += ['sessions']
let s:plugin_categories += ['formatting']
let s:plugin_categories += ['devel']
let s:plugin_categories += ['devel_ext']

"let s:plugin_categories += ['google']
"let s:plugin_categories += ['misc']

" Set these options to your liking
let s:faster_redraw = 0      " Faster redraw disables relative line numbers and cursorline
let s:show_airline_tabs = 1

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
  Plug 'euclio/vim-nocturne'
  Plug 'nanotech/jellybeans.vim'
  Plug 'altercation/vim-colors-solarized'
  Plug 'google/vim-colorscheme-primary'
  Plug 'chriskempson/base16-vim'         " Set of color schemes; see https://chriskempson.github.io/base16/
endif

if index(s:plugin_categories, 'basic') >= 0
  if !has('nvim')
    Plug 'drmikehenry/vim-fixkey'          " Permits mapping more classes of characters (e.g. <Alt-?>)
  endif
  Plug 'ConradIrwin/vim-bracketed-paste' " Automatically set paste mode
  Plug 'tpope/vim-eunuch'                " Syntactic sugar for some UNIX shell commands
  Plug 'tpope/vim-repeat'                " Remaps . such that plugin maps can use it
  Plug 'tpope/vim-surround'              " 'surrounding' motion
  " Plug 'machakann/vim-sandwich'          " better 'surrounding' motion (**** CONFLICTS WITH VIM-SNEAK ***)
  Plug 'tpope/vim-unimpaired'            " Provide pairs of mappings for []
  Plug 'embear/vim-localvimrc'           " Read local .lvimrc files up the directory tree
  let s:have_localvimrc = 1
  Plug 'drzel/vim-split-line'
  let s:have_splitline = 1
  if has("unix") || has("macunix")
    Plug 'jez/vim-superman'              " Read man pages with vim (vman command)
  endif
  Plug 'airblade/vim-accent'             " Easy selection of accented characters (e.g. with <C-X><C-U>)
endif

if index(s:plugin_categories, 'buffers') >= 0
  Plug 'moll/vim-bbye', { 'on': ['Bdelete'] }  " Adds :Bdelete command to close buffer but keep window
  let s:have_bbye = 1
  Plug 'schickling/vim-bufonly', { 'on': ['Bonly', 'BOnly', 'Bufonly'] }  " Close all buffers but the current one
endif

if index(s:plugin_categories, 'textsearch') >= 0
  Plug 'bronson/vim-visual-star-search'  " Lets * and # perform search in visual mode
  Plug 'haya14busa/is.vim'               " Improved incremental search
  Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }  " Easier grepping
  let s:have_grepper = 1
  Plug 'rhysd/clever-f.vim'              " extend f/F/t/T to also repeat search
  Plug 'justinmk/vim-sneak'              " f-like search using two letters, mapped to s/S
  let s:have_sneak = 1
endif

if index(s:plugin_categories, 'copypaste') >= 0
  Plug 'svermeulen/vim-easyclip'         " Improved clipboard functionality
  let s:have_easyclip = 1
endif

if index(s:plugin_categories, 'ui_additions') >= 0
  Plug 'vim-airline/vim-airline'         " Status/tabline
  Plug 'vim-airline/vim-airline-themes'  " Themes for vim-airline
  let s:have_airline = 1
  Plug 'jeetsukumaran/vim-buffergator'   " Select, list and switch between buffers easily
  let s:have_buffergator = 1
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
  else
    Plug 'ctrlpvim/ctrlp.vim', { 'on': ['CtrlP', 'CtrlPBuffer', 'CtrlPMRU', 'CtrlPMixed'] }  " Fuzzy file finder
    let s:have_ctrlp = 1
  endif
  Plug 'scrooloose/nerdtree', { 'on': ['NERDTree', 'NERDTreeFind', 'NERDTreeToggle'] }  " Better file explorer
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTree', 'NERDTreeFind', 'NERDTreeToggle'] }
  let s:have_nerdtree = 1
  Plug 'mileszs/ack.vim', { 'on': ['Ack'] }  " Wrapper for ack (grep-like tool)
  let s:have_ack = 1
  "Plug 'jeetsukumaran/vim-filebeagle'
endif

if index(s:plugin_categories, 'sessions') >= 0
  Plug 'tpope/vim-obsession'             " Easier session handling
endif

if index(s:plugin_categories, 'formatting') >= 0
  Plug 'itspriddle/vim-stripper'         " Strip trailing whitespace on save
  Plug 'junegunn/vim-easy-align'         " Text alignment made easy
  let s:have_easy_align = 1
  Plug 'tpope/vim-sleuth'                " Detect and set automatic indentation
endif

if index(s:plugin_categories, 'devel') >= 0
  Plug 'scrooloose/nerdcommenter'        " Commenting code
  Plug 'tpope/vim-fugitive'              " Git wrapper
  Plug 'nacitar/a.vim', { 'on': ['A'] }  " Easy switching between header and translation unit
  Plug 'airblade/vim-rooter'             " Changes working directory to project root
  Plug 'airblade/vim-gitgutter'          " Show visual git diff in the gutter
  Plug 'jmcantrell/vim-virtualenv'       " Improved working with virtualenvs
  Plug 'Chiel92/vim-autoformat', { 'on': 'Autoformat' }  " Trigger code formatting engines
endif

if index(s:plugin_categories, 'devel_ext') >= 0
  if (v:version >= 800)
    Plug 'w0rp/ale'                      " Asynchronous Lint Engine
    let s:have_ale = 1

    if !has("win32")
      if has('nvim')
        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
      else
        Plug 'Shougo/deoplete.nvim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
      endif
      let s:have_deoplete = 1

      Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
      let s:have_language_client_neovim = 1
    endif
  endif
endif

if index(s:plugin_categories, 'google') >= 0
  " Some of these are inter-dependent, hence the separate category
  Plug 'google/vim-searchindex'
  Plug 'google/vim-maktaba'
  Plug 'google/vim-glaive'
  let s:have_glaive = 1
  Plug 'google/vim-codefmt'              " Trigger code formatting engines
  let s:have_codefmt = 1
endif

if index(s:plugin_categories, 'misc') >= 0
  Plug 'junegunn/limelight.vim', { 'on': ['Limelight'] }  " Paragraph-based syntax highlighting
  Plug 'junegunn/goyo.vim', { 'on': ['Goyo'] }  " Distraction-free editing
  let s:have_goyo = 1
endif

call plug#end()

if exists('s:have_codefmt')
  call glaive#Install()
  Glaive codefmt plugin[mappings]
endif

" General
"=======================================

set timeoutlen=500
set ttimeoutlen=10
set updatetime=500

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

set swapfile
set nobackup
set nowritebackup

set nolist
set listchars=tab:>-,trail:~,extends:>,precedes:<

" Tabbing and indentation
"=======================================

set tabstop=8       " Number of visual spaces per TAB
set softtabstop=2   " Number of spaces in tab when editing
set shiftwidth=2
set shiftround      " Always indent by multiple of shiftwidth
set smarttab        " Be smart when using tabs
set expandtab       " Tabs are spaces
set autoindent
set nojoinspaces

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
  " Use the base16 color schemes, if available. See https://github.com/chriskempson/base16-shell.
  if !has("gui_running") && filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    let g:base16_shell_path="~/.config/base16-shell/scripts/"
    source ~/.vimrc_background
  else
    colorscheme molokai
  endif
endif

" UI configuration
"=======================================

set backspace=eol,start,indent  " Configure backspace so it acts as it should act
set laststatus=2        " Always show the status line
set scrolloff=5         " Set 5 lines to the cursor - when moving vertically using j/k
set hidden              " A buffer becomes hidden when it is abandoned
set showcmd             " Show command in bottom bar
set ruler               " Always show current position
set nowrap              " Don't wrap overly long lines
set wildmode=longest,list  " Visual autocomplete for command menu
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

" Allow cursor change in tmux mode
if empty($TMUX)
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
else
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
endif

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

function! CloseCurrentWindow()
  if winnr("$") > 1
    execute "quit"
  endif
endfunction

" Key mappings
"=======================================

" Map leader key to <Space>
let mapleader = "\<Space>"

" Use 'jj'/'jk' to exit insert mode; en-/disable as desired
inoremap jj <Esc>
"inoremap jk <Esc>

" Disable Shift-K
if !exists('s:have_language_client_neovim')
  noremap <S-k> <nop>
endif

" Allow the . to execute once for each line of a visual selection
vnoremap . :normal .<cr>

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

" Add empty lines via Enter/Leader-Enter in normal mode
nnoremap <cr> o<Esc>
nnoremap <leader><cr> O<Esc>

" Scroll 5 lines up and down
noremap <C-d> 5<C-d>
noremap <C-u> 5<C-u>

" Switch to previous/next buffer
noremap <silent> <A-j> :bprevious<cr>
noremap <silent> <A-k> :bnext<cr>
if has('nvim')
  nnoremap <silent> <Tab> :bnext<cr>
  nnoremap <silent> <S-Tab> :bprevious<cr>
endif

" Quick switching to alternate buffer
noremap <silent> <A-l> :b#<cr>
nnoremap <silent> <leader>a :b#<cr>

" Move to beginning of line/first whitespace character or end of line
noremap <leader>0 :call LineHome()<cr>:echo<cr>
noremap <Home> :call LineHome()<cr>:echo<cr>
inoremap <Home> <C-R>=LineHome()<cr>

" Move 5 lines up and down
"noremap <A-j> 5j
"noremap <A-k> 5k

" Move lines up or down with Alt-d/u
" (http://vim.wikia.com/wiki/Moving_lines_up_or_down)
"nnoremap <A-d> :m .+1<cr>==
"nnoremap <A-u> :m .-2<cr>==
"inoremap <A-d> <Esc>:m .+1<cr>==gi
"inoremap <A-u> <Esc>:m .-2<cr>==gi
"vnoremap <A-d> :m '>+1<cr>gv=gv
"vnoremap <A-u> :m '<-2<cr>gv=gv

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
nnoremap <leader>r <C-w>r  " rotate windows
nnoremap <leader>w :call CloseCurrentWindow()<cr>:echo<cr>
"nnoremap <leader>o <C-w>o  " make current one the only window

" Window switching using <leader><number> (Source: http://stackoverflow.com/a/6404246/151007)
let i = 1
while i <= 9
  execute 'nnoremap <silent> <leader>'.i.' :'.i.'wincmd w<CR>'
  let i = i + 1
endwhile

" Use | and _ to split windows (while preserving original behaviour of [count]bar and [count]_).
" (http://howivim.com/2016/andy-stewart/)
nnoremap <expr><silent> <Bar> v:count == 0 ? "<C-W>v<C-W><Right>" : ":<C-U>normal! 0".v:count."<Bar><CR>"
nnoremap <expr><silent> _     v:count == 0 ? "<C-W>s<C-W><Down>"  : ":<C-U>normal! ".v:count."_<CR>"

" Disable highlighting of search results
nnoremap <silent><expr> <leader><Space> (&hls && v:hlsearch ? ':nohlsearch' : ':set hlsearch')."\n"

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

" F6: Switch case sensitivity
"noremap <F6> :set ignorecase!<cr>:set ignorecase?<cr>

" F6: Rename (LanguageClient_neovim)
" F7: Find references (LanguageClient_neovim)
" F8: Go to definition (LanguageClient_neovim)
" F9: Find file in NERDTree (see below)

" F10: Toggle text width
noremap <silent> <F10> :call ToggleTextWidth()<cr>

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

if exists('s:have_sneak')
  let g:sneak#s_next = 1  " Enable sneak-clever-s. Press 's'/'S' again to go to next/previous match.
endif

if exists('s:have_splitline')
  nnoremap <leader>s :SplitLine<CR>
endif

if exists('s:have_grepper')
  " Maps the Grepper operator for normal and visual mode
  nmap gs <plug>(GrepperOperator)
  xmap gs <plug>(GrepperOperator)
endif

if exists('s:have_listtoggle')
  " - Height of the location list window
  let g:lt_height = 10
endif

if exists('s:have_buffergator')
  " - Width of the buffergator window
  let g:buffergator_viewport_split_policy = "B"
  let g:buffergator_split_size = 16
  let g:buffergator_autoupdate = 1
  let g:buffergator_sort_regime = "mru"
  let g:buffergator_suppress_mru_switching_keymaps = 1
endif

if exists('s:have_bbye')
  " Quick buffer deletion with <Space><Backspace> (using vim-bbye)
  nnoremap <silent> <leader><Bs> :Bdelete<cr>
endif

if exists('s:have_localvimrc')
  let g:localvimrc_ask = 0
  let g:localvimrc_persistent = 1
endif

if exists('s:have_airline')
  let airline_themes = {
      \'base16-solarized-dark': 'base16_solarized',
      \'base16-monokai': 'base16_monokai'}
  if exists('g:colors_name') && has_key(airline_themes, g:colors_name)
    let g:airline_theme=airline_themes[g:colors_name]
  endif
  if exists('s:show_airline_tabs') && (s:show_airline_tabs == 1)
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#show_splits = 1
    let g:airline#extensions#tabline#show_tabs = 1
    let g:airline#extensions#tabline#formatter = 'default'
  endif
endif

if exists('s:have_fzf')
  if !exists('s:have_ctrlp')
    nnoremap <silent> <C-p> :FZF<cr>
  endif
  nnoremap <silent> <leader>ff :Files<CR>
  nnoremap <silent> <leader>fb :Buffers<CR>
  nnoremap <silent> <leader>fw :Windows<CR>
  nnoremap <silent> <leader>fm :Marks<CR>
  nnoremap <silent> <leader>fh :History<CR>
  nnoremap <silent> <leader>fl :Lines<CR>
  nnoremap <silent> <leader>fc :Commits<CR>
endif

if exists('s:have_ctrlp')
  " - Start CtrlP in mixed mode
  let g:ctrlp_cmd = 'CtrlPMixed'
endif

if exists('s:have_ack')
  " - Use ag with :Ack, if available
  if executable('ag')
    let g:ackprg = 'ag --vimgrep'
  endif
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
      for p in map(range(1, winnr('$')), '[v:val, bufname(winbufnr(v:val))]')
        if p[1] =~ "^NERD_tree_"
          :exe p[0] . "wincmd w"
          break
        endif
      endfor
      if bufname('') !~ "^NERD_tree_"
        :NERDTreeToggle
      endif
    endif
  endfunction

  " Find current file in NERDTree
  noremap <silent> <F9> :NERDTreeFind<cr>
  " Open or focus NERDTree with Ctrl-n, or close it if already focused
  nnoremap <silent> <C-n> :call FocusOrCloseNERDTree()<cr>
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

if exists('s:have_ale')
  " - Enable some linters. Note that for proper C and C++ support, one should provide a .lvimrc file in the project
  "   root directory, with the proper g:ale_c??_[clang|g++]_options settings. Basic options are set here, but they
  "   most likely aren't sufficient for most projects (no include paths provided here).
  let g:ale_linters = {
        \ 'json': 'all',
        \ 'markdown': 'all',
        \ 'python': ['flake8'],
        \ 'tex': 'all',
        \ 'vim': 'all',
        \ 'c': ['clang', 'gcc'],
        \ 'cpp': ['clang', 'clangtidy', 'g++'],
        \ }
  let g:ale_open_list = 0
  let g:ale_lint_delay = 1000

  let g:ale_python_mypy_options = '--ignore-missing-imports'

  let s:ale_c_opts = '-std=c11 -Wall -Wextra -Werror'
  let g:ale_c_gcc_options = s:ale_c_opts
  let g:ale_c_clang_options = s:ale_c_opts

  let s:ale_cpp_opts = '-std=c++14 -Wall -Wextra -Werror -fexceptions'
  let g:ale_cpp_gcc_options = s:ale_cpp_opts
  let g:ale_cpp_clang_options = s:ale_cpp_opts
  let g:ale_cpp_clangtidy_options = s:ale_cpp_opts
endif

if exists('s:have_deoplete')
  let g:deoplete#enable_at_startup = 1
  if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
  endif
endif

if exists('s:have_language_client_neovim')
  let g:LanguageClient_serverCommands = {}
  if executable('cquery')
    let g:LanguageClient_serverCommands.cpp = ['cquery', '--log-file=/tmp/cq.log']
    let g:LanguageClient_serverCommands.c = ['cquery', '--log-file=/tmp/cq.log']
  endif
  if executable('pyls')
    let g:LanguageClient_serverCommands.python = ['pyls']
  endif

  let g:LanguageClient_loadSettings = 1
  let g:LanguageClient_settingsPath = $HOME . '/.config/language_client/settings.json'
  let g:LanguageClient_diagnosticsEnable = 0

  set completefunc=LanguageClient#complete

  autocmd FileType c,cpp,python setlocal formatexpr=LanguageClient_textDocument_rangeFormatting()

  autocmd FileType c,cpp,python nnoremap <buffer> <silent> K :call LanguageClient_textDocument_hover()<cr>
  autocmd FileType c,cpp,python nnoremap <buffer> <silent> <F6> :call LanguageClient_textDocument_rename()<cr>
  autocmd FileType c,cpp,python nnoremap <buffer> <silent> <F7> :call LanguageClient_textDocument_references()<cr>
  autocmd FileType c,cpp,python nnoremap <buffer> <silent> <F8> :call LanguageClient_textDocument_definition()<cr>
endif

if exists('s:have_goyo')
  let g:goyo_width = 120
  autocmd! User GoyoEnter Limelight
  autocmd! User GoyoLeave Limelight!
endif
