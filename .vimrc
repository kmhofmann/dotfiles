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

let plugin_categories = ['basic',
                       \ 'textsearch',
                       \ 'filesearch',
                       \ 'ui_additions',
                       \ 'copypaste',
                       \ 'devel',
                       \ 'devel_ext',
                       \ 'colorschemes',
                       \ 'misc']
let faster_redraw = 0

" Bootstrap vim-plug, if not already present
if has("unix") || has("macunix")
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
elseif has("win32")
  if empty(glob('~/vimfiles/autoload/plug.vim'))
    echo "You will need to install vim-plug manually for this .vimrc to work."
    echo "(https://github.com/junegunn/vim-plug)"
    exit
  endif
endif

function! BuildYCM(info)  " See https://github.com/junegunn/vim-plug
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer
  endif
endfunction

call plug#begin()
if index(plugin_categories, 'basic') >= 0
  Plug 'drmikehenry/vim-fixkey'          " Permits mapping more classes of characters (e.g. <Alt-?>)
  Plug 'ConradIrwin/vim-bracketed-paste' " Automatically set paste mode
  Plug 'tpope/vim-eunuch'                " Syntactic sugar for some UNIX shell commands
  Plug 'tpope/vim-repeat'                " Remaps . such that plugin maps can use it
  Plug 'tpope/vim-surround'              " 'surrounding' motion
  Plug 'tpope/vim-unimpaired'            " Provide pairs of mappings for []
  Plug 'itspriddle/vim-stripper'         " Strip trailing whitespace on save
  Plug 'godlygeek/tabular'               " Text alignment made easy
  Plug 'moll/vim-bbye'                   " Adds :Bdelete command to close buffer but keep window
  let have_bbye = 1
endif

if index(plugin_categories, 'textsearch') >= 0
  Plug 'bronson/vim-visual-star-search'  " Lets * and # perform search in visual mode
  Plug 'justinmk/vim-sneak'              " f-like search using two letters
endif

if index(plugin_categories, 'filesearch') >= 0
  if !has("win32")
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    let have_fzf = 1
  else
    Plug 'ctrlpvim/ctrlp.vim'             " Fuzzy file finder
    let have_ctrlp = 1
  endif
  Plug 'scrooloose/nerdtree', { 'on': ['NERDTree', 'NERDTreeFind', 'NERDTreeToggle'] }  " Better file explorer
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTree', 'NERDTreeFind', 'NERDTreeToggle'] }
  let have_nerdtree = 1
  Plug 'mileszs/ack.vim'                 " Wrapper for ack (grep-like tool)
  let have_ack = 1
endif

if index(plugin_categories, 'ui_additions') >= 0
  Plug 'vim-airline/vim-airline'         " Status/tabline
  Plug 'vim-airline/vim-airline-themes'  " Themes for vim-airline
  let have_airline = 1
  Plug 'jeetsukumaran/vim-buffergator'   " Select, list and switch between buffers easily
  let have_buffergator = 1
  Plug 'Valloric/ListToggle'             " Easily display or hide quickfix or location list
  let have_listtoggle = 1
  Plug 'mbbill/undotree'                 " Visualize and act upon undo tree
  let have_undotree = 1
  Plug 'mhinz/vim-startify'              " A fancy start screen
endif

if index(plugin_categories, 'copypaste') >= 0
  "Plug 'maxbrunsfeld/vim-yankstack'     " Keep yank stack
  "let have_yankstack = 1
  Plug 'svermeulen/vim-easyclip'         " Improved clipboard functionality
  let have_easyclip = 1
endif

if index(plugin_categories, 'devel') >= 0
  "Plug 'tpope/vim-sleuth'               " Adjust indentation settings automatically
  "Plug 'jreybert/vimagit'               " Git wrapper
  Plug 'scrooloose/nerdcommenter'        " Commenting code
  Plug 'tpope/vim-fugitive'              " Git wrapper
  Plug 'nacitar/a.vim'                   " Easy switching between header and translation unit
  Plug 'airblade/vim-rooter'             " Changes working directory to project root
  Plug 'vim-gitgutter'                   " Show visual git diff in the gutter
  let have_gitgutter = 1
