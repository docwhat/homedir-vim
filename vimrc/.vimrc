" Configuration file for VIM
"
" By Christian Holtje & Shawn Zabel
"
" Vim should auto-install Vundle and all the required parts...
" If it fails for some reason, then you can do it manually with:
"    mkdir -p ~/.vim/bundle && git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle && vim -c ':BundleInstall' -c ':qa!'
" Update your vundle packages with:
"    vim -c ':BundleInstall!' -c ':qa!'
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
"

" Remove ALL autocommands to prevent them from being loaded twice.
if has("autocmd")
  autocmd!
endif

" Options
"-----------------------------------------------------------------------------
set nocompatible                 " The most important VIM option
scriptencoding utf-8
set modelines=5                  " The Vim that comes with OS X changed the default value for some reason. Setting it back.

set smarttab
set tabstop=2                    " set the default tabstops
set shiftwidth=2                 " set the default autoindent
set softtabstop=2
set expandtab
set hidden

set autoindent
set backspace=indent,eol,start   " Set for maximum backspace smartness

set nowrap                       " Soft (without changing text) wrapping.
set linebreak                    " Only wrap on characters in `breakat`
if has('multi_byte')
  let &showbreak = '↳ '
else
  let &showbreak = '> '
endif

set ignorecase                   " ignore case in searches ... (\c\C override)
set smartcase                    " ... unless there are caps in the search
set incsearch                    " If the terminal is slow, turn this off

set number
set wildmode=list:longest,full   " Completion for wildchar (see help)
set wildmenu
set wildignore+=*.o,*.obj,*.pyc,*.pyo,*.pyd,*.class,*.lock
set wildignore+=*.png,*.gif,*.jpg,*.ico
set wildignore+=.git,.svn,.hg
set showcmd                      " display incomplete commands

set showmatch                    " Show the matching bracket
set matchpairs=(:),{:},[:]       " List of characters we expect in balanced pairs

set cursorline                   " highlights the current line
set history=1000                 " Save more history.

