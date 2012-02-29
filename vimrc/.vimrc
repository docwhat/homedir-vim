" Configuration file for VIM

set nocompatible                 " The most important VIM option

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
set matchpairs=(:),{:},[:]

"-----------------------------------------------------------------------------
" Vundler
"-----------------------------------------------------------------------------
" Install with:
"    git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

filetype off                   " required!

function! LoadBundles()
  " let Vundle manage Vundle
  " required!
  Bundle 'gmarik/vundle'

  Bundle 'The-NERD-tree'
  Bundle 'The-NERD-Commenter'

  Bundle 'MarcWeber/vim-addon-mw-utils'
  Bundle 'tomtom/tlib_vim'
  Bundle 'garbas/vim-snipmate'
  Bundle 'snipmate-snippets'

  Bundle 'bsl/obviousmode'

  Bundle 'L9'
  Bundle 'FuzzyFinder'

  Bundle 'delimitMate.vim'

  Bundle 'godlygeek/tabular'

  " Exhuberant CTags browsers
  Bundle 'Tagbar'

  " Python Linting
  if has("python")
    Bundle 'pyflakes.vim'
  endif

  " The only theme worth knowing.
  Bundle 'altercation/vim-colors-solarized'

  " ds/cs/ys for deleting, changing, your surrounding chars (like ', ", etc.)
  Bundle 'tpope/vim-surround'

  " :A Switches between header and implementation file.
  Bundle 'a.vim'

  " original repos on github
  "Bundle 'tpope/vim-fugitive'
  "Bundle 'Lokaltog/vim-easymotion'
  "Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
  "Bundle 'tpope/vim-rails.git'
  "" vim-scripts repos
  "Bundle 'L9'
  "Bundle 'FuzzyFinder'
  "" non github repos
  "Bundle 'git://git.wincent.com/command-t.git'
  "" ...
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

"-----------------------------------------------------------------------------
"  Bundle 'bsl/obviousmode' settings
"-----------------------------------------------------------------------------
let g:obviousModeInsertHi             = "term = reverse ctermfg = 227 ctermbg = 52"
let g:obviousModeCmdwinHi             = "term = reverse ctermfg = 227 ctermbg = 22"
let g:obviousModeModifiedCurrentHi    = "term = reverse ctermfg = 227 ctermbg = 30"
let g:obviousModeModifiedNonCurrentHi = "term = reverse ctermfg = 227 ctermbg = 23"
let g:obviousModeModifiedVertSplitHi  = "term = reverse ctermfg = 227 ctermbg = 23"

"-----------------------------------------------------------------------------
" Terminal/Display settings
"-----------------------------------------------------------------------------
set laststatus=2          " show status line all the time
set scrolloff=5           " don't scroll any closer to top/bottom
set statusline=%t         " tail of the filename
set statusline+=\         " whitespace
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}]   " file format
set statusline+=\         " whitespace
set statusline+=%h        " help file flag
set statusline+=%m        " modified flag
set statusline+=%r        " read only flag
set statusline+=%y        " filetype
set statusline+=%w        " filetype
set statusline+=%=        " left/right separator
set statusline+=%c,       " cursor column
set statusline+=%l/%L     " cursor line/total lines
set statusline+=\ %P      " percent through file

set background=dark

" highlights the current line
autocmd WinLeave * set nocursorline
autocmd WinEnter * set cursorline

" The Smash Escape
inoremap jk <Esc>
inoremap kj <Esc>

try
  colorscheme solarized
catch /^Vim\%((\a\+)\)\=:E185/
  " deal wit it
endtry

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
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

"-----------------------------------------------------------------------------
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

"-----------------------------------------------------------------------------
" CScope
"-----------------------------------------------------------------------------
set cscopequickfix=s-,c-,d-,i-,t-,e-
set nocscopeverbose


"-----------------------------------------------------------------------------
" Key Bindings
"-----------------------------------------------------------------------------

" In diff mode, recenter after changing to next/previous diff
map ]c ]czz
map [c [czz

map <silent> <Leader>b :buffers<CR>
map <silent> <Leader>h :noh<CR>

" Shortcuts for editing .vimrc
map <silent> <Leader>ve :edit ~/.vimrc<CR>
map <silent> <Leader>vs :split ~/.vimrc<CR>
map <silent> <Leader>vv :vsplit ~/.vimrc<CR>

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

if version >= 730 && has("macunix")
  " Default yank and paste go to Mac's clipboard
  set clipboard=unnamed
end

" With a visual block seleced, fold on space. Refold on space in command mode.
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'1')<CR>
vnoremap <Space> zf

" Prevent highlight being lost on (de)indent.
vnoremap < <gv
vnoremap > >gv

" Make Y behave like other capitals.
map Y y$

" Don't use Ex mode, use Q for formatting
map Q gq

"-----------------------------------------------------------------------------
" FuzzyFinder Settings
"-----------------------------------------------------------------------------
let g:fuf_file_exclude = '\v\~$|\.(o|exe|dll|bak|class|meta|lock|orig|jar|swp|pyc|pyo)$|/test/data\.|(^|[/\\])\.(hg|git|bzr)($|[/\\])'

"-----------------------------------------------------------------------------
" NERD Tree Plugin Settings
"-----------------------------------------------------------------------------
nmap <F2> :NERDTreeToggle<CR>
let NERDTreeBookmarksFile="~/.vim/NERDTreeBookmarks"
let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.o$', '\.so$', '\.bmp$', '\.class$', '^core.*',
  \ '\.vim$', '\~$', '\.pyc$', '\.pyo$', '\.jpg$', '\.gif$',
  \ '\.png$', '\.ico$', '\.exe$', '\.cod$', '\.obj$', '\.mac$',
  \ '\.1st', '\.dll$', '\.pyd$', '\.zip$', '\.modules$']

"-----------------------------------------------------------------------------
" Python specific settings
"-----------------------------------------------------------------------------
au FileType python set cinwords=if,elif,else,for,while,try,except,finally,def,class,with
au FileType python set omnifunc=pythoncomplete#Complete
au FileType python map <buffer> <S-e> :w<CR>:!/usr/bin/python %
au FileType python set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
au FileType python set efm=%.%#:\ (\'%m\'\\,\ (\'%f\'\\,\ %l\\,\ %c%.%# "
"au FileType python set textwidth=79 " PEP-8 Friendly
au FileType python set tabstop=4 shiftwidth=4 softtabstop=4

"-----------------------------------------------------------------------------
" Ruby specific settings
"-----------------------------------------------------------------------------
au FileType ruby set cinwords=do

"-----------------------------------------------------------------------------
" java/c/cpp/objc specific settings
"-----------------------------------------------------------------------------
au FileType java,c,cpp,objc set smartindent tabstop=4 shiftwidth=4 softtabstop=4
au FileType java,c,cpp,objc let b:loaded_delimitMate = 1

"-----------------------------------------------------------------------------
" markdown specific settings
"-----------------------------------------------------------------------------
au BufNewFile,BufRead *.mdwn,*.mkd,*.md,*.markdown set filetype=markdown

"-----------------------------------------------------------------------------
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

