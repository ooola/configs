" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" General
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  let g:deoplete#enable_at_startup = 1
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
if executable('ctags')
    Plug 'majutsushi/tagbar'
    let g:tagbar_ctags_bin = 'ctags'
endif
nmap <F8> :TagbarToggle<CR>
Plug 'flazz/vim-colorschemes'
Plug 'bling/vim-airline'
Plug 'mattn/emoji-vim'
Plug 'docker/docker'
Plug 'tpope/vim-surround'
Plug 'chrisbra/vim-commentary' " select code an type gc to comment it out 

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
" This doesn't look like it is maintained anymore
" Plug 'plasticboy/vim-markdown'
Plug 'junegunn/goyo.vim'

" Yaml
Plug 'chase/vim-ansible-yaml'

" Terraform
Plug 'hashivim/vim-terraform'

" fzf
set rtp+=/opt/homebrew/opt/fzf
Plug 'junegunn/fzf.vim'

" Git plugin
Plug 'tpope/vim-fugitive'

" neovim 0.5 plugins
Plug 'neovim/nvim-lspconfig'
call plug#end()

colorscheme ir_black
"set guioptions+=T               "turn on the toolbar
set guifont=Source\ Code\ Pro:h12
set t_Co=256                    "SApprox skipped; terminal only has 8 colors, not 88/256 in

set wrap
if $TMUX == '' " setting clipboard in tmux gives Nothing in register * when pasting
  set clipboard+=unnamed
endif
set clipboard=unnamed
set ignorecase
set nocursorline                "slows down redrawing
set nofoldenable
set shell=/bin/sh
set hlsearch 			" turn this off by doing :set nohlsearch
" figureout how to automatically set this
"set highlight term=NONE ctermfg=grey ctermbg=blue
set nocompatible
set backupcopy=no
set backupdir=~/tmp
set directory=~/tmp,/tmp,/var/tmp
set mouse=a
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

" insert escape remapping
imap jk <Esc>

nmap <F6> :NERDTreeToggle<CR>
" execute the current buffer (script)
nmap <F9> :!%:p

" change grep to use ripgrep, too cumbersome to use the silver searcher
set grepprg=rg\ --vimgrep\ --smart-case\ --follow

" set leader from \ (default) to ,
let mapleader = ","
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1

let g:ruby_host_prog="/opt/homebrew/opt/ruby/bin/ruby"

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

function! s:DiffWithSaved()
    let filetype=&ft
    diffthis
    vnew | r # | normal! 1Gdd
    diffthis
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" enable markdown syntax highlighting
let g:markdown_fenced_languages = ['html', 'python', 'make', 'vim', 'go', 'c', 'javascript', 'java']

"autocmd BufWritePost *.py call StyleCheck() " call flake8 after write for python files
autocmd Filetype go map <F7> :GoBuild<CR>
autocmd Filetype go map <F9> :GoRun<CR>
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

autocmd FileType c,cpp,cl setlocal cindent tabstop=4 shiftwidth=4 softtabstop=4 expandtab tw=80
autocmd BufRead,BufNewFile,BufEnter ~/workspace/c-sdk/* setlocal tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab tw=80
autocmd Filetype html setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2
autocmd BufNewFile *.html 0r ~/.vim/template.html
autocmd Filetype javascript setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=2 conceallevel=0
autocmd Filetype typescript setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=2 conceallevel=0
autocmd Filetype json setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2
autocmd Filetype python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab tw=120
autocmd Filetype java setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab tw=120
autocmd Filetype jsp setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab tw=120
autocmd BufRead,BufNewFile,BufEnter ~/workspace/optimizely/* setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab tw=120
autocmd BufRead,BufNewFile,BufEnter ~/workspace/hermes-airflow/* setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab tw=120
autocmd Filetype yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab tw=80
autocmd Filetype markdown setlocal tabstop=4 shiftwidth=4 softtabstop=4 spell expandtab tw=120
autocmd Filetype make setlocal tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab tw=80
autocmd Filetype text setlocal tabstop=4 shiftwidth=4 expandtab ruler spell spelllang=en_us tw=80
autocmd Filetype tf setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2
autocmd Filetype zsh setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2
"autocmd Filetype sh setlocal tabstop=4 shiftwidth=4 expandtab softtabstop=4
autocmd Filetype sh setlocal tabstop=4 shiftwidth=4 softtabstop=2 noexpandtab tw=120
autocmd Filetype groovy setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
autocmd BufRead,BufNewFile,BufEnter *.jenkinsfile setf groovy

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

if has('nvim')
    set clipboard+=unnamed
    " vim now seems to find this from the env on os x
    "let g:python2_host_prog = '/usr/bin/python'
    "let g:python3_host_prog = '/opt/homebrew/bin/python3'
    "let g:python3_host_prog = '~/.pyenv/shims/python3'
    let g:loaded_perl_provider = 0
    if $TMUX == ''
        let g:clipboard = {
          \   'name': 'myClipboard',
          \   'copy': {
          \      '+': 'tmux load-buffer -',
          \      '*': 'tmux load-buffer -',
          \    },
          \   'paste': {
          \      '+': 'tmux save-buffer -',
          \      '*': 'tmux save-buffer -',
          \   },
          \   'cache_enabled': 1,
          \ }
    endif
endif