" Vundler - vim package manager
"-----------------------------------------------------------------------------
function! LoadBundles()
  " let Vundle manage Vundle
  " required!
  Bundle 'gmarik/vundle'

  " Allows editing remote files.
  " :e dav://machine[:port]/path                  uses cadaver
  " :e fetch://[user@]machine/path                uses fetch
  " :e ftp://[user@]machine[[:#]port]/path        uses ftp   autodetects <.netrc>
  " :e http://[user@]machine/path                 uses http  uses wget
  " :e rcp://[user@]machine/path                  uses rcp
  " :e rsync://[user@]machine[:port]/path         uses rsync
  " :e scp://[user@]machine[[:#]port]/path        uses scp
  " :e sftp://[user@]machine/path                 uses sftp
  if v:version > 702
    Bundle 'netrw.vim'
    let g:netrw_home=expand('~/.vim')
  endif

  " Press F2 to see a list of files and directories from your
  " current working directory
  Bundle 'scrooloose/nerdtree'

  " Command and uncomment code easily
  Bundle 'scrooloose/nerdcommenter'

  if v:version > 702
    if v:version > 703 || (v:version == 703 && has("patch418"))
      " Let John use up/down arrows in insert mode. *shudder*
      let g:neocomplcache_enable_cursor_hold_i=1
    endif

    Bundle 'Shougo/neocomplcache'
    " Plugin key-mappings.
    imap <C-k> <Plug>(neocomplcache_snippets_expand)
    smap <C-k> <Plug>(neocomplcache_snippets_expand)
    inoremap <expr> <C-g> neocomplcache#undo_completion()
    inoremap <expr> <C-l> neocomplcache#complete_common_string()
    " <CR>: close popup and save indent. This is a
    " function to prevent problems with endwise.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return neocomplcache#smart_close_popup() . "\<CR>"
      " For no inserting <CR> key.
      "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr> <TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr> <C-h> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr> <BS> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr> <C-y>  neocomplcache#close_popup()
    inoremap <expr> <C-e>  neocomplcache#cancel_popup()

    Bundle 'Shougo/neosnippet'
    " Plugin key-mappings.
    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)

    " For snippet_complete marker.
    if has('conceal')
      set conceallevel=2 concealcursor=i
    endif

    Bundle 'honza/vim-snippets'
    " Tell NeoSnippet about these snippets
    let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
  endif


  " Autopair mode - If you type '(', it'll fill in ')'
  Bundle 'jiangmiao/auto-pairs'

  " Adds matching 'end*' type syntax for ruby, vimscript, and lua
  Bundle 'tpope/vim-endwise'

  " Move lines with '[e' and ']e'.
  Bundle 'tpope/vim-unimpaired'

  " Detect indentation
  Bundle 'tpope/vim-sleuth'

  " Focus (zooms a buffer) -- <leader>fmt
  Bundle "merlinrebrovic/focus.vim"

  " Bubble single line
  nmap <C-Up> [e
  nmap <C-Down> ]e

  " Bubble multiple lines
  vmap <C-Up> [egv
  vmap <C-Down> ]egv

  " lets you align comments, equal signs, etc.
  Bundle 'godlygeek/tabular'

  if v:version > 700
    " Exhuberant CTags browsers
    Bundle 'majutsushi/tagbar'
  endif

  " Syntax checking
  if exists('*getmatches')
    Bundle 'scrooloose/syntastic'
    let g:syntastic_error_symbol='✗'
    let g:syntastic_warning_symbol='⚠'
    let g:syntastic_check_on_open=1
    let g:syntastic_auto_loc_list=1 " Close the location-list when errors are gone
    let g:syntastic_loc_list_height=5
    Bundle 'dbakker/vim-lint'
  endif

  " Display an indent line
  Bundle 'Yggdroot/indentLine'
  let g:indentLine_char = "⋮"
  let g:indentLine_noConcealCursor = 1

  " Latest vim-ruby
  Bundle 'vim-ruby/vim-ruby'

  " Rails, bundler, etc.
  Bundle 'tpope/vim-rails'
  Bundle 'tpope/vim-bundler'
  Bundle 'tpope/vim-cucumber'
  Bundle 'tpope/vim-rake'

  " Get me some RVM/Rbenv support
  if exists("$rvm_path")
    Bundle 'tpope/vim-rvm'
  else
    Bundle 'tpope/vim-rbenv'
  endif

  " ds/cs/ys for deleting, changing, your surrounding chars (like ', ", etc.)
  Bundle 'tpope/vim-surround'

  " Deal with git in a sane way
  Bundle 'tpope/vim-fugitive'

  " Support '.' correctly for plugins that support this module.
  Bundle 'tpope/vim-repeat'

  " Allow chording 'jk' as a replacement for ESC
  Bundle 'arpeggio'
  if exists('g:loaded_arpeggio')
    call arpeggio#map('i', '', 0, 'jk', '<Esc>')
  endif

  " Allow executing vim with a file:lineno
  Bundle 'bogado/file-line'

  " SSH authorized_keys
  Bundle 'xevz/vim-sshauthkeys'

  " Allow C-A/C-X to work correctly with dates/times.
  Bundle 'tpope/vim-speeddating'

  " The only theme worth knowing.
  Bundle 'altercation/vim-colors-solarized'

  if v:version >= 702
    Bundle 'bling/vim-airline'
    let g:airline_powerline_fonts = 1
    let g:airline_theme='solarized'
    set noshowmode
  endif

  " HTML5 + SVG support
  Bundle 'othree/html5.vim'

  " HTML/XML close tag support
  " Use C-_ in insert or normal mode.
  Bundle "closetag.vim"

  " Show a facsimile of CSS colors as a highlight.
  Bundle "ap/vim-css-color"

  " Puppet configuration syntax
  Bundle 'rodjek/vim-puppet'

  if executable('ag')
    " Ag, the silver searcher
    Bundle 'rking/ag.vim'
  elseif executable('ack-grep')
    " Ack, the better-grepper-upper
    let g:ackprg="ack-grep -H --nocolor --nogroup --column"
    Bundle 'mileszs/ack.vim'
  elseif executable('ack')
    " Ack, the better-grepper-upper
    let g:ackprg="ack -H --nocolor --nogroup --column"
    Bundle 'mileszs/ack.vim'
  endif

  " Coffeescript Support
  Bundle 'kchmck/vim-coffee-script'

  " Scala, breakfast of Joe's everywhere
  Bundle 'derekwyatt/vim-scala'

  " JSON & JS
  Bundle 'elzr/vim-json'
  Bundle 'pangloss/vim-javascript'

  " Haskell support
  Bundle 'Twinside/vim-syntax-haskell-cabal'
  Bundle 'lukerandall/haskellmode-vim'

  Bundle 'tpope/vim-markdown'

  " Groovy -- Make sure you set the GROOVY_HOME environment variable
  Bundle 'vim-scripts/groovy.vim--Ruley.git'

  Bundle 'mattn/webapi-vim'
  Bundle 'mattn/gist-vim'
  if has('macunix')
    let g:gist_clip_command = 'pbcopy'
  endif

  " Like Command T for TextMate.
  " <leader>t to activate
  " <C-d> to toggle between just matching filename or whole path.
  Bundle 'kien/ctrlp.vim'
  let g:ctrlp_map  = '<leader>t'
  let g:ctrlp_match_window_reversed = 0
  let g:ctrlp_custom_ignore = {
        \ 'dir': '\v[\/](\.git|\.hg|\.svn|CVS|tmp|Library|Applications|Music|[^\/]*-store)$',
        \ 'file': '\v\.(exe|so|dll)$',
        \ }
  let g:ctrlp_user_command = {
        \ 'types' : {
        \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
        \ }
        \ }
  let g:ctrlp_max_height = 30
  if has('macunix')
    let g:ctrlp_mruf_case_sensitive = 0
  endif
  nnoremap <leader>r :CtrlPMRU<cr>

  " Text Objects
  " ------------

  " CamelCaseMotion
  " Adds:
  "   ,w (Camel word move)
  "   ,b (Camel backwards word move)
  "   ,e (Camel end-of-word move)
  Bundle 'bkad/CamelCaseMotion'

  " Indent Objects
  " Adds:
  "   ai (Python/HAML indents)
  "   ii (Just the inner parts)
  "   aI (Ruby/Bash style indents with endifs, etc.)
  "   iI (alias for ii)
  Bundle 'michaeljsmith/vim-indent-object'

  " Ruby Block Object
  " Adds:
  "   r (Ruby block)
  Bundle 'kana/vim-textobj-user'
  Bundle 'nelstrom/vim-textobj-rubyblock'

  if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
  endif
