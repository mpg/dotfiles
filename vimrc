set fileencodings=utf8,latin1

syntax on
colorscheme delek

" use filetypes
filetype on
filetype plugin on
filetype indent on

" vi incompatility settings
set nocompatible
set showcmd         " Show (partial) command in status line
set smartcase       " Do smart case matching
set incsearch       " Incremental search
set autowrite       " Automatically save before commands like :next and :make
set hidden          " Hide buffers when they are abandoned

" more often annoying than helpful
set nobackup noswapfile

" use larger history tables
set history=256

" go to last position after loading a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
                \| exe "normal! g'\"" | endif
endif

" persistent undo
set undofile undodir=~/.cache/vim/undofiles,.

" display special chars in a special way
set list listchars=tab:¬·,trail:␣,nbsp:~

" display useful info in the status line
set stl=%f%M%R%H%W\ \ %{&ft},%{&fenc},%{&ff}\ \ %LL%=\ U+%04B\ %8(%l,%c%V%)\ %4P
set ls=2

set textwidth=78

set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab

set pastetoggle=<f12>   " don't change text when copy/pasting
set wildmode=longest:full
set wildmenu

let mapleader=';'
let maplocalleader=','

" don't switch to ex mode, reformat instead
map Q gq

" root
set nomodeline
