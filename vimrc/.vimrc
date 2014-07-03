" Configuration file for VIM
"
" By Christian Holtje & Shawn Zabel
"
" QuickStart
"
" Vim should auto-install Vundle and all the required parts...
" If it fails for some reason, then you can do it manually with:
"    mkdir -p ~/.vim/bundle && git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle && vim -c ':PluginInstall' -c ':qa!'
" Update your vundle packages with:
"    vim -c ':PluginUpdate' -c ':qa!'
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
if has('autocmd')
  autocmd!
endif

" We love syntax highlighting.
if has('syntax')
  syntax enable
endif

" Options
"-----------------------------------------------------------------------------
" See `:h options` for more help.
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
set shiftround                   " Round indents to a multiple of 'shiftwidth'
set complete-=i                  " Don't scan includes, since it can be very slow.
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
function! LoadPlugins()
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
    Plugin 'netrw.vim'
    let g:netrw_home=expand('~/.vim')
  endif

  if has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
    " Use NeoComplete
    " ---------------
    let g:neocomplete#enable_at_startup              = 1
    let g:neocomplete#force_overwrite_completefunc   = 1
    let g:neocomplete#data_directory                 = '~/.vim/neocomplcache'

    let g:neocomplete#auto_completion_start_length   = 2
    let g:neocomplete#manual_completion_start_length = 0
    let g:neocomplete#min_keyword_length             = 3
    let g:neocomplete#enable_auto_close_preview      = 1

    let g:neocomplete#keyword_patterns      = {}
    let g:neocomplete#keyword_patterns._    = '\h\w*'
    let g:neocomplete#keyword_patterns.perl = '\h\w*->\h\w*\|\h\w*::\w*'

    let g:neocomplete#sources#omni#input_patterns      = {}
    let g:neocomplete#sources#omni#input_patterns.php  = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.c    = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#sources#omni#input_patterns.cpp  = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    let g:neocomplete#force_omni_input_patterns      = {}
    let g:neocomplete#force_omni_input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::\w*'

    let g:neocomplete#same_filetypes           = {}
    let g:neocomplete#same_filetypes.gitconfig = '_'
    let g:neocomplete#same_filetypes._         = '_'

    function! s:my_cr_function()
      return neocomplete#close_popup() . "\<CR>"
    endfunction

    Plugin 'Shougo/neocomplete'
    Plugin 'Shougo/neosnippet'
    Plugin 'Shougo/neosnippet-snippets'

    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()

    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>     <Plug>(neosnippet_expand_target)

    " SuperTab like snippets behavior.
    imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
          \ "\<Plug>(neosnippet_expand_or_jump)"
          \: pumvisible() ? "\<C-n>" : "\<TAB>"
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
          \ "\<Plug>(neosnippet_expand_or_jump)"
          \: "\<TAB>"

    " For snippet_complete marker.
    if has('conceal')
      set conceallevel=2 concealcursor=i
    endif

  elseif v:version > 702
    " Use NeoComplCache
    " -----------------

    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_force_overwrite_completefunc = 1

    " Store temporary files in standard location.
    let g:neocomplcache_temporary_dir='~/.vim/neocomplcache'

    " Define keyword.
    let g:neocomplcache_keyword_patterns = {}
    let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

    " Enable heavy omni completion.
    let g:neocomplcache_omni_patterns = {}
    "let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    "let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

    if !exists('g:neocomplcache_force_omni_patterns')
      let g:neocomplcache_force_omni_patterns = {}
    endif
    let g:neocomplcache_force_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

    " Completes from all buffers.
    if !exists('g:neocomplcache_same_filetype_lists')
      let g:neocomplcache_same_filetype_lists = {}
    endif
    let g:neocomplcache_same_filetype_lists.gitconfig = '_'
    let g:neocomplcache_same_filetype_lists._ = '_'

    " Disable NeoComplCache for certain filetypes
    if has('autocmd')
      augroup NeoComplCache
        autocmd!
        autocmd FileType pandoc,markdown nested NeoComplCacheLock
      augroup END
    endif

    Plugin 'Shougo/neocomplcache'

    inoremap <expr> <C-g> neocomplcache#undo_completion()
    inoremap <expr> <C-l> neocomplcache#complete_common_string()
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return neocomplcache#smart_close_popup() . "\<CR>"
    endfunction
    inoremap <expr> <TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr> <C-h> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr> <BS> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr> <C-y>  neocomplcache#close_popup()
    inoremap <expr> <C-e>  neocomplcache#cancel_popup()

    " Use NeoSnippet
    " ----------
    " We have NeoComplCache or NeoComplete

    Plugin 'honza/vim-snippets'
    " Tell NeoSnippet about these snippets
    let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

    Plugin 'Shougo/neosnippet'
    Plugin 'Shougo/neosnippet-snippets'

    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>     <Plug>(neosnippet_expand_target)
    imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
          \ "\<Plug>(neosnippet_expand_or_jump)"
          \: pumvisible() ? "\<C-n>" : "\<TAB>"
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
          \ "\<Plug>(neosnippet_expand_or_jump)"
          \: "\<TAB>"

    " For snippet_complete marker.
    if has('conceal')
      set conceallevel=2 concealcursor=i
    endif
  endif

  " Press F2 to see a list of files and directories from your
  " current working directory
  Plugin 'scrooloose/nerdtree'
  nnoremap <silent> <leader>nt :call NERDTreeFindOrClose()<CR>
  function! NERDTreeFindOrClose()
    if exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1
      NERDTreeClose
    else
      if bufname('%') == ''
        NERDTree
      else
        NERDTreeFind
      endif
    endif
  endfunction
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

  if v:version > 700
    " Command and uncomment code easily
    " <leader>cc -- comment ragged style
    " <leader>cl -- comment aligned style
    " <leader>cu -- uncomment
    " <leader>ci -- toggle comments
    Plugin 'scrooloose/nerdcommenter'
    let g:NERDRemoveExtraSpaces=1
    let g:NERDSpaceDelims=1
    let g:NERDCommentWholeLinesInVMode=2
  endif

  " Navigate seemlessly between tmux panes and vim windows.
  " Note: See https://github.com/christoomey/vim-tmux-navigator for
  " how to setup your ~/.tmux.conf file.
  Plugin 'christoomey/vim-tmux-navigator'

  " NGinx configuration files.
  Plugin 'evanmiller/nginx-vim-syntax'

  " Adds matching 'end*' type syntax for ruby, vimscript, and lua
  Plugin 'tpope/vim-endwise'
  Plugin 'tpope/vim-abolish'

  " Move lines with '[e' and ']e' along with a lot of other
  " fun things.  :help unimpaired
  Plugin 'tpope/vim-unimpaired'
  " Bubble single line
  nmap <C-S-k> <Plug>unimpairedMoveUp
  nmap <C-S-j> <Plug>unimpairedMoveDown

  " Bubble visually selected lines
  xmap <C-S-k> <Plug>unimpairedMoveUp gv
  xmap <C-S-j> <Plug>unimpairedMoveDown gv

  " Detect indentation
  Plugin 'tpope/vim-sleuth'

  " Focus (zooms a buffer) -- <leader>fmt
  Plugin 'merlinrebrovic/focus.vim'

  " lets you align comments, equal signs, etc.
  Plugin 'godlygeek/tabular'

  if v:version > 700
    " Exhuberant CTags browsers
    Plugin 'majutsushi/tagbar'
    nnoremap <silent> <Leader>tb :TagbarToggle<CR>
  endif

  " Syntax checking
  if exists('*getmatches')
    Plugin 'scrooloose/syntastic'
    let g:syntastic_error_symbol          = '✗✗'
    let g:syntastic_warning_symbol        = '⚠⚠'
    let g:syntastic_style_error_symbol    = '✗'
    let g:syntastic_style_warning_symbol  = '⚠'
    let g:syntastic_auto_loc_list         = 1 " Close the location-list when errors are gone
    let g:syntastic_loc_list_height       = 5
    let g:syntastic_sh_checkers           = ['shellcheck', 'checkbashisms', 'sh']
    let g:syntastic_sh_checkbashisms_args = '-x'
    let g:syntastic_ruby_checkers         = ['mri', 'jruby', 'rubocop']
    let g:syntastic_ruby_rubocop_args     = '--display-cop-names'
    let g:syntastic_scss_checkers         = ['sass']
    let g:syntastic_sass_checkers         = ['sass']
    let g:syntastic_xml_checkers          = ['xmllint']
    let g:syntastic_xslt_checkers         = ['xmllint']
    " npm install js-yaml
    let g:syntastic_yaml_checkers         = ['jsyaml']
    Plugin 'dbakker/vim-lint'
  endif

  " Display an indent line
  Plugin 'Yggdroot/indentLine'
  let g:indentLine_char = "⋮"
  let g:indentLine_noConcealCursor = 1

  " Latest vim-ruby
  Plugin 'vim-ruby/vim-ruby'

  " Rails, bundler, etc.
  Plugin 'tpope/vim-rails'
  Plugin 'tpope/vim-bundler'
  Plugin 'tpope/vim-cucumber'
  Plugin 'tpope/vim-rake'

  " Get me some RVM/Rbenv support
  if exists("$rvm_path")
    Plugin 'tpope/vim-rvm'
  else
    Plugin 'tpope/vim-rbenv'
  endif

  Plugin 't9md/vim-ruby-xmpfilter'

  " Ruby Block Object
  " Adds:
  "   r (Ruby block)
  Plugin 'kana/vim-textobj-user'
  Plugin 'nelstrom/vim-textobj-rubyblock'

  " Ruby refactoring tools. All beging with :R
  Plugin 'ecomba/vim-ruby-refactoring'

  " ds/cs/ys for deleting, changing, your surrounding chars (like ', ", etc.)
  Plugin 'tpope/vim-surround'

  " Deal with git in a sane way
  Plugin 'tpope/vim-fugitive'

  " Support '.' correctly for plugins that support this module.
  Plugin 'tpope/vim-repeat'

  " Allow chording 'jk' as a replacement for ESC
  Plugin 'kana/vim-arpeggio'

  " Multiple Cursors -- "Out of the box, all you need to know is a single key Ctrl-n."
  Plugin 'terryma/vim-multiple-cursors'

  " Allow executing vim with a file:lineno
  Plugin 'bogado/file-line'

  " GraphViz
  Plugin 'wannesm/wmgraphviz.vim'
  let g:WMGraphviz_output='png'

  " SSH authorized_keys
  Plugin 'xevz/vim-sshauthkeys'

  " Allow C-A/C-X to work correctly with dates/times.
  Plugin 'tpope/vim-speeddating'

  " The only theme worth knowing.
  Plugin 'altercation/vim-colors-solarized'

  if v:version >= 702
    Plugin 'bling/vim-airline'
    let g:airline_powerline_fonts = 1
    let g:airline_theme='badwolf'
    set noshowmode
  endif

  " HTML5 + SVG support
  Plugin 'othree/html5.vim'

  " HTML/XML goodness.
  " See :h ragtag
  Plugin 'tpope/vim-ragtag'

  " Show a facsimile of CSS colors as a highlight.
  Plugin 'chrisbra/color_highlight'
  let g:colorizer_auto_filetype='css,scss,sass,html'

  " Puppet configuration syntax
  Plugin 'rodjek/vim-puppet'

  " Chef support
  Plugin 'MarcWeber/vim-addon-mw-utils'
  Plugin 'tomtom/tlib_vim'
  Plugin 'vadv/vim-chef'

  if executable('ag')
    " Ag, the silver searcher
    Plugin 'rking/ag.vim'
  elseif executable('ack-grep')
    " Ack, the better-grepper-upper
    let g:ackprg='ack-grep -H --nocolor --nogroup --column'
    Plugin 'mileszs/ack.vim'
  elseif executable('ack')
    " Ack, the better-grepper-upper
    let g:ackprg='ack -H --nocolor --nogroup --column'
    Plugin 'mileszs/ack.vim'
  endif

  " Coffeescript Support
  Plugin 'kchmck/vim-coffee-script'

  " Scala, breakfast of Joe's everywhere
  Plugin 'derekwyatt/vim-scala'

  " JSON & JS
  Plugin 'elzr/vim-json'
  Plugin 'pangloss/vim-javascript'

  " Haskell support
  Plugin 'Twinside/vim-syntax-haskell-cabal'
  Plugin 'lukerandall/haskellmode-vim'

  " Markdown
  Plugin 'vim-scripts/VOoM'
  Plugin 'tpope/vim-markdown'
  if has('python') && executable('pandoc')
    if v:version >= 704
      " old style
      let g:pantondoc_disabled_modules = [ 'folding' ]
      let g:pantondoc_use_pandoc_equalprg = 0
      let g:pandoc_use_embeds_in_codeblocks_for_langs = ['sh', 'ruby', 'html', 'xml', 'js=javascript', 'json', 'coffee', 'groovy']
      " new style
      let g:pandoc#modules#disabled = [ 'folding' ]
      let g:pandoc#formatting#pandoc_equalprog = 0
      let g:pandoc#formatting#mode = 'ha'
      Plugin 'vim-pandoc/vim-pantondoc'
      Plugin 'vim-pandoc/vim-pandoc-syntax'
      Plugin 'vim-pandoc/vim-pandoc-after'
    else
      " Folding slows things down and annoys me.
      let g:pandoc_no_folding = 1
      Plugin 'vim-pandoc/vim-pandoc'
    endif
  endif

  " Groovy -- Make sure you set the GROOVY_HOME environment variable
  Plugin 'vim-scripts/groovy.vim--Ruley.git'

  " PowerShell -- Changing your Windows command line environment
  Plugin 'PProvost/vim-ps1'

  Plugin 'markcornick/vim-bats'

  Plugin 'mattn/webapi-vim'
  Plugin 'mattn/gist-vim'
  if has('macunix')
    let g:gist_clip_command = 'pbcopy'
  endif

  " Like Command T for TextMate.
  " <leader>t to activate
  " <C-d> to toggle between just matching filename or whole path.
  Plugin 'kien/ctrlp.vim'
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
  " nnoremap <leader>r :CtrlPMRU<cr>

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
  Plugin 'michaeljsmith/vim-indent-object'

  if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
  endif
