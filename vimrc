set nocompatible
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

filetype plugin on
filetype indent on

set wildmenu
set ruler
set title
set history=500
set lazyredraw 

set ignorecase
set smartcase
set hlsearch
set incsearch 

set showmatch 
set mat=2

set noerrorbells
set novisualbell
set t_vb=
set tm=500

set nobackup
set nowb
set directory=$HOME/.vim/swapfiles//

set ts=4 sw=4 sts=4 et
set smarttab
set ai si

set mouse=a

" C-X C-F filename completion should ignore '=' character
" eg. when extending export MYFILE=/bin/bash
set isfname-==

" Timeout for leader key
set timeoutlen=2000
set number relativenumber

set tags=tags;/

" Allow :find to locate files in subdirectories
set path+=**

set backspace=indent,eol,start
set nrformats-=octal

set pastetoggle=<F2>

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

" Open splits (including the Scratch) window below/to the right of the current one
set splitbelow splitright

" Use whole "words" when opening URLs.
" This avoids cutting off parameters (after '?') and anchors (after '#'). 
" See http://vi.stackexchange.com/q/2801/1631
let g:netrw_gx="<cWORD>"   
nnoremap <leader>ev :split $MYVIMRC<cr>
set fillchars=vert:\│

au BufNewFile,BufRead Dockerfile* setf dockerfile
au FileType javascript,html,css setl ts=2 sw=2 sts=2 et
au FileType python setl et sw=4 ts=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
au FileType python setl foldmethod=indent foldlevel=99 colorcolumn=80
au FileType python compiler pyunit
au FileType python set makeprg=python3\ %
au BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
" Work around bug breaking jedi-vim on Mac OSX
if has('unix')
  if has('mac')
    py3 sys.executable='/usr/local/bin/python3'
  endif
endif

"
" Colors
"

syntax enable 

set t_Co=256

try
    colorscheme gruvbox
catch
endtry

set background=dark

" Set extra options when running in GUI mode
if has('win32')
    set guifont=Consolas:h14   " Win32.
elseif has('gui_macvim')
    set guifont=Monaco:h16     " OSX.
else
    set guifont=Monospace\ 14  " Linux.
endif

if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set guitablabel=%M\ %t
endif

"
" Normal mode commands
"

let mapleader = " "
let g:mapleader = " "

map <leader>n :setlocal number!<cr>
map <leader>r :setlocal rnu!<cr>
map <leader>l :setlocal list!<cr>

" Follow tags on Hungarian keyboard
nnoremap <C-ú> <C-]>
" Use Ctrl-A to go to the beginning of the command line instead of Ctrl-B
cnoremap <C-a> <C-b>

" Extra mappings for work
if filereadable(expand('$HOME/.vim/vimrc-extra'))
  exe 'source' expand('$HOME/.vim/vimrc-extra')
endif

" Devdocs.io
" Example: :DD 
" Use :DD without argument to look up the word under the cursor, scoped with the current filetype:
" Use :DD keyword to look up the given keyword, scoped with the current filetype:
"  :DD Map
" Use :DD scope keyword to do the scoping yourself:
"  :DD scss @mixin
" Use the :DD command for keyword look up with the built-in K:
"  setlocal keywordprg=:DD

if has('win64') || has('win32') || has('win16')
    let cmd = "start"
else
    let cmd = "xdg-open"
endif

let stub = cmd . " 'http://devdocs.io/?q="

command! -nargs=* DD silent! call system(len(split(<q-args>, ' ')) == 0 ?
            \ stub . &ft . ' ' . expand('<cword>') . "'" : len(split(<q-args>, ' ')) == 1 ?
\ stub . &ft . ' ' . <q-args> . "'" : stub . <q-args> . "'")

" K
runtime ftplugin/man.vim
set keywordprg=:Man
autocmd FileType vim setlocal keywordprg=:help
autocmd FileType python setlocal keywordprg=pydoc

let g:lightline = {
  \   'active': {
  \     'left':[ [ 'mode', 'paste' ],
  \              [ 'gitgutter', 'fugitive', 'readonly', 'filename', 'modified' ]
  \     ]
  \   },
  \   'component_function': {
  \     'gitgutter': 'MyGitGutter',
  \     'fugitive': 'fugitive#head'
  \   },
  \   'colorscheme': 'gruvbox'
  \ }
set noshowmode
set laststatus=2

function! MyGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 90
    return ''
  endif
  let symbols = [
        \ g:gitgutter_sign_added . ' ',
        \ g:gitgutter_sign_modified . ' ',
        \ g:gitgutter_sign_removed . ' '
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction

" vim-gitgutter
set updatetime=200

" vimwiki
let g:vimwiki_list = [{'syntax': 'markdown', 'ext': '.md', 'path_html': '~/tmp/vimwiki_html/', 'path': '~/vimwiki', 'custom_wiki2html': '~/vimwiki/wiki2html.sh', "css_name": 'wiki2html.css'}]
let g:markdown_fenced_languages = ['sh', 'html', 'xml', 'sql']
nmap <Leader>x <Plug>VimwikiToggleListItem

" ale
let g:ale_linters = {'python': ['flake8', 'pylint']}
let g:ale_fixers = {'python': ['remove_trailing_lines', 'trim_whitespace', 'autopep8']}
let g:ale_python_flake8_options = '--ignore=E501'  " ignore 'line too long' errors
