colorscheme desert
set tabstop=4 shiftwidth=4 expandtab ruler
set nohlsearch
set nocompatible
set backupcopy=no
set backupdir=~/tmp/

if has("win32") || has("win64")
    set fileformat=dos
    set shell=powershell.exe
    set shellcmdflag=/C
endif

if has('gui_running')
    set guifont=Monospace\ 12
endif

" map <F5> :s.^//.. <CR> :noh <CR>
" map <F6> :s.^.//. <CR> :noh <CR>
" Now you use a visual line select (shift-V) to select what you want to comment,
" smack F5 and it's done. F6 uncomments.
" 
" As a bonus, use these to change indents. Change "indent" to your preference for indenting.
" I use 4 spaces. Use \t if you want a tab. Combined with shift-V, you can move whole blocks
" left and right easily.
" map <F7> :s/^indent// <CR> :noh <CR> gv
" map <F8> :s/^/indent/ <CR> :noh <CR> gv
" 
" the location of the tags file is the same in both MPS and client trees
" set tags=\src\tags,\src\gfx\tags

syntax on
filetype on
filetype plugin on
filetype indent on      
filetype plugin indent on  " This actually turns on ft detection, plugin and indent
"                          So previous commands were redundant. See :filetype
autocmd FileType c,cpp :set cindent 
autocmd BufRead *.py highlight BadWhitespace ctermbg=red guibg=red
autocmd BufRead *.py match BadWhitespace /^\t\+/
autocmd BufRead *.py match BadWhitespace /\s\+$/

"set list listchars=tab:?·,trail:·,nbsp:·
set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\
\ [%l/%L\ (%p%%)

au FileType py set autoindent " not sure if this is needed
au FileType py set smartindent " not sure if needed
au FileType py set textwidth=79 " PEP-8 Friendly

" See http://justinlilly.com/vim/vim_and_python.html

au BufRead *.txt set textwidth=79

" NERD_tree config
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\.vim$', '\~$', '\.pyc$', '\.swp$']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\~$']
let NERDTreeShowBookmarks=1
map <F3> :NERDTreeToggle<CR>

" Syntax for multiple tag files are
" set tags=/my/dir1/tags, /my/dir2/tags
set tags=tags;$HOME/.vim/tags/

" TagList Plugin Configuration
let Tlist_Ctags_Cmd='/usr/local/bin/ctags'
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1
let Tlist_Use_Right_Window = 1
let Tlist_File_Fold_Auto_Close = 1
map <F7> :TlistToggle<CR>

" Viewport Controls
" ie moving between split panes
map <silent>,h <C-w>h
map <silent>,j <C-w>j
map <silent>,k <C-w>k
map <silent>,l <C-w>l