endif

if index(plugin_categories, 'devel_ext') >= 0
  Plug 'Chiel92/vim-autoformat', { 'on': 'Autoformat' }  " Trigger code formatting engines
  Plug 'jmcantrell/vim-virtualenv'       " Improved working with virtualenvs
  if (v:version < 800)
    Plug 'vim-syntastic/syntastic'       " Syntax checking for many languages
    let have_syntastic = 1
  else
    Plug 'w0rp/ale'                      " Asynchronous Lint Engine
    let have_ale = 1
  endif
  if !has("win32")
    Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }  " Syntax completion engine
    let have_ycm = 1
  endif
  Plug 'lyuts/vim-rtags'
  let have_rtags = 1
endif

if index(plugin_categories, 'colorschemes') >= 0
  Plug 'tomasr/molokai'
  Plug 'sjl/badwolf'
  Plug 'nanotech/jellybeans.vim'
  Plug 'chriskempson/base16-vim'         " Set of color schemes; see https://chriskempson.github.io/base16/
endif

if index(plugin_categories, 'misc') >= 0
  Plug 'junegunn/limelight.vim'          " Paragraph-based syntax highlighting
  Plug 'junegunn/goyo.vim'               " Distraction-free editing
  let have_goyo = 1
endif

if index(plugin_categories, 'annoying') >= 0
  Plug 'takac/vim-hardtime'              " Enables a hard time
  let have_hardtime = 1
endif
call plug#end()

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
  set backupdir=$HOME/.vim/backup//,.
  set directory=$HOME/.vim/swp//,.
endif
if has("persistent_undo")
  set undodir=$HOME/.vim/undo/
  set undofile
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

autocmd Filetype python setlocal softtabstop=4 shiftwidth=4 colorcolumn=120
autocmd Filetype cpp    setlocal softtabstop=2 shiftwidth=2 colorcolumn=120
autocmd Filetype cmake  setlocal softtabstop=4 shiftwidth=4 colorcolumn=120
autocmd Filetype vim    setlocal softtabstop=2 shiftwidth=2 colorcolumn=120 textwidth=120

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

if index(plugin_categories, 'colorschemes') >= 0
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
set showcmd             " Show command in bottom bar
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
set foldenable          " Enable folding
set synmaxcol=300       " Highlight up to 300 columns

set number              " Show line numbers
if !faster_redraw
  set relativenumber      " Show relative line numbers
  set cursorline          " Highlight current line
endif

" Allow mapping of meta/option key in MacVim
if has("macunix") && has("gui_running")
  set macmeta
endif

" Better font in Windows GUI
if has("win32") && has("gui_running")
  set guifont=Consolas:h11
endif

if !has("win32") && !has("gui_running")
  set term=screen-256color
endif
set t_ut=

if !has('gui_running')
  set t_Co=256
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

" Key mappings
"=======================================

" Map leader key to <Space>
let mapleader = "\<Space>"

" Use 'jj'/'jk' to exit insert mode; en-/disable as desired
inoremap jj <Esc>
"inoremap jk <Esc>

" Disable Shift-K
noremap <S-k> <nop>

" Allow the . to execute once for each line of a visual selection
vnoremap . :normal .<cr>

if !exists('have_easyclip')
  " Paste from yank register with <leader>p/P
  noremap <leader>p "0p
  noremap <leader>P "0P
endif

" Move vertically by visual line
noremap j gj
noremap k gk

" Scroll 5 lines up and down
noremap <C-d> 5<C-d>
noremap <C-u> 5<C-u>

" Move 5 lines up and down
noremap <A-j> 5j
noremap <A-k> 5k