endfunction

" Only install vundle and bundles if git exists...
if executable('git') && has('autocmd')

  if !isdirectory(expand('~/.vim/bundle/vundle'))
    echomsg '*******************************'
    echomsg 'Bootstrapping vim configuration'
    echomsg '*******************************'
    echomsg ''
    echomsg 'This will take a minute or two...'
    echomsg ''
    silent !mkdir -p ~/.vim/bundle && git clone --quiet https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    let s:bootstrap=1
  endif

  filetype off
  set rtp+=~/.vim/bundle/vundle/
  call vundle#begin()
  Plugin 'gmarik/vundle'
  call LoadPlugins()
  call vundle#end()
  filetype plugin indent on

  if exists('s:bootstrap') && s:bootstrap
    unlet s:bootstrap
    " TODO Run PluginInstall whenever the .vimrc changes (specifically the
    " Pluginsettings).
    PluginInstall
    quit " Close the bundle install window.
  endif
elseif has('autocmd')
  filetype plugin indent on
endif


"
" Brief help
" :PluginList          - list configured bundles
" :PluginInstall       - install bundles
" :PluginUpdate        - update bundles
" :PluginSearch(!) foo - search(or refresh cache first) for foo
" :PluginClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Plugincommand are not allowed..

" Create Parent Directories
"-----------------------------------------------------------------------------
" Create directories if the parent directory for a
" file doesn't exist.
" from: http://stackoverflow.com/a/4294176/108857
function! s:MkNonExDir(file, buf)
  if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
    let dir=fnamemodify(a:file, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction

augroup BWCCreateDir
  autocmd!
  autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" Post Plugin Initialization
"-----------------------------------------------------------------------------
" More complicated stuff that can only work after the bundles are loaded.
" e.g. detecting if something *isn't* loaded.
function! PostPluginSetup()
  " CtrlP auto cache clearing.
  if exists('g:loaded_ctrlp')
    augroup CtrlPExtension
      autocmd!
      autocmd FocusGained  * nested CtrlPClearCache
      autocmd BufWritePost * nested CtrlPClearCache
    augroup END
  endif

  " Command-T auto cache clearing
  if exists('g:command_t_loaded')
    augroup CommandTExtension
      autocmd!
      autocmd FocusGained  * nested CommandTFlush
      autocmd BufWritePost * nested CommandTFlush
    augroup END
  endif

  if exists('g:loaded_arpeggio')
    Arpeggio inoremap jk  <Esc>
  endif

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

  " Make navigating windows easier.
  if exists('g:loaded_tmux_navigator')
    nnoremap <silent> <C-l> :redraw!<CR> :TmuxNavigateRight<CR>
  else
    nnoremap <silent> <C-h> :wincmd h<CR>
    nnoremap <silent> <C-j> :wincmd j<CR>
    nnoremap <silent> <C-k> :wincmd k<CR>
    nnoremap <silent> <C-l> :redraw!<CR> :wincmd l<CR>
    nnoremap <silent> <C-\> :wincmd p<CR>
  endif

  " Ensure we have matchit support
  if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
    runtime! macros/matchit.vim
  endif

  " highlight Pmenu          ctermfg=12 ctermbg=0 guibg=Magenta
  highlight PmenuSel       ctermfg=4 ctermbg=7 guifg=LightBlue
  " highlight PmenuSbar      ctermfg=7 ctermbg=12 guibg=Grey
  " highlight PmenuThumb     ctermfg=12 ctermbg=8 guibg=White

endfunction

if has('autocmd')
  autocmd VimEnter * nested call PostPluginSetup()
endif

" Helper functions
"-----------------------------------------------------------------------------

" A wrapper function to restore the cursor position, window position,
" and last search after running a command.
function! Preserve(command)
  " Save the last search
  let last_search=@/
  " Save the current cursor position
  let save_cursor = getpos('.')
  " Save the window position
  normal H
  let save_window = getpos('.')
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
set synmaxcol=200     " don't syntax highlight past the 120th column

" Syntastical statusline format - Ignored when powerline is enabled.
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'

try
  colorscheme solarized
catch /^Vim\%((\a\+)\)\=:E185/
  " deal wit it
endtry

" In many terminal emulators the mouse works just fine, thus enable it.
if v:version >= 702 && has('mouse')
  set mouse=a
  if &term =~ 'xterm' || &term =~ 'screen'
    set ttymouse=xterm2
  endif
endif

" Switch on highlighting the last used search pattern.
set hlsearch

"set list listchars=tab:»·,trail:·,nbsp:+ " Show the leading whitespaces
set list!
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
if !has('win32') && (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8')
  let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
endif

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
if has('autocmd')
  autocmd BufWritePre * nested let &backupext = substitute(expand('%:p:h'), '/', '%', 'g') . '~'
endif


if has('macunix')
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
set viminfo^=!,h,f0,:100,/100,@100

if exists('+undofile')
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
if has('autocmd')
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
if !exists(':DiffOrig')
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif


function! StripTrailingWhite()
  let l:winview = winsaveview()
  silent! %s/\s\+$//
  call winrestview(l:winview)
endfunction
if has('autocmd')
  autocmd BufWritePre * nested call StripTrailingWhite()
endif

" Needed for some snippets
function! Filename(...)
  let filename = expand('%:t:r')
  if filename == '' | return a:0 == 2 ? a:2 : '' | endif
  return !a:0 || a:1 == '' ? filename : substitute(a:1, '$1', filename, 'g')
endfunction

" Omnicompletion
"-----------------------------------------------------------------------------

set completeopt=menu,longest
set omnifunc=syntaxcomplete#Complete " This is overriden by syntax plugins.


if has('autocmd')
  augroup OmniCompleteModes
    autocmd!
    autocmd FileType python        nested setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType ruby,eruby    nested setlocal omnifunc=rubycomplete#Complete
    autocmd FileType css           nested setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown nested setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript    nested setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType xml           nested setlocal omnifunc=xmlcomplete#CompleteTags
  augroup END
endif


" Key bindings
"-----------------------------------------------------------------------------
" Helpful links:
"  http://stackoverflow.com/questions/2483849/detect-if-a-key-is-bound-to-something-in-vim

" In diff mode, recenter after changing to next/previous diff
map ]c ]czz
map [c [czz

map <silent> <Leader>b :buffers<CR>

" Paste from tmux
"map <silent> <Leader>tp !!tmux show-buffer <Bar> cat<CR>

" With a visual block seleced, fold on space. Refold on space in command mode.
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'1')<CR>
xnoremap <Space> zf

" Prevent highlight being lost on (de)indent.
xnoremap < <gv
xnoremap > >gv

" Indent whole file
nmap <silent> <Leader>g :call Preserve("normal gg=G")<CR>
nmap <silent> <Leader><space> :call Preserve("%s/\\s\\+$//e")<CR>

" Since C-l is now window navigation, use Leader-h
" to redraw (and hide highlighted search).
nnoremap <silent> <Leader>h :nohlsearch<CR><C-L>

" Get Jared and Selker to use hjkl instead of cursor keys...
nmap <Left>  :echo "I don't like that direction..."<cr>
nmap <Right> :echo "Republican, eh?"<cr>
nmap <Up>    :echo "This is why we can't have nice things."<cr>
nmap <Down>  :echo "That's what she said."<cr>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
inoremap <CR> <C-G>u<CR>

" Make Y behave like other capitals.
nnoremap Y y$

" Don't use Ex mode, use Q for formatting
nnoremap Q gq

" For when you forget to sudo.. Really Write the file.
cnoremap w!! w !sudo tee % >/dev/null

" Some helpers to edit mode
" http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>
" Since these use %% they can't be noremap'd.
nmap <leader>ew :e %%
nmap <leader>es :sp %%
nmap <leader>ev :vsp %%
nmap <leader>et :tabe %%

" Seeing Is Believing key bindings for ruby.
let g:xmpfilter_cmd = 'seeing_is_believing'
if has('autocmd')
  augroup SeeingIsBelieving
    autocmd FileType ruby nmap <buffer> <Leader>M <Plug>(seeing_is_believing-mark)
    autocmd FileType ruby xmap <buffer> <Leader>M <Plug>(seeing_is_believing-mark)
    autocmd FileType ruby imap <buffer> <Leader>M <Plug>(seeing_is_believing-mark)

    " auto insert mark at appropriate spot.
    autocmd FileType ruby nmap <buffer> <Leader>R <Plug>(seeing_is_believing-run)
    autocmd FileType ruby xmap <buffer> <Leader>R <Plug>(seeing_is_believing-run)
    autocmd FileType ruby imap <buffer> <Leader>R <Plug>(seeing_is_believing-run)
  augroup END
endif

" Voom settings
if has('autocmd')
  augroup VoomKeys
    autocmd!
    autocmd FileType rst      nested nnoremap <buffer> <silent> <leader>o :VoomToggle rest<cr>
    autocmd FileType pandoc   nested nnoremap <buffer> <silent> <leader>o :VoomToggle pandoc<cr>
    autocmd FileType markdown nested nnoremap <buffer> <silent> <leader>o :VoomToggle markdown<cr>
    autocmd FileType html     nested nnoremap <buffer> <silent> <leader>o :VoomToggle html<cr>
    autocmd FileType python   nested nnoremap <buffer> <silent> <leader>o :VoomToggle python<cr>
  augroup END
endif

" Change Working Directory to that of the current file
cnoremap cwd lcd %%
cnoremap cd. lcd %%

" GUI Settings
"-----------------------------------------------------------------------------
if has('gui_running')
  set guioptions-=T " remove the toolbar
  if has('gui_gtk2')
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

" Python language
"-----------------------------------------------------------------------------
if has('autocmd')
  augroup Pythonic
    autocmd!
    " TODO: Lookup some pydoc/better-python plugins
    " http://vim.wikia.com/wiki/Omnicomplete_-_Remove_Python_Pydoc_Preview_Window
    " maybe for ruby too?
    autocmd FileType python nested setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class,with
    autocmd FileType python nested map <buffer> <S-e> :w<CR>:!/usr/bin/python %
    autocmd FileType python nested setlocal makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
    autocmd FileType python nested setlocal efm=%.%#:\ (\'%m\'\\,\ (\'%f\'\\,\ %l\\,\ %c%.%# "
    " autocmd FileType python nested set textwidth=79 " PEP-8 Friendly
    autocmd FileType python nested setlocal tabstop=4 shiftwidth=4 softtabstop=4
  augroup END
endif

" Ruby syntax
"-----------------------------------------------------------------------------
if has('autocmd')
  augroup Ruby
    autocmd!
    autocmd FileType ruby,eruby nested setlocal cinwords=do
    autocmd FileType ruby,eruby nested let g:rubycomplete_buffer_loading=1
    autocmd FileType ruby,eruby nested let g:rubycomplete_rails = 1
    autocmd FileType ruby,eruby nested let g:rubycomplete_classes_in_global=1

    " Chef
    autocmd BufNewFile,BufRead */{attributes,definitions,libraries,providers,recipes,resources}/*.rb nested setlocal filetype=ruby.chef
    "" Too annoying -- it picks up rails files. eruby works well enough.
    " autocmd BufNewFile,BufRead */templates/*.erb                                                     nested setlocal filetype=eruby.chef
    autocmd BufNewFile,BufRead metadata.rb                                                           nested setlocal filetype=ruby.chef
    autocmd BufNewFile,BufRead */chef-repo/environments/*.rb                                         nested setlocal filetype=ruby.chef
    autocmd BufNewFile,BufRead */chef-repo/roles/*.rb                                                nested setlocal filetype=ruby.chef

    " Other ruby
    autocmd BufNewFile,BufRead *.cap      nested setlocal filetype=ruby
    autocmd BufNewFile,BufRead *.html.erb nested setlocal filetype=eruby.html
    autocmd BufNewFile,BufRead *.js.erb   nested setlocal filetype=eruby.javascript
    autocmd BufNewFile,BufRead *.rb.erb   nested setlocal filetype=eruby.ruby
    autocmd BufNewFile,BufRead *.sh.erb   nested setlocal filetype=eruby.sh
    autocmd BufNewFile,BufRead *.yml.erb   nested setlocal filetype=eruby.yaml
    autocmd BufNewFile,BufRead *.txt.erb   nested setlocal filetype=eruby.text

  augroup END
    if executable('rubocop')
      function! RubyDelint()
        silent !rubocop -a '%'
        edit
        SyntasticCheck
        redraw!
      endfunction
      command! RubyDelint call RubyDelint()
    endif
endif

" Man pages
" You can use this with:
" export MANPAGER="col -b | vim -c 'set ft=man nomod' -"
if has('autocmd')
  augroup ManPages
    autocmd FileType man nested nnoremap <buffer> q :quit<cr>
    autocmd FileType man nested let &listchars=""
    nnoremap <buffer> q :quit
  augroup END
endif

" java/c/cpp/objc syntax
"-----------------------------------------------------------------------------
if has('autocmd')
  augroup CandFriends
    autocmd!
    autocmd FileType java,c,cpp,objc nested setlocal smartindent tabstop=4 shiftwidth=4 softtabstop=4
    autocmd FileType java,c,cpp,objc nested let b:loaded_delimitMate = 1
  augroup END
endif

" JavaScript syntax
"-----------------------------------------------------------------------------
if has('autocmd')
  augroup JavaScript
    autocmd!
    autocmd FileType javascript nested setlocal smartindent expandtab
    if has('conceal')
      autocmd FileType json nested setlocal concealcursor= conceallevel=1
    endif
  augroup END
endif

" markdown specific settings
"-----------------------------------------------------------------------------
if has('autocmd')
  augroup MarkdownPandoc
    autocmd!
    if exists('g:loaded_pandoc')
      autocmd BufNewFile,BufRead *.mdwn,*.mkd,*.md,*.markdown nested setlocal filetype=pandoc
    else
      autocmd BufNewFile,BufRead *.mdwn,*.mkd,*.md,*.markdown nested setlocal filetype=markdown textwidth=79
    endif
    autocmd FileType markdown nested setlocal tabstop=4 shiftwidth=4 softtabstop=4 spell concealcursor=""
    if executable('pandoc')
      command! -buffer MarkdownTidyWrap %!pandoc -t markdown_github-fenced_code_blocks -s
      autocmd BufNewFile,BufRead *.mdwn,*.mkd,*.md,*.markdown nested let &l:equalprg="pandoc -t markdown-fenced_code_blocks --standalone"
      function! SetPandocEqualPrg()
            let &l:equalprg="pandoc -t markdown-fenced_code_blocks -s"
            if &textwidth > 0
              let &l:equalprg.=" --columns " . &textwidth
            endif
      endfunction
      autocmd FileType pandoc nested call SetPandocEqualPrg()
    endif
  augroup END
endif

" Git commit files
"-----------------------------------------------------------------------------
if has('autocmd')
  augroup GitCommits
    autocmd!
    autocmd FileType gitcommit            nested setlocal spell
    autocmd VimEnter .git/PULLREQ_EDITMSG nested setlocal filetype=markdown
  augroup END
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

if has('user_commands')
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

" Local vimrc settings
"-----------------------------------------------------------------------------
" If the file ~/.vimrc.local exists, then it will be loaded as well.

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

set secure
" EOF
