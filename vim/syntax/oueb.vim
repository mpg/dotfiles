" Vim syntax file
" private format oueb

" Read the markdown syntax to start with
runtime! syntax/mkd.vim
unlet b:current_syntax

" Add colors to the tags in the meta blocks
sy match  	ouebMetaTag    	"^\(title\|descr\|keyw\|h1\):\s"
hi link 	ouebMetaTag	SpecialKey
let b:current_syntax = "blogsyntax"
