" mpg's additional perl ftplugin

" turn a statement modifier into a control structure
com! -buffer Prefix
            \ silent s:\v^(\s*)(.*)\s+(for|if|unless)\s*
                \%(\((.*)\)|(.*));\s*$
                \:\1\3 (\4\5) {\r\1    \2;\r\1}:

nmap <buffer> <F5> :!perl %<CR>
nmap <buffer> <F6> :!perl -c %<CR>
