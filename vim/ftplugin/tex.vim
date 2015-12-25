" personnal tex ftplugin using latexbox

setl tw=78 sw=2 et ts=4 sts=4

" formating {{{

" auto-insert comment leader
setlocal formatoptions+=r

" fake comments for gq: see after/ftplugin
" }}}

" {{{ recognize @ as a keyword character
setl iskeyword+=@-@
" }}}

" file name completion {{{
setlocal suffixes=.aux,.bbl,.blg,-blx.bib,.dvi,.fdb_latexmk,.idx,.ilg,.ind,
            \.inx,.log,.nlo,.nls,.out,.pdf,.ps,.toc,.fls,.loc,.nlo,.nls,.run.xml
" }}}

" omni completion from latex-box {{{
setl omnifunc=LatexBox_Complete
" }}}

" Error Format {{{
" This assumes we're using the -file-line-error with [pdf]latex.
setlocal efm=%E%f:%l:%m,%-Cl.%l\ %m,%-G
" }}}

" latex-box settings {{{
let g:LatexBox_viewer = 'setsid xpdf'
let g:LatexBox_no_mappings = 1
" }}}

" compile functions {{{
function! s:compile_simple()
    if !exists("b:tex_engine") | let b:tex_engine='pdflatex' | endif
    exe '!' . b:tex_engine . ' ' . LatexBox_GetMainTexFile()
endfunction

function! s:latexmk(options)
    exe "!latexmk " . a:options . ' ' . LatexBox_GetMainTexFile()
endfunction
" }}}

" comment functions {{{
function! s:comment_out(...)
    let a = a:0 ? "'[" : "'<"
    let z = a:0 ? "']" : "'>"
    let lend = line(z)
    let lnum = line(a)
    while lnum <= lend
        let nsp = strlen(substitute(getline(lnum), '\S.*', '', ''))
        if !exists('nspaces') || nsp < nspaces
            let nspaces = nsp
        endif
        let lnum = lnum + 1
    endwhile
    silent exe a . ',' . z . 's/\m^\(\s\{' . nspaces . '}\)/\1% /'
endfunction

function! s:comment_in(...)
    let a = a:0 ? "'[" : "'<"
    let z = a:0 ? "']" : "'>"
    silent exe a . ',' . z . 's/\m^\(\s*\)% /\1/e'
endfunction

function! s:comment_toggle(...)
    let z = a:0 ? "']" : "'>"
    let way = match(getline(z), '^\s*%') >= 0 ? 'in' : 'out'
    let argv = a:0 ? '"' . a:1 . '"' : ''
    exe 'call s:comment_' . way . '(' . argv . ')'
endfunction
" }}}

" motion & objects mappings from latex-box {{{
""nmap <buffer> % <Plug>LatexBox_JumpToMatch
""xmap <buffer> % <Plug>LatexBox_JumpToMatch
vmap <buffer> ie <Plug>LatexBox_SelectCurrentEnvInner
vmap <buffer> ae <Plug>LatexBox_SelectCurrentEnvOuter
omap <buffer> ie :normal vie<CR>
omap <buffer> ae :normal vae<CR>
vmap <buffer> i$ <Plug>LatexBox_SelectInlineMathInner
vmap <buffer> a$ <Plug>LatexBox_SelectInlineMathOuter
omap <buffer> i$ :normal vi$<CR>
omap <buffer> a$ :normal va$<CR>
" }}}

" environment/commands mappings {{{
imap <buffer> <LocalLeader>ee <Plug>LatexCloseCurEnv
nmap <buffer> <LocalLeader>ec <Plug>LatexChangeEnv
vmap <buffer> <LocalLeader>ew <Plug>LatexEnvWrapSelection
vmap <buffer> <LocalLeader>cw <Plug>LatexWrapSelection
" }}}

" begin{env} shortcuts (mainly for beamer) {{{
imap <buffer> <LocalLeader>bb   \begin{block}{
imap <buffer> <LocalLeader>bc   \begin{columns}<CR>\column[t]{0.5\textwidth}
imap <buffer> <LocalLeader>bd   \begin{description}<CR>\item
imap <buffer> <LocalLeader>be   \begin{enumerate}<CR>\item
imap <buffer> <LocalLeader>bf   \begin{frame}{
imap <buffer> <LocalLeader>bi   \begin{itemize}<CR>\item
imap <buffer> <LocalLeader>bv   \begin{Verbatim}[gobble=
" }}}

" view/make mappings {{{
nmap <buffer> <LocalLeader>v  :call LatexBox_View() <CR><CR>
nmap <buffer> <LocalLeader>ms :call <SID>compile_simple() <CR><CR>
nmap <buffer> <LocalLeader>mm :call <SID>latexmk('')    <CR><CR>
nmap <buffer> <LocalLeader>mf :call <SID>latexmk('-g')  <CR><CR>
nmap <buffer> <LocalLeader>mF :call <SID>latexmk('-gg') <CR><CR>
nmap <buffer> <LocalLeader>mc :call <SID>latexmk('-c')  <CR><CR>
nmap <buffer> <LocalLeader>mC :call <SID>latexmk('-C')  <CR><CR>
" }}}

" TOC command and mapping {{{
command! LatexTOC call LatexBox_TOC()
map <buffer> <silent> <LocalLeader>toc :LatexTOC<CR>
" }}}

" comment mappings {{{
nmap <buffer><silent> <LocalLeader>co :set opfunc=<SID>comment_out<CR>g@
nmap <buffer><silent> <LocalLeader>ci :set opfunc=<SID>comment_in<CR>g@
nmap <buffer><silent> <LocalLeader>cc :set opfunc=<SID>comment_toggle<CR>g@
vmap <buffer><silent> <LocalLeader>co :<C-U>call <SID>comment_out()<CR>
vmap <buffer><silent> <LocalLeader>ci :<C-U>call <SID>comment_in()<CR>
vmap <buffer><silent> <LocalLeader>cc :<C-U>call <SID>comment_toggle()<CR>
" }}}

" abbreviations {{{
iabbr <buffer> [[ \begin{equation}
iabbr <buffer> prrof proof
" }}}

" special set commands {{{
command! -buffer -nargs=1 SetMain   let b:main_tex_file=<q-args>
command! -buffer -nargs=1 SetEngine let b:tex_engine=<q-args>
" }}}

" vim: fdm=marker fdl=0
