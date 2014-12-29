" ================
" @author: stev leibelt <artodeto@bazzline.net>
" @since: 2014-12-29
" @see:
"   https://github.com/gmarik/Vundle.vim
"   https://github.com/mutewinter/dot_vim/blob/master/vundle.vim
"   http://erikzaadi.com/2012/03/19/auto-installing-vundle-from-your-vimrc/
"   https://github.com/spf13/spf13-vim/blob/3.0/.vimrc.bundles
"   http://spf13.com/post/the-15-best-vim-plugins
" ================

" configure vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" start of plugin section
" ==== general
Plugin 'gmarik/Vundle.vim'  " vundle manage vundle
Bundle 'Syntastic'
Bundle 'tpope/vim-markdown'
" ==== javascript
Bundle 'pangloss/vim-javascript'
Bundle 'elzr/vim-json'
" ==== php
Bundle 'spf13/PIV'
Bundle 'arnaud-lb/vim-php-namespace'
" end of plugin section

call vundle#end()