endfunction

filetype off                   " required!

" Only install vundle and bundles if git exists...
if executable("git")
  if !isdirectory(expand("~/.vim/bundle/vundle"))
    echomsg "******************************"
    echomsg "Installing Vundler..."
    echomsg "******************************"
    echomsg ""
    silent !mkdir -p ~/.vim/bundle && git clone --quiet https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    let s:bootstrap=1
  endif

  set rtp+=~/.vim/bundle/vundle/
  call vundle#rc()
  call LoadBundles()

  if exists("s:bootstrap") && s:bootstrap
    unlet s:bootstrap
    BundleInstall
    quit
  endif
endif

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

" Helper functions
"-----------------------------------------------------------------------------

" A wrapper function to restore the cursor position, window position,
" and last search after running a command.
function! Preserve(command)
  " Save the last search
  let last_search=@/
  " Save the current cursor position
  let save_cursor = getpos(".")
  " Save the window position
  normal H
  let save_window = getpos(".")
  call setpos('.', save_cursor)

  " Do the business:
  execute a:command

  " Restore the last_search
  let @/=last_search
  " Restore the window position
  call setpos('.', save_window)
  normal zt
  " Restore the cursor position
  call setpos('.', save_cursor)
endfunction

" Terminal and display settings
"-----------------------------------------------------------------------------
set laststatus=2      " show status line all the time
set scrolloff=5       " don't scroll any closer to top/bottom
set sidescrolloff=5   " don't scroll any closer to left/right

