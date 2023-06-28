" set compatibility mode off
set nocompatible

" add mapping of CTRL+h and CTRL+l to move between windows
" @see: https://stackoverflow.com/a/16700959
" @see: https://www.unix.com/unix-for-advanced-and-expert-users/165129-vimdiff-jump-other-file-switch-windows.html
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l

" configure vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

" source vundle
source ~/.vim/vundle.vim

" automatically detect file types
filetype plugin indent on

" begin of indentation settings
" set smartindent
" convert all tabs to spaces
set expandtab
" show existing tabs with 2 spaces width
set tabstop=2
" when indenting with `>`, use 2 spaces width
set shiftwidth=2
" identify open and clse brace positions
set showmatch
" set limit for line width - working for vim >= 7.3
" this is evil! if you select content with the mouse, you will select the
"   whitespaces also
" set colorcolumn=120
" end of indentation settings
" begin of disable backups and .swp files
set nobackup
set nowritebackup
set noswapfile
" end of disable backups and .swp files
set number
" highlight th searched term
set hlsearch
" perform search while you are typing
" set incsearch
" begin of beeing case insensitive when searching
set ignorecase
set smartcase
" end of beeing case insensitive when searching
" sets the cursor position to the 4th row when scrolling up and down
set scrolloff=4
" display a permanent status bar at the bottom
set laststatus=2
set ruler
" switch to the directory where the file is opened
set autochdir
" begin of wild menu configuration (used for tab command autocompletion)
set wildmenu
set wildmode=list:longest,full
" end of wild menu configuration (used for tab command autocompletion)
" spell checking for us english language
set spelllang=en_us
" useuznix as standart file type
set ffs=unix,dos,mac
map <F2> :retab <CR> :wq! <CR>
" enables syntax highlighting
syntax enable
set showcmd
set showmode
set t_Co=256
colorscheme zenburn

if &diff
    colorscheme zenburn
endif

autocmd FileType php setlocal makeprg=zca\ %<.php
autocmd FileType php setlocal errorformat=%f(line\ %l):\ %m

" #links
"
" * https://github.com/pbrisbin/vim-config
" * https://github.com/bstaletic/dotfiles/blob/master/.vimrc
" * https://github.com/zendeavor/dotvim/blob/sandbag/vimrc
" * https://opensource.com/article/18/9/vi-editor-productivity-powerhouse

" #plugins
" http://ctags.sourceforge.net/
" http://vim.wikia.com/wiki/A_better_Vimdiff_Git_mergetool
" http://www.vim.org/scripts/script.php?script_id=1658
