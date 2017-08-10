" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" General
Plug 'Shougo/neocomplete.vim'
if executable('ctags')
    Plug 'majutsushi/tagbar'
endif
nmap <F8> :TagbarToggle<CR>
Plug 'flazz/vim-colorschemes'
Plug 'bling/vim-airline'
Plug 'mattn/emoji-vim'
Plug 'docker/docker'

" Go
Plug 'fatih/vim-go'
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }

" C and CPP
Plug 'vim-scripts/c.vim'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Python
Plug 'klen/python-mode'
Plug 'yssource/python.vim'

" HTML
Plug 'hail2u/vim-css3-syntax'
Plug 'gorodinskiy/vim-coloresque'
Plug 'tpope/vim-haml'
Plug 'mattn/emmet-vim'

" Javascript
Plug 'elzr/vim-json'
Plug 'groenewege/vim-less'
Plug 'pangloss/vim-javascript'
Plug 'briancollins/vim-jst'
Plug 'kchmck/vim-coffee-script'

" Markdown
Plug 'plasticboy/vim-markdown'

call plug#end()

colorscheme ir_black
set guioptions+=T               "turn on the toolbar
set guifont=Source\ Code\ Pro:h12
set t_Co=256                    "SApprox skipped; terminal only has 8 colors, not 88/256 in
set wrap
set clipboard=unnamed
set nocursorline                "slows down redrawing
set nofoldenable
set shell=/bin/sh
set nohlsearch
set nocompatible
set backupcopy=no
set backupdir=~/tmp/

syntax on
filetype plugin indent on

" disable the error bell in terminal and GUI
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

" Viewport Controls - moving between split panes
map <silent>,h <C-w>h
map <silent>,j <C-w>j
map <silent>,k <C-w>k
map <silent>,l <C-w>l

" set leader from \ (default) to ,
let mapleader = ","
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1

let NERDTreeQuitOnOpen = 0

autocmd Filetype go set makeprg=go\ build
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
autocmd FileType c,cpp :set cindent
autocmd Filetype html set tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype javascript set tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype python set tabstop=2 shiftwidth=2 softtabstop=2 tw=120
autocmd Filetype markdown set tabstop=4 shiftwidth=4 softtabstop=4 tw=120
autocmd Filetype make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab tw=80
autocmd	BufRead *.txt set textwidth=79
autocmd BufRead *.txt setlocal spell spelllang=en_us
autocmd BufRead *.txt set tabstop=4 shiftwidth=4 expandtab ruler

" When opening temporary files create the directory if it doesn't exist
function s:MkNonExDir(file, buf)
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
