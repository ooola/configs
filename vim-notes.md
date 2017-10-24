Vim Notes
=========

## Settings don't take affect

Sometimes when change settings, e.g. indentation they don't take affect because
old settings are loaded from

.vimbackup
.vimswap
.vimundo
.vimviews

To fix do.

    rm -rf ~/.vimbackup/* && rm -rf ~/.vimswap/* && rm -rf ~/.vimundo/* && rm -rf ~/.vimviews/*

## Golang
fatih/vim-go says to run :GoInstallBinaries after it is enable (see above).

## Neocomplete
Require vim to be built with lua support.

## TagBar
Pressin "F8" will toggle the TagBar

## NerdTree Cheetsheet

Nerd Tree plugin can be activated by the :NERDTree vim command. To close the plugin execute the :NERDTreeClose command.

Use the natural vim navigation keys hjkl to navigate the files.
Press o to open the file in a new buffer or open/close directory.
Press t to open the file in a new tab.
Press i to open the file in a new horizontal split.
Press s to open the file in a new vertical split.
Press p to go to parent directory.
Press r to refresh the current directory.
Press m to launch NERDTree menu inside vim.

## Spelling

zg - to add highlighted word
CTRL-P to autocomplete

## Navigation

CTRL-] - jump to function definition
CTRL-o - jump to older (previous) place

In nerdtree

,m - bring up menu
mr - open reveal in finder

CTRLP - ?
Fugitive - git blame via :Gblame then do 'o' to view that commit, :Gdiff

## Ack.vim

This adds :Ag to search with ag.
