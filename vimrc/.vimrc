" Configuration file for VIM
"
" By Christian Holtje & Shawn Zabel
"
" Install with:
"    mkdir -p ~/.vim/bundle && git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle && vim -c ':BundleInstall' -c ':qa!''
" Update with:
"    vim -c ':BundleInstall!' -c ':BundleClean' -c ':qa!'
"
" You may also wish to install some extra tools to make it work better:
" * Exuberant ctags - Used for Tagbar to show you where you are in the file. (mac: brew install ctags)
" * flake8          - Used by Syntastical to check Python. (all: easy_install flake8)
" * jslint          - Used by Syntastical to check Javascript. (mac: brew install jslint)
"
" This file uses folding mode in vim. To navigate this file, use the following
" command mode keys:
" * zR      - Open all folds.
" * zM      - Close all folds.
" * <space> - Toggle the current fold.
"
" Requirements/Suggestions:
"
" On OSX it is recommended you get a newer verson of vim. You can use
" homebrew to do this:
"
"     brew tap homebrew/dupes
"     brew install vim

" Remove ALL autocommands to prevent them from being loaded twice.
autocmd!

" Options
"-----------------------------------------------------------------------------
set nocompatible                 " The most important VIM option
set modelines=5                  " The Vim that comes with OS X changed the default value for some reason. Setting it back.

set smarttab
set tabstop=2                    " set the default tabstops
set shiftwidth=2                 " set the default autoindent
set softtabstop=2
set expandtab

set autoindent
set nowrap
set backspace=indent,eol,start   " Set for maximum backspace smartness

set ignorecase                   " ignore case in searches ... (\c\C override)
set smartcase                    " ... unless there are caps in the search
set incsearch                    " If the terminal is slow, turn this off

set number
set wildmode=list:longest,full   " Completion for wildchar (see help)
set wildmenu

set showcmd                      " display incomplete commands

set showmatch                    " Show the matching bracket
set matchpairs=(:),{:},[:]       " List of characters we expect in balanced pairs

set cursorline                   " highlights the current line


" Vundler - vim package manager
"-----------------------------------------------------------------------------
filetype off                   " required!

function! LoadBundles()
  " let Vundle manage Vundle
  " required!
  Bundle 'gmarik/vundle'

  " Press F2 to see a list of files and directories from your
  " current working directory
  Bundle 'scrooloose/nerdtree'

  " Command and uncomment code easily
  Bundle 'scrooloose/nerdcommenter'

  Bundle 'MarcWeber/vim-addon-mw-utils'

  " Utility functions for vim
  Bundle 'tomtom/tlib_vim'

  " Snippets - Use <C-n> to use a snippet in insert mode or <r-Tab> to show all.
  Bundle 'garbas/vim-snipmate'
  Bundle 'scrooloose/snipmate-snippets'

  if v:version > 700
    Bundle 'L9'
    Bundle 'FuzzyFinder'
  endif

  " Autopair mode - If you type '(', it'll fill in ')'
  Bundle 'Raimondi/delimitMate'

  " Adds matching 'end*' type syntax for ruby, vimscript, and lua
  Bundle 'tpope/vim-endwise'

  " lets you align comments, equal signs, etc.
  Bundle 'godlygeek/tabular'

  " Exhuberant CTags browsers
  if v:version > 700
    Bundle 'majutsushi/tagbar'
  endif

  " Syntax checking
  if exists('*getmatches')
    Bundle 'scrooloose/syntastic'
  endif

  " Latest vim-ruby
  Bundle 'vim-ruby/vim-ruby'

  " The only theme worth knowing.
  Bundle 'altercation/vim-colors-solarized'

  " ds/cs/ys for deleting, changing, your surrounding chars (like ', ", etc.)
  Bundle 'tpope/vim-surround'

  " Deal with git in a sane way
  Bundle 'tpope/vim-fugitive'

  " Get me some RVM support
  Bundle 'tpope/vim-rvm'

  " Fancy status bar theme
  Bundle 'Lokaltog/vim-powerline'

  " :A Switches between header and implementation file.
  Bundle 'a.vim'

