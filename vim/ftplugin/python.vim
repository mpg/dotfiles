" personal settings for python

setl tw=78 sw=4 sts=4 et ts=8

nmap <buffer> <F5> :!python %<CR>
nmap <buffer> <F6> :!pylint %<CR>

setl omnifunc=pythoncomplete#Complete

setl foldmethod=indent
