" NORMAL SETUP ------------------------------------------------------------ {{{

" Basic Setup
set nocompatible
set nobackup
set hlsearch
set nowrap
filetype on
filetype indent on

" Scheme
syntax on
colorscheme evening
set termguicolors

" Numbers
set number
set relativenumber

" Cursor
set cursorline
set cursorcolumn
let &t_SI = "\<Esc>[5 q"
let &t_SR = "\<Esc>[3 q"
let &t_EI = "\<Esc>[1 q"

" Mouse Settings
set mouse=a
set mousemodel=popup

" Clipboards Settings
set clipboard^=unnamed,unnamedplus
set paste
set go+=a

" Keys
set backspace+=indent,eol,start
set whichwrap+=<,>,h,l,[,]

" Text
set softtabstop=4
set shiftwidth=4
set tabstop=4
set autoindent
set encoding=UTF-8

" }}}