" Move to beginning of line/first whitespace character or end of line
noremap <leader>0 :call LineHome()<cr>:echo<cr>
noremap <Home> :call LineHome()<cr>:echo<cr>
inoremap <Home> <C-R>=LineHome()<cr>
noremap <A-h> :call LineHome()<cr>:echo<cr>
noremap <A-l> $

" Move lines up or down with Alt-d/u
" (http://vim.wikia.com/wiki/Moving_lines_up_or_down)
nnoremap <A-d> :m .+1<cr>==
nnoremap <A-u> :m .-2<cr>==
inoremap <A-d> <Esc>:m .+1<cr>==gi
inoremap <A-u> <Esc>:m .-2<cr>==gi
vnoremap <A-d> :m '>+1<cr>gv=gv
vnoremap <A-u> :m '<-2<cr>gv=gv

" Movement in insert mode with Ctrl-h/j/k/l
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" Quick window switching with Ctrl-h/j/k/l
noremap  <C-h>  <C-w>h
noremap  <C-j>  <C-w>j
noremap  <C-k>  <C-w>k
noremap  <C-l>  <C-w>l

" Don't lose selection when shifting sidewards
xnoremap <  <gv
xnoremap >  >gv

" Quick switching to alternate buffer
nnoremap <silent> <leader>a :b#<cr>

" Shortcuts for window handling
"nnoremap <leader>r <C-w>r  " rotate windows
nnoremap <leader>w <C-w>q  " close current window
nnoremap <leader>o <C-w>o  " make current one the only window

" Disable highlighting of search results
"nnoremap <silent> <leader><Space> :set hlsearch!<cr>
nnoremap <silent><expr> <Leader><Space> (&hls && v:hlsearch ? ':nohlsearch' : ':set hlsearch')."\n"

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
noremap <F6> :set ignorecase!<cr>:set ignorecase?<cr>

" F7: Syntastic check
noremap <silent> <F7> :SyntasticCheck<cr>

" F8: Syntastic reset
noremap <silent> <F8> :SyntasticReset<cr>

" F9: Find file in NERDTree
" (See below)

" F10: Strip trailing whitespaces
" nnoremap <silent> <F10> :call Preserve("%s/\\s\\+$//e")<cr>

" F10: Toggle text width
noremap <silent> <F10> :call ToggleTextWidth()<cr>

" F11: Switch gvim to fullscreen (requires wmctrl)
if has("unix") && has("gui_running")
  noremap <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<cr>
endif

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

if exists('have_listtoggle')
  " - Height of the location list window
  let g:lt_height = 10
endif

if exists('have_buffergator')
  " - Width of the buffergator window
  let g:buffergator_split_size = 50
endif

" Quick buffer deletion with <Space><Backspace> (using vim-bbye)
if exists('have_bbye')
  nnoremap <silent> <leader><Bs> :Bdelete<cr>
endif

if exists('have_airline')
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

if exists('have_fzf')
  if !exists('have_ctrlp')
    nnoremap <silent> <C-p> :FZF<cr>
  endif
  nnoremap <silent> <leader>ff :Files<CR>
  nnoremap <silent> <leader>fb :Buffers<CR>
  nnoremap <silent> <leader>fw :Windows<CR>
  nnoremap <silent> <leader>fh :History<CR>
endif

if exists('have_ctrlp')
  " - Start CtrlP in mixed mode
  let g:ctrlp_cmd = 'CtrlPMixed'
endif

if exists('have_ack')
  " - Use ag with :Ack, if available
  if executable('ag')
    let g:ackprg = 'ag --vimgrep'
  endif
endif

