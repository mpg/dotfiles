set fileencodings=utf8,latin1

syntax on
colorscheme mpg

" use pathogen to load bundles
execute pathogen#infect()

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

" text object for C functions
vnoremap af :<C-U>silent! normal! [[{jV][j<CR>
omap af :normal vaf<CR>

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

" single space after period when joining lines
set nojoinspaces

set textwidth=78

set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab

set pastetoggle=<f12>   " don't change text when copy/pasting
set wildmode=longest:full
set wildmenu

set tags=./tags;/

set foldlevel=999 " don't fold unless I say so

let mapleader=';'
let maplocalleader=','

" don't switch to ex mode, reformat instead
map Q gq

" shortcuts for spell checking
com Fr setl spell spelllang=fr
com En setl spell spelllang=en

" transliterate to ascii using GNU iconv (assumes utf8 input)
com -range Ascii silent <line1>,<line2>!iconv -f utf8 -t ascii//translit

" normalize case for English titles
com -range TitleCase
            \   silent <line1>,<line2>s/.*/\L&/eg
            \ | silent <line1>,<line2>s/\<\l/\u&/eg
            \ | silent <line1>,<line2>s/\<\(
                \A\|An\|The\|And\|As\|At\|By\|For\|In\|Of\|On\|To
                \\)\>/\l&/eg
            \ | silent <line1>,<line2>s/^\(.*\)\.\(.*\)$/\1.\L\2/e

" show current syntax group (vimtip #99)
com Synshow echo "hi<"
            \ . synIDattr(synID(line("."),col("."),1),"name")
            \ . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name")
            \ . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
            \ . ">"

com -nargs=1 Boilerplate
            \ execute "r" . $HOME . "/.vim/boilerplate/" . <q-args>

com WALast r! ls ~/.wine/drive_c/Team17/Worms\ Armageddon/User/Games/
            \ | tail -n 1 | cut -f1,2 -d' '

" for tex syntax file (needs to be set early, ftplugin/tex comes too late)
let g:tex_flavor = 'tex'

" don't apply the Linux coding style to every C file
let g:linuxsty_patterns = [ "linux" ]

" prefered flavour of asm is nasm
"let g:asmsyntax = "nasm"

" enable doxygen highlighting
let g:load_doxygen_syntax=1

" a.vim settings
let g:alternateRelativeFiles = 1
" (should be local to polarssl)
let g:alternateSearchPath = 'sfr:../source,sfr:../src,sfr:../include,sfr:../inc,sfr:../include/polarssl'

" (for polarssl, but may be generaly useful)
set path+=include,./include,../include

" BEGIN from http://www.zwiener.org/vimautocomplete.html
" Complete options (disable preview scratch window)
set completeopt=menu,menuone,longest
" Limit popup menu height
set pumheight=15

" Disable auto popup
let g:clang_complete_auto=0
" Show clang errors in the quickfix window
" currenty screws up when more than one window open on the current buffer
let g:clang_complete_copen=0
" complete preprocessor symbols
let g:clang_complete_macros=1
" END

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" Load surround.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_surround') && findfile('plugin/surround.vim', &rtp) ==# ''
  runtime! macros/surround.vim
endif

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.xxd let &bin=1
  au BufReadPost *.xxd if &bin | %!xxd
  au BufReadPost *.xxd set ft=xxd | endif
  au BufWritePre *.xxd if &bin | %!xxd -r
  au BufWritePre *.xxd endif
  au BufWritePost *.xxd if &bin | %!xxd
  au BufWritePost *.xxd set nomod | endif
augroup END

" local
set modeline
