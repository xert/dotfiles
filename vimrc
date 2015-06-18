" xert vimrc 2.0
" 2015

" VIM Plugins
" Install vim-plug (https://github.com/junegunn/vim-plug)
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" Usage:
" :PlugInstall - install all defined plugins
" :PlugClean   - delete all undefined plugins
" :PlugUpdate  - update all plugins
" :PlugUpgrade - upgrade vim-plug
" {{{ 
call plug#begin('~/.vim/plugged')

" A collection of language packs for Vim
Plug 'sheerun/vim-polyglot'

" A code-completion engine for Vim
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh'}

" A Vim plugin which shows a git diff in the gutter
Plug 'airblade/vim-gitgutter'

" Asynchronous build and test dispatcher 
Plug 'tpope/vim-dispatch'

" Enable repeating supported plugin maps with '.'
Plug 'tpope/vim-repeat'

" Delete buffers and close files in Vim without closing your windows or messing up your layout. 
Plug 'moll/vim-bbye'

" Vim plugin, provides insert mode auto-completion for quotes, parens, brackets, etc.
Plug 'Raimondi/delimitMate'

" An extensible & universal comment vim-plugin that also handles embedded filetypes
Plug 'tomtom/tcomment_vim'

" A vim plugin that simplifies the transition between multiline and single-line code
Plug 'AndrewRadev/splitjoin.vim'

" Go development plugin for Vim
Plug 'fatih/vim-go', {'for': 'go'}

" Vim plugin that displays tags in a window, ordered by scope
Plug 'majutsushi/tagbar', {'for': 'go'}

" Syntax Highlights the .slide and .article files for a Go Present Tool files
Plug 'corylanou/vim-present', {'for' : 'present'}


Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" A light and configurable statusline/tabline for Vim
Plug 'itchyny/lightline.vim'

" Shows the git branch name in lightline
Plug 'itchyny/vim-gitbranch'

" Patched fonts for Powerline users
Plug 'powerline/fonts', {'do': './install.sh'}

" color schemes
Plug 'morhetz/gruvbox'
Plug 'shinchu/lightline-gruvbox.vim'

" TODO: (prozkoumat)
"Plug 'szw/vim-ctrlspace'
"Plug 'rking/ag.vim'
"Plug 'SirVer/ultisnips'

call plug#end()
" }}}


let g:changes_vcs_check=1
let g:changes_sign_text_utf8=1
let g:changes_fixed_sign_column=1
let g:changes_sign_hi_style=2

" Basic:
" General settings
" {{{
set nocompatible              " be iMproved, required
filetype off                  " required

filetype plugin indent on    " required

"
" Settings
"
set noerrorbells                " No beeps
set number                      " Show line numbers
set backspace=indent,eol,start  " Makes backspace key more powerful.
set showcmd                     " Show me what I'm typing
set showmode                    " Show current mode.

set noswapfile                  " Don't use swapfile
set nobackup            	    " Don't create annoying backup files
set splitright                  " Split vertical windows right to the current windows
set splitbelow                  " Split horizontal windows below to the current windows
set encoding=utf-8              " Set default encoding to UTF-8
set autowrite                   " Automatically save before :next, :make etc.
set autoread                    " Automatically reread changed files without asking me anything
set laststatus=2
set hidden

set fileformats=unix,dos,mac    " Prefer Unix over Windows over OS 9 formats

"http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
set clipboard^=unnamed
set clipboard^=unnamedplus

set noshowmatch                 " Do not show matching brackets by flickering
set nocursorcolumn
set noshowmode                  " We show the mode with airlien or lightline
set incsearch                   " Shows the match while typing
set hlsearch                    " Highlight found searches
set ignorecase                  " Search case insensitive...
set smartcase                   " ... but not when search pattern contains upper case characters
set ttyfast
set ttymouse=xterm2
set ttyscroll=3
set lazyredraw          	    " Wait to redraw "

" speed up syntax highlighting
set nocursorcolumn
set nocursorline

syntax sync minlines=256
set synmaxcol=300
set re=1
" }}}

let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'filename' ] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'MyBranch',
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode',
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

function! MyBranch()
  return gitbranch#name()
endfunction

function! MyModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler' && &readonly ? '' : ''
endfunction

function! MyFilename()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let _ = fugitive#head()
      return strlen(_) ? ''._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

" -----

" open help vertically
command! -nargs=* -complete=help Help vertical belowright help <args>
autocmd FileType help wincmd L