if !(exists('g:powerline_loaded') || exists('g:loaded_airline'))
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
  if exists('g:loaded_fugitive')
    set statusline+=%{fugitive#statusline()}
  endif
  set statusline+=%=                                                                  " left/right separator
  set statusline+=\ %#warningmsg#                                                     " start warnings highlight group
  if exists('g:loaded_syntastic_plugin')
    set statusline+=%{SyntasticStatuslineFlag()}                                      " SyntasticStatusLine
  endif
  set statusline+=%*                                                                  " end highlight group
  set statusline+=%c,                                                                 " cursor column
  set statusline+=%l/%L                                                               " cursor line/total lines
  set statusline+=\ %P                                                                " percent through file
endif

" Syntastical statusline format - Ignored when powerline is enabled.
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'

" Gnome terminal doesn't advertise its 256-colors
" http://askubuntu.com/a/126
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

try
  colorscheme solarized
catch /^Vim\%((\a\+)\)\=:E185/
  " deal wit it
endtry

" In many terminal emulators the mouse works just fine, thus enable it.
if v:version >= 702 && has('mouse')
  set mouse=a
  if &term =~ "xterm" || &term =~ "screen"
    set ttymouse=xterm2
  endif
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
syntax on
set hlsearch

set list listchars=tab:»·,trail:·,nbsp:+ " Show the leading whitespaces
set display+=uhex                         " Show unprintables as <xx>
set display+=lastline                     " show as much as possible of the last line.

" Backups, undos, and swap files
"-----------------------------------------------------------------------------
" Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.
if isdirectory($HOME . '/.vim/backup') == 0
  silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
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
if has("autocmd")
  autocmd BufWritePre * nested let &backupext = substitute(expand('%:p:h'), '/', '%', 'g') . '~'
endif


if has("macunix")
  set backupskip+=/private/tmp/*
endif

" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
  silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
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
    silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
  set undolevels=1000         " maximum number of changes that can be undone
  set undoreload=10000        " maximum number lines to save for undo on a buffer reload
endif

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
if has("autocmd")
  autocmd BufReadPost * nested
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
endif


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
if has("autocmd")
  autocmd BufWritePre * nested call StripTrailingWhite()
endif

" Needed for some snippets
fun! Filename(...)
  let filename = expand('%:t:r')
  if filename == '' | return a:0 == 2 ? a:2 : '' | endif
  return !a:0 || a:1 == '' ? filename : substitute(a:1, '$1', filename, 'g')
endf

" Omnicompletion
"-----------------------------------------------------------------------------

set completeopt=menu,longest
set omnifunc=syntaxcomplete#Complete " This is overriden by syntax plugins.

" NeoComplCache
"-----------------------------------------------------------------------------
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 2
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
" Store temporary files in standard location.
let g:neocomplcache_temporary_dir='~/.vim/neocon'

" Define dictionary.
"let g:neocomplcache_dictionary_filetype_lists = {
"    \ 'default' : '',
"    \ 'vimshell' : $HOME.'/.vimshell_hist',
"    \ 'scheme' : $HOME.'/.gosh_completions'
"    \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" AutoComplPop like behavior.
let g:neocomplcache_enable_auto_select = 0

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'



" Key bindings
"-----------------------------------------------------------------------------
" In diff mode, recenter after changing to next/previous diff
map ]c ]czz
map [c [czz

map <silent> <Leader>b :buffers<CR>
map <silent> <Leader>h :noh<CR>

" Add lines as converse of <S-J> (join lines)
nnoremap <C-J> o<Esc>k$
" nnoremap <S-C-J> O<Esc>j$

" Paste from tmux
"map <silent> <Leader>tp !!tmux show-buffer <Bar> cat<CR>

" With a visual block seleced, fold on space. Refold on space in command mode.
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'1')<CR>
xnoremap <Space> zf

" Prevent highlight being lost on (de)indent.
xnoremap < <gv
xnoremap > >gv

" Indent whole file
"map <silent> <Leader>g mzgg=G'z<CR>
nmap <silent> <Leader>g :call Preserve("normal gg=G")<CR>
nmap <silent> <Leader><space> :call Preserve("%s/\\s\\+$//e")<CR>

" Get Jared to use hjkl instead of cursor keys...
nmap <Left> :echo "I don't like that direction..."<cr>
nmap <Right> :echo "Republican, eh?"<cr>
nmap <Up> :echo "This is why we can't have nice things."<cr>
nmap <Down> :echo "That's what she said."<cr>

" Make Y behave like other capitals.
map Y y$

" Don't use Ex mode, use Q for formatting
map Q gq

"" Support per-project .vimrc files. -
"set exrc

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" Some helpers to edit mode
" http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Change Working Directory to that of the current file
cmap cwd lcd %%
cmap cd. lcd %%

" GUI Settings
"-----------------------------------------------------------------------------
if has('gui_running')
  set guioptions-=T " remove the toolbar
  if has("gui_gtk2")
    " We need good defaults for Linux
    "set guifont=Andale\ Mono\ Regular\ 16,Menlo\ Regular\ 15,Consolas\ Regular\ 16,Courier\ New\ Regular\ 18
  elseif has('gui_macvim')
    set transparency=3
    set guifont=Meslo\ LG\ S\ DZ\ for\ Powerline:h14,Menlo:h14
  else
    " We need good defaults for Windows
    "set guifont=Andale\ Mono\ Regular:h16,Menlo\ Regular:h15,Consolas\ Regular:h16,Courier\ New\ Regular:h18
  endif
endif

" CScope
"-----------------------------------------------------------------------------
set cscopequickfix=s-,c-,d-,i-,t-,e-
set nocscopeverbose

" CtrlP auto cache clearing.
" ----------------------------------------------------------------------------
function! SetupCtrlP()
  if exists("g:loaded_ctrlp") && g:loaded_ctrlp
    augroup CtrlPExtension
      autocmd!
      autocmd FocusGained  * nested CtrlPClearCache
      autocmd BufWritePost * nested CtrlPClearCache
    augroup END
  endif
endfunction
if has("autocmd")
  autocmd VimEnter * nested call SetupCtrlP()
endif

" Command-T
" ----------------------------------------------------------------------------
function! SetupCommandT()
  if exists("g:command_t_loaded")
    augroup CommandTExtension
      autocmd!
      autocmd FocusGained  * nested CommandTFlush
      autocmd BufWritePost * nested CommandTFlush
    augroup END
  endif
endfunction
if has("autocmd")
  autocmd VimEnter * nested call SetupCommandT()
endif

" NERD Tree
"-----------------------------------------------------------------------------
nmap <leader>n :NERDTreeToggle<CR>
let NERDTreeBookmarksFile = expand('~/.vim/NERDTreeBookmarks')
let NERDTreeShowBookmarks=1
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let g:nerdtree_tabs_open_on_gui_startup=0
let NERDTreeIgnore=['\.o$', '\.so$', '\.bmp$', '\.class$', '^core.*',
      \ '\.vim$', '\~$', '\.pyc$', '\.pyo$', '\.jpg$', '\.gif$',
      \ '\.png$', '\.ico$', '\.exe$', '\.cod$', '\.obj$', '\.mac$',
      \ '\.1st', '\.dll$', '\.pyd$', '\.zip$', '\.modules$',
      \ '\.git', '\.hg', '\.svn', '\.bzr' ]

" Python language
"-----------------------------------------------------------------------------
if has("autocmd")
  " TODO: Lookup some pydoc/better-python plugins
  " http://vim.wikia.com/wiki/Omnicomplete_-_Remove_Python_Pydoc_Preview_Window
  " maybe for ruby too?
  autocmd FileType python nested setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType python nested setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class,with
  autocmd FileType python nested map <buffer> <S-e> :w<CR>:!/usr/bin/python %
  autocmd FileType python nested setlocal makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
  autocmd FileType python nested setlocal efm=%.%#:\ (\'%m\'\\,\ (\'%f\'\\,\ %l\\,\ %c%.%# "
  "autocmd FileType python nested set textwidth=79 " PEP-8 Friendly
  autocmd FileType python nested setlocal tabstop=4 shiftwidth=4 softtabstop=4
endif

" Ruby syntax
"-----------------------------------------------------------------------------
if has("autocmd")
  autocmd FileType ruby,eruby nested setlocal cinwords=do
  autocmd FileType ruby,eruby nested let g:rubycomplete_buffer_loading=1
  autocmd FileType ruby,eruby nested let g:rubycomplete_rails = 1
  autocmd FileType ruby,eruby nested let g:rubycomplete_classes_in_global=1
  autocmd BufNewFile,BufRead *.html.erb nested setlocal filetype=html.eruby
  autocmd BufNewFile,BufRead *.js.erb   nested setlocal filetype=javascript.eruby
endif

" java/c/cpp/objc syntax
"-----------------------------------------------------------------------------
if has("autocmd")
  autocmd FileType java,c,cpp,objc nested setlocal smartindent tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType java,c,cpp,objc nested let b:loaded_delimitMate = 1
endif

" JavaScript syntax
"-----------------------------------------------------------------------------
if has("autocmd")
  autocmd FileType javascript nested setlocal smartindent expandtab
  if has('conceal')
    autocmd FileType json nested setlocal concealcursor= conceallevel=1
  endif
endif

" markdown specific settings
"-----------------------------------------------------------------------------
if has("autocmd")
  autocmd BufNewFile,BufRead *.mdwn,*.mkd,*.md,*.markdown nested setlocal filetype=markdown textwidth=79
  autocmd FileType markdown                               nested setlocal tabstop=4 shiftwidth=4 softtabstop=4 spell
endif

" Git commit files
"-----------------------------------------------------------------------------
if has("autocmd")
  autocmd FileType gitcommit            nested setlocal spell
  autocmd VimEnter .git/PULLREQ_EDITMSG nested setlocal filetype=markdown
endif

" Fix constant spelling and typing mistakes
"-----------------------------------------------------------------------------
iab teh the
iab Teh The
iab taht that
iab Taht That
iab alos also
iab Alos Also
iab aslo also
iab Aslo Also
iab recipies recipes
iab Recipies Recipes
iab RECIPIES RECIPES

if has("user_commands")
  command! -bang -nargs=* -complete=file E e<bang> <args>
  command! -bang -nargs=* -complete=file W w<bang> <args>
  command! -bang -nargs=* -complete=file Wq wq<bang> <args>
  command! -bang -nargs=* -complete=file WQ wq<bang> <args>
  command! -bang Wa wa<bang>
  command! -bang WA wa<bang>
  command! -bang Q q<bang>
  command! -bang QA qa<bang>
  command! -bang Qa qa<bang>
endif

" Ensure we have matchit support
runtime macros/matchit.vim

" Local vimrc settings
"-----------------------------------------------------------------------------
" If the file ~/.vimrc.local exists, then it will be loaded as well.

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

set secure
" EOF
