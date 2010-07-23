colorscheme desert
set tabstop=4 shiftwidth=4 expandtab ruler
set nohlsearch
set fileformat=dos
set shell=c:\windows\system32\cmd.exe
set shellcmdflag=/C
set nocompatible
set backupcopy=no
set backupdir=~/tmp/

cab p4edit !p4vim j: %:p:h %

" should use the following abrreviations
"ab ,tm <xsl:template match=""></xsl:template>
"ab ,at <xsl:apply-templates/> 


" Use vim? Put this in your .vimrc:
" 
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

"the commands below are not needed since there is a python vim filetype that
"set's everything via the 'filetype plugin indent on' command
"autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
"autocmd BufRead *.py inoremap # X^H#
"autocmd BufRead *.py set tabstop=4
"autocmd BufRead *.py set shiftwidth=4
"autocmd BufRead *.py set smarttab
"autocmd BufRead *.py set expandtab
"autocmd BufRead *.py set softtabstop=4
"autocmd BufRead *.py set autoindent