syntax enable
set background=dark
colorscheme gruvbox

if has("gui_running")
  " No toolbars, menu or scrollbars in the GUI
  set guifont=Meslo\ LG\ S\ for\ Powerline\ 10
  set clipboard+=unnamed
  set vb t_vb=
  set guioptions-=m  "no menu
  set guioptions-=T  "no toolbar
  set guioptions-=l
  set guioptions-=L
  set guioptions-=r  "no scrollbar
  set guioptions-=R

  highlight SignColumn guibg=#272822
else
  set t_Co=256
  " Change cursor in insert mode (for Konsole terminal)
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Comment lines with alt+/
nmap ,, :TComment<cr>
vmap ,, :TCommentBlock<cr>gv

" Stop completion with enter, in addition to default ctrl+y
imap <expr> <CR> pumvisible() ? "\<c-y>" : "<Plug>delimitMateCR"

" This comes first, because we have mappings that depend on leader
" With a map leader it's possible to do extra key combinations
" i.e: <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" This trigger takes advantage of the fact that the quickfix window can be
" easily distinguished by its file-type, qf. The wincmd J command is
" equivalent to the Ctrl+W, Shift+J shortcut telling Vim to move a window to
" the very bottom (see :help :wincmd and :help ^WJ).
autocmd FileType qf wincmd J

"Dont show me any output when I build something
"Because I am using quickfix for errors
nmap <leader>m :Make<CR><enter>

" Some useful quickfix shortcuts
":cc      see the current error
":cn      next error
":cp      previous error
":clist   list all errors
map <C-n> :cn<CR>
map <C-m> :cp<CR>

" simulate tab shortcuts
map gb :bnext<cr>
map gB :bprevious<cr>

" Save on F2
nmap <F2> :w!<CR>
vmap <F2> <Esc><F2>gv
imap <F2> <c-o><F2>

" Close quickfix easily
nnoremap <leader>a :cclose<CR>

" Remove search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Better split switching
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Fast saving
nmap <leader>w :w!<cr>

" Center the screen
nnoremap <space> zz

" Move up and down on splitted lines (on small width screens)
map <Up> gk
map <Down> gj
map k gk
map j gj

nnoremap <F6> :setlocal spell! spell?<CR>

" Select search pattern howewever do not jump to the next one
nnoremap <leader>c :TComment<cr>

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

autocmd BufEnter * silent! lcd %:p:h

" Act like D and C
nnoremap Y y$

" Do not show stupid q: window
map q: :q

