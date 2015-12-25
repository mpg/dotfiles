setl ts=8 sts=8 et

setl ai
setl nospell

setl syntax=mkd

command! -buffer Date call s:insert_date()

function! s:insert_date()
    r! date -I
    normal o----------ok
endfunction
