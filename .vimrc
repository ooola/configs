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
Plug 'mdempsky/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }

" C and CPP
Plug 'vim-scripts/c.vim'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Python
Plug 'klen/python-mode'
Plug 'yssource/python.vim'
Plug 'nvie/vim-flake8'

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

" Yaml
Plug 'chase/vim-ansible-yaml'

" fzf
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Git plugin
Plug 'tpope/vim-fugitive'
call plug#end()

colorscheme ir_black
set guioptions+=T               "turn on the toolbar
set guifont=Source\ Code\ Pro:h12
set t_Co=256                    "SApprox skipped; terminal only has 8 colors, not 88/256 in
set wrap
if $TMUX == '' " setting clipboard in tmux gives Nothing in register * when pasting
    set clipboard+=unnamed
endif
set clipboard=unnamed
set nocursorline                "slows down redrawing
set nofoldenable
set shell=/bin/sh
set nohlsearch
set nocompatible
set backupcopy=no
set backupdir=~/tmp
set directory=~/tmp,/tmp,/var/tmp
set nofixendofline  "unfortunately some existing code I have to work with doesn't wan endofline set

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

nmap <F6> :NERDTreeToggle<CR>

" set leader from \ (default) to ,
let mapleader = ","
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1

let NERDTreeQuitOnOpen = 0

" Buffers
nmap ; :Buffers<CR>
nmap <Leader>f :Files<CR>
nmap <Leader>t :Tags<CR>

function StyleCheck()
    if &filetype == 'python' && executable('flake8')
        call Flake8()
    endif
endfunction
"autocmd BufWritePost *.py call StyleCheck() " call flake8 after write for python files
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
autocmd FileType c,cpp setlocal cindent tabstop=4 shiftwidth=4 softtabstop=4 expandtab tw=80
autocmd Filetype html setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2
autocmd Filetype javascript setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2 conceallevel=0
autocmd Filetype json setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2
autocmd Filetype python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab tw=120
autocmd BufRead,BufNewFile,BufEnter ~/workspace/optimizely/* setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab tw=120
autocmd BufRead,BufNewFile,BufEnter ~/workspace/hermes-airflow/* setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab tw=120
autocmd Filetype yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab tw=80
autocmd Filetype markdown setlocal tabstop=4 shiftwidth=4 softtabstop=4 spell expandtab tw=120
autocmd Filetype make setlocal tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab tw=80
autocmd Filetype text setlocal tabstop=4 shiftwidth=4 expandtab ruler spell spelllang=en_us tw=80
autocmd Filetype zsh setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2
autocmd Filetype sh setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4

" When opening temporary files create the directory if it doesn't exist
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

" Tired of seeing "Regenerate rope cache" too slow to be useful
let g:pymode_rope = 0
let g:pymode_rope_lookup_project = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_autoimport = 0