"Reindent whole file
map <F7> mzgg=G`z<CR>


" ========== Steve Losh hacks ==========="

" Don't move on *
" I'd use a function for this but Vim clobbers the last search when you're in
" a function so fuck it, practicality beats purity.
nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>

" iTerm2 is currently slow as balls at rendering the nice unicode lines, so for
" now I'll just use ASCII pipes.  They're ugly but at least I won't want to kill
" myself when trying to move around a file.
"set fillchars=diff:⣿,vert:│
"set fillchars=diff:⣿,vert:\|

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=10

" Better Completion
set complete=.,w,b,u,t
set completeopt=longest,menuone

" Diffoff
nnoremap <leader>D :diffoff!<cr>

" Resize splits when the window is resized
au VimResized * :wincmd =

" ----------------------------------------- "
" File Type settings 			    		"
" ----------------------------------------- "

" map a specific key or shortcut to open NERDTree
map <F1> :NERDTreeFocus<CR>
map <F3> :NERDTreeClose<CR>
" open a NERDTree automatically when vim starts up
autocmd vimenter * NERDTree
" Go to previous (last accessed) window.
autocmd vimEnter * wincmd p
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

au BufNewFile,BufRead *.vim setlocal noet ts=4 sw=4 sts=4
au BufNewFile,BufRead *.txt setlocal noet ts=4 sw=4
au BufNewFile,BufRead *.md setlocal noet ts=4 sw=4

augroup filetypedetect
  au BufNewFile,BufRead .tmux.conf*,tmux.conf* setf tmux
  au BufNewFile,BufRead .nginx.conf*,nginx.conf* setf nginx
augroup END

function! s:filtered_lightline_call(funcname)
  if bufname('%') == '__CS__'
    return
  endif
  execute 'call lightline#' . a:funcname . '()'
endfunction

augroup LightLine
  autocmd!
  autocmd WinEnter,BufWinEnter,FileType,ColorScheme * call s:filtered_lightline_call('update')
  autocmd ColorScheme,SessionLoadPost * call s:filtered_lightline_call('highlight')
  autocmd CursorMoved,BufUnload * call s:filtered_lightline_call('update_once')
augroup END

au FileType nginx setlocal noet ts=4 sw=4 sts=4

" Go settings
au BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4

" coffeescript settings
autocmd BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab

" scala settings
autocmd BufNewFile,BufReadPost *.scala setl shiftwidth=2 expandtab

" lua settings
autocmd BufNewFile,BufRead *.lua setlocal noet ts=4 sw=4 sts=4


" Wildmenu completion {{{
set wildmenu
" set wildmode=list:longest
set wildmode=list:full

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=go/pkg                       " Go static files
set wildignore+=go/bin                       " Go bin files
set wildignore+=go/bin-vagrant               " Go bin-vagrant files
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files

" ----------------------------------------- "
" Plugin configs 			    			"
" ----------------------------------------- "

" ==================== YouCompleteMe ====================
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_min_num_of_chars_for_completion = 2

" ==================== DelimitMate ====================
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let delimitMate_smart_quotes = 1
let delimitMate_expand_inside_quotes = 0

let delimitMate_smart_matchpairs = '^\%(\w\|\$\)'

" ==================== Vim-go ====================
let g:go_fmt_fail_silently = 0
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1

"let g:go_highlight_space_tab_error = 0
"let g:go_highlight_array_whitespace_error = 0
"let g:go_highlight_trailing_whitespace_error = 0
"let g:go_highlight_extra_types = 0
"let g:go_highlight_operators = 0
"
let g:go_auto_type_info = 1

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

au FileType go nmap <Leader>s <Plug>(go-def-split)
au FileType go nmap <Leader>v <Plug>(go-def-vertical)
au FileType go nmap <Leader>in <Plug>(go-info)
au FileType go nmap <Leader>ii <Plug>(go-implements)

au FileType go nmap <leader>r  <Plug>(go-run)
au FileType go nmap <leader>b  <Plug>(go-build)
au FileType go nmap <leader>g  <Plug>(go-gbbuild)
au FileType go nmap <leader>t  <Plug>(go-test-compile)
au FileType go nmap <Leader>d <Plug>(go-doc)
au FileType go nmap <Leader>f :GoImports<CR>

" Tagbar plugin {{{
nmap <silent><F8> :TagbarToggle<CR>
let g:tagbar_compact = 1
let g:tagbar_singleclick = 1

let g:tagbar_status_func = 'TagbarStatusFunc'
function! TagbarStatusFunc(current, sort, fname, ...) abort
  let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

let g:tagbar_type_go = {
      \ 'ctagstype' : 'go',
      \ 'kinds'     : [
      \ 'p:package',
      \ 'i:imports:1',
      \ 'c:constants',
      \ 'v:variables',
      \ 't:types',
      \ 'n:interfaces',
      \ 'w:fields',
      \ 'e:embedded',
      \ 'm:methods',
      \ 'r:constructor',
      \ 'f:functions'
      \ ],
      \ 'sro' : '.',
      \ 'kind2scope' : {
      \ 't' : 'ctype',
      \ 'n' : 'ntype'
      \ },
      \ 'scope2kind' : {
      \ 'ctype' : 't',
      \ 'ntype' : 'n'
      \ },
      \ 'ctagsbin'  : 'gotags',
      \ 'ctagsargs' : '-sort -silent'
      \ }
" }}}

" GitGutter plugin {{{
let g:gitgutter_sign_column_always = 1
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '--'
let g:gitgutter_sign_modified_removed = '~-'
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
" }}}

" Move lines and selections CTRL+Up/Down
nmap <C-Down> :m .+1<CR>==
nmap <C-Up> :m .-2<CR>==
imap <C-Down> <Esc>:m .+1<CR>==gi
imap <C-Up> <Esc>:m .-2<CR>==gi
vmap <C-Down> :m '>+1<CR>gv=gv
vmap <C-Up> :m '<-2<CR>gv=gv

" Indent lines with CTRL+Left/Right
nmap <C-Left> <<
nmap <C-Right> >>
imap <C-Left> <Esc><<
imap <C-Right> <Esc><<
vmap <C-Left> <gv
vmap <C-Right> >gv

" Close buffer via vim-bbye
:nnoremap <Leader>q :Bdelete<CR>

" Keep this modeline:
" vim:ts=2:sw=2:et:fdm=marker