if exists('have_nerdtree')
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

  noremap <silent> <F9> :NERDTreeFind<cr>
  nnoremap <silent> <C-n> :call FocusOrCloseNERDTree()<cr>
  let g:NERDTreeShowHidden=1
  let g:NERDTreeStatusline="%f"
  let g:NERDTreeWinPos="left"
  "let g:NERDTreeWinSize=40
  let NERDTreeIgnore = ['\.pyc$', '__pycache__', '.swp']
  " - Close vim if the only window left is a NERDTree
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif

if exists('have_undotree')
  nnoremap <silent> <Leader>u :UndotreeToggle<cr>
endif

if exists('have_yankstack')
  if has("macunix") && !has("gui_running")
    " Option-p:
    nmap π <Plug>yankstack_substitute_older_paste
    " Option-P:
    nmap ∏ <Plug>yankstack_substitute_newer_paste
  endif
  " Need to omit 's', 'S' from being remapped because of vim-sneak
  let g:yankstack_yank_keys = ['c', 'C', 'd', 'D', 'x', 'X', 'y', 'Y']
  call yankstack#setup()  " needs to be called before remapping Y (see !have_easyclip section)
endif

if exists('have_easyclip')
  nnoremap gm m
  let g:EasyClipAlwaysMoveCursorToEndOfPaste = 1
else
  " Map Y to behave like C, D
  nmap Y y$
endif

if exists('have_ycm')
  let g:ycm_confirm_extra_conf = 0
  nnoremap <silent> <Leader>yg :YcmCompleter GoTo<cr>
  nnoremap <silent> <Leader>yi :YcmCompleter GoToInclude<cr>>
  nnoremap <silent> <Leader>yc :YcmCompleter GoToDeclaration<cr>
  nnoremap <silent> <Leader>yf :YcmCompleter GoToDefinition<cr>
  nnoremap <silent> <Leader>yt :YcmCompleter GetType<cr>
  nnoremap <silent> <Leader>yd :YcmCompleter GetDoc<cr>
  nnoremap <silent> <Leader>yx :YcmCompleter FixIt<cr>
endif

if exists('have_rtags')
  let g:rtagsAutoLaunchRdm = 1
  let g:rtagsExcludeSysHeaders = 1
endif

if exists('have_syntastic')
  let g:syntastic_mode_map = { 'mode': 'passive' }  " Disable checking unless user-requested
  let g:syntastic_always_populate_loc_list = 1  " Automatically populate location list
  let g:syntastic_auto_loc_list = 1  " Automatically open/close location list
  let g:syntastic_check_on_open = 0
  let g:syntastic_check_on_wq = 0
  let g:syntastic_loc_list_height = 10
  let g:syntastic_python_pylint_post_args="--max-line-length=120"
endif

if exists('have_ale')
  " - Enable some linters. Note C and C++ are missing - support isn't that great yet
  let g:ale_linters = {
        \ 'json': 'all',
        \ 'markdown': 'all',
        \ 'python': 'all',
        \ 'tex': 'all',
        \ 'vim': 'all',
        \ }
  " let g:ale_python_flake8_args = '--ignore=E,W,F403,F405 --select=F,C'
  " let g:ale_c_clang_options = '-std=c11 -Wall -Wextra -Werror -fexceptions -DNDEBUG'
  " let g:ale_cpp_clang_options = '-std=c++14 -Wall -Wextra -Werror -fexceptions -DNDEBUG'
  " set statusline+=%{ALEGetStatusLine()}
  " let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']

  if exists('have_ycm') && has_key(g:ale_linters, 'cpp')
    let g:ycm_enable_diagnostic_signs = 0  " Disable diagnostics when ALE is enabled for C and C++
  endif
endif

if exists('have_goyo')
  let g:goyo_width = 120
  autocmd! User GoyoEnter Limelight
  autocmd! User GoyoLeave Limelight!
endif

if exists('have_hardtime')
  let g:hardtime_default_on = 1
  let g:hardtime_ignore_quickfix = 1
  let g:hardtime_allow_different_key = 1
  let g:hardtime_maxcount = 2
endif
