colorscheme desert
set tabstop=4 shiftwidth=4 expandtab ruler
set nohlsearch
set fileformat=dos
set shell=c:\windows\system32\cmd.exe
set shellcmdflag=/C

cab p4edit !p4vim j: %:p:h %

filetype plugin on

syntax on
" should use the following abrreviations
"ab ,tm <xsl:template match=""></xsl:template>
"ab ,at <xsl:apply-templates/> 


" Use vim? Put this in your .vimrc:
" 
" map <F5> :s.^//.. <CR> :noh <CR>
" map <F6> :s.^.//. <CR> :noh <CR>
" 
" 
" 
" Now you use a visual line select (shift-V) to select what you want to comment, smack F5 and it's done. F6 uncomments.
" 
" 
" As a bonus, use these to change indents. Change "indent" to your preference for indenting. I use 4 spaces. Use \t if you want a tab. Combined with shift-V, you can move whole blocks left and right easily.
" 
" map <F7> :s/^indent// <CR> :noh <CR> gv
" map <F8> :s/^/indent/ <CR> :noh <CR> gv
" 

" the location of the tags file is the same in both MPS and client trees
set tags=\src\tags,\src\gfx\tags
set backupcopy=no
set backupdir=~/tmp/