endfunction

try
  set rtp+=~/.vim/bundle/vundle/
  call vundle#rc()
  call LoadBundles()
:catch /^Vim\%((\a\+)\)\=:E117/
  echomsg "Failed to load vundle and/or bundles. Perhaps vundle isn't installed."
  echomsg "You need to install vundle into ~/.vim/bundle/vundle: "
  echomsg "   git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle"
  echomsg "   vim -c ':BundleInstall' -c ':qa!'"
endtry

filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..


" Terminal and display settings
"-----------------------------------------------------------------------------
set laststatus=2                                                                    " show status line all the time
set scrolloff=5                                                                     " don't scroll any closer to top/bottom
let g:Powerline_symbols = 'unicode'

                                                                                    " NOTE: The statusline settings below is ignored if powerline is loaded.
set statusline=%t                                                                   " tail of the filename
set statusline+=\                                                                   " whitespace
set statusline+=[%{strlen(&fenc)?&fenc:'none'},                                     " file encoding
set statusline+=%{&ff}]                                                             " file format
set statusline+=%h                                                                  " help file flag
set statusline+=%m                                                                  " modified flag
set statusline+=%r                                                                  " read only flag
set statusline+=%y                                                                  " filetype
set statusline+=%w                                                                  " filetype
set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}
set statusline+=%=                                                                  " left/right separator
set statusline+=\ %#warningmsg#                                                     " start warnings highlight group
set statusline+=%{exists('g:loaded_syntastic_plugin')?SyntasticStatuslineFlag():''} " SyntasticStatusLine
set statusline+=%*                                                                  " end highlight group
set statusline+=%c,                                                                 " cursor column
set statusline+=%l/%L                                                               " cursor line/total lines
set statusline+=\ %P                                                                " percent through file

" Syntastical statusline format - Ignored when powerline is enabled.
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'

set background=dark

" The Smash Escape
inoremap jk <Esc>
inoremap kj <Esc>

try
  colorscheme solarized
catch /^Vim\%((\a\+)\)\=:E185/
  " deal wit it
endtry

" In many terminal emulators the mouse works just fine, thus enable it.
if v:version >= 702 && has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2
  syntax on
  set hlsearch
endif


set list listchars=tab:»·,trail:·    " Show the leading whitespaces
set display=uhex                     " Show unprintables as <xx>


" Backups, undos, and swap files                                                                                                                             {1
"-----------------------------------------------------------------------------
" Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.
if isdirectory($HOME . '/.vim/backup') == 0
  :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup
" Prevent backups from overwriting each other. The naming is weird,
" since I'm using the 'backupext' variable to append the path.
" So the file '/home/docwhat/.vimrc' becomes '.vimrc%home%docwhat~'
au BufWritePre * let &backupext = substitute(expand('%:p:h'), '/', '%', 'g') . '~'

" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

" viminfo stores the the state of your previous editing session
set viminfo+=n~/.vim/viminfo

if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif


" Misc. Commands
"-----------------------------------------------------------------------------
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
  \ | wincmd p | diffthis
endif


function! StripTrailingWhite()
  let l:winview = winsaveview()
  silent! %s/\s\+$//
  call winrestview(l:winview)
endfunction
autocmd BufWritePre *  call StripTrailingWhite()



