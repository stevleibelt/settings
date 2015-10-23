" configure vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

" source vundle
source ~/.vim/vundle.vim

" automatically detect file types
filetype plugin indent on

" begin of indentation settings
set smartindent
" treat all tabs as spaces
set expandtab
" set tab witdh
set tabstop=4
" set the tab width for auto indentation
set shiftwidth=4
" set limit for line width - working for vim >= 7.3
set colorcolumn=120
" end of indentation settings
" begin of disable backups and .swp files
set nobackup
set nowritebackup
set noswapfile
" end of disable backups and .swp files
set number
set hlsearch
" begin of beeing case insensitive when searching
set ignorecase
set smartcase
" end of beeing case insensitive when searching
set ruler
" begin of wild menu configuration (used for tab command autocompletion)
set wildmenu
set wildmode=list:longest,full
" end of wild menu configuration (used for tab command autocompletion)
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

" #plugins
" http://ctags.sourceforge.net/
" http://vim.wikia.com/wiki/A_better_Vimdiff_Git_mergetool
" http://www.vim.org/scripts/script.php?script_id=1658
