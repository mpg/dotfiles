" plugin for Lua files with a concept of sections and subsections
" Manuel Pégourié-Gonnard, 2010. WTFPLv2.

setl tw=78 et sw=4 ts=4 sts=4

" functions for making sections and subsections {{{
function! s:prep_center_dashes()
    s/^-*\s*\(.\{-}\)\s*-*$/--   \1   --/e
    let line = getline('.')
    let before = repeat('-', (&tw-strlen(line))/2)
    let after = repeat('-', &tw-strlen(line)-strlen(before))
    return before.line.after
endfunction

function! s:make_sec()
    let line = s:prep_center_dashes()
    let pos = getpos('.')
    let lnum = pos[1]
    if getline(lnum+1) !~ '^----*$'
        normal o
        normal k
    endif
    if getline(lnum-1) !~ '^----*$'
        normal O
        let lnum = lnum+1
    endif
    let fill = repeat('-', &tw)
    call setline(lnum-1, [fill, line, fill])
endfunction

function! s:make_sub()
    call setline('.', s:prep_center_dashes())
endfunction
" }}}

" functions for folding {{{
function! Lua_fold_level(lnum)
    if s:is_sec_line(a:lnum)
        return '>1'
    elseif s:is_sub_line(a:lnum)
        return '>2'
    elseif getline(a:lnum-1) =~ '^\s*$' && getline(a:lnum) !~ '^\s*$'
        return '>3'
    else
        return '='
    endif
endfunction

function! s:is_sub_line(lnum)
    return getline(a:lnum) =~ '^--\(-\+\)   .*   -\+\1$'
                \ && (getline(a:lnum-1) !~ '^----*$'
                \ || getline(a:lnum+1) !~ '^----*$')
endfunction

function! s:is_sec_line(lnum)
    return getline(a:lnum+1) =~ '^--\(-\+\)   .*   -\+\1$'
                \ && getline(a:lnum) =~ '^----*$'
                \ && getline(a:lnum+2) =~ '^----*$'
endfunction

function! Lua_get_fold_text()
    let text = substitute(getline(v:foldstart), '^-*\s*', ' ', '')
    if text =~ '^\s*$'
        let text = substitute(getline(v:foldstart+1), '^-*\s*', ' ', '')
    endif
    let text = substitute(text, '\s*-*$', ' ', '')
    return v:folddashes . text
endfunction
" }}}

map <buffer> <LocalLeader>sec :silent call <SID>make_sec() <CR>
map <buffer> <LocalLeader>sub :silent call <SID>make_sub() <CR>

setl foldmethod=expr
setl foldexpr=Lua_fold_level(v:lnum)
setl foldtext=Lua_get_fold_text()

" vim: fdm=marker fdl=0
