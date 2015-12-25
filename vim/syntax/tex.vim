" override a few colors in default syntax/tex.vim
hi link texCmdName              Identifier
hi link texDef                  Identifier
hi link texNewCmd               Identifier
hi link texNewEnv               Identifier
hi link texStatement            Identifier
hi link texSectionName          Identifier

hi link texSectionMarker        Statement
hi link texSection              Statement

hi link texInput                PreProc
hi link texInputFile            PreProc

hi link texMathDelim            Statement
hi link texMath                 PreProc

" no error checking (too many false positives)
let g:tex_no_error = 1

" load fixed version of the official syntax file
runtime syntax/tex_fixed.vim
