" my filetype file
if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    " for mbed TLS test files
    au! BufRead,BufNewFile *.function setfiletype c

    " TeXLua files
    au! BufRead,BufNewFile *.tlu      setfiletype lua

    " IMJ website
    au! BufRead,BufNewFile *.oueb     setfiletype oueb

    " latexmk configuration is Perl code
    au! BufRead,BufNewFile latexmkrc  setfiletype perl
augroup END
