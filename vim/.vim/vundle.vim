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

call vundle#begin()

" start of plugin section
" ==== general
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'szw/vim-tags'
Plugin 'scrooloose/nerdtree'
" Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-markdown'
" ==== javascript
Bundle 'pangloss/vim-javascript'
Bundle 'elzr/vim-json'
" ==== php
Bundle 'spf13/PIV'
Bundle 'arnaud-lb/vim-php-namespace'
" end of plugin section

call vundle#end()