" Key bindings
"-----------------------------------------------------------------------------
" In diff mode, recenter after changing to next/previous diff
map ]c ]czz
map [c [czz

map <silent> <Leader>b :buffers<CR>
map <silent> <Leader>h :noh<CR>

" Shortcuts for FuzzyFinder
map <silent> <Leader>ff :FufFile<CR>
map <silent> <Leader>fc :FufCoverageFile<CR>
map <silent> <Leader>fb :FufBuffer<CR>
map <silent> <Leader>fh :FufHelp<CR>
map <silent> <Leader>fl :FufLine<CR>
map <silent> <Leader>fq :FufQuickfix<CR>
map <silent> <Leader>ft :FufTag<CR>
map <silent> <Leader>fd :FufDir<CR>

" Paste from tmux
map <silent> <Leader>tp !!tmux show-buffer <Bar> cat<CR>

if has("macunix")
  if v:version >= 703
    " Default yank and paste go to Mac's clipboard
    set clipboard=unnamed
  endif
endif

" With a visual block seleced, fold on space. Refold on space in command mode.
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'1')<CR>
vnoremap <Space> zf

" Prevent highlight being lost on (de)indent.
vnoremap < <gv
vnoremap > >gv

" Indent whole file
map <silent> <Leader>g mzgg=G'z<CR>

" Make Y behave like other capitals.
map Y y$

" Don't use Ex mode, use Q for formatting
map Q gq


" Plugin, syntax, etc. options
"-----------------------------------------------------------------------------

" CScope
"-----------------------------------------------------------------------------
set cscopequickfix=s-,c-,d-,i-,t-,e-
set nocscopeverbose

" delimitMate options
"-----------------------------------------------------------------------------
let g:delimitMate_expand_cr=1
let g:delimitMate_expand_space = 1
let g:delimitMate_smart_quotes = 1
let g:delimitMate_balance_matchpairs = 1
au FileType python let b:delimitMate_nesting_quotes = ['"']

" FuzzyFinder
"-----------------------------------------------------------------------------
let g:fuf_file_exclude = '\v\~$|\.(o|exe|dll|bak|class|meta|lock|orig|jar|swp|pyc|pyo)$|/test/data\.|(^|[/\\])\.(hg|git|bzr)($|[/\\])'

" NERD Tree
"-----------------------------------------------------------------------------
nmap <F2> :NERDTreeToggle<CR>
let NERDTreeBookmarksFile="~/.vim/NERDTreeBookmarks"
let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.o$', '\.so$', '\.bmp$', '\.class$', '^core.*',
  \ '\.vim$', '\~$', '\.pyc$', '\.pyo$', '\.jpg$', '\.gif$',
  \ '\.png$', '\.ico$', '\.exe$', '\.cod$', '\.obj$', '\.mac$',
  \ '\.1st', '\.dll$', '\.pyd$', '\.zip$', '\.modules$']

" Python language
"-----------------------------------------------------------------------------
au FileType python set cinwords=if,elif,else,for,while,try,except,finally,def,class,with
au FileType python set omnifunc=pythoncomplete#Complete
au FileType python map <buffer> <S-e> :w<CR>:!/usr/bin/python %
au FileType python set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
au FileType python set efm=%.%#:\ (\'%m\'\\,\ (\'%f\'\\,\ %l\\,\ %c%.%# "
"au FileType python set textwidth=79 " PEP-8 Friendly
au FileType python set tabstop=4 shiftwidth=4 softtabstop=4

" Ruby syntax
"-----------------------------------------------------------------------------
au FileType ruby set cinwords=do
"

" java/c/cpp/objc syntax
"-----------------------------------------------------------------------------
au FileType java,c,cpp,objc set smartindent tabstop=4 shiftwidth=4 softtabstop=4
au FileType java,c,cpp,objc let b:loaded_delimitMate = 1
"

" markdown specific settings
"-----------------------------------------------------------------------------
au BufNewFile,BufRead *.mdwn,*.mkd,*.md,*.markdown set filetype=markdown

" Fix constant spelling mistakes
"-----------------------------------------------------------------------------
iab teh the
iab Teh The
iab taht that
iab Taht That
iab alos also
iab Alos Also
iab aslo also
iab Aslo Also

" Local vimrc settings
"-----------------------------------------------------------------------------
" If the file ~/.vimrc.local exists, then it will be loaded as well.

if filereadable($HOME . '/.vimrc.local')
  execute 'source ' . $HOME . '/.vimrc.local'
endif
