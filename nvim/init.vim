" Settings
" --------

" persistent undo
set undofile

" display special chars in a special way
set list listchars=tab:¬·,trail:␣,nbsp:~

" statusline: very similar to the default, add:
" preview window flag       %w
" filetype,fileformat       %{&ft},%{&ff}
" total number of lines     %L
" code point under cursor   U+%04B
set stl=%<%f\ %h%m%r%w\ \ %{&ft},%{&ff}\ \ %LL%=U+%04B\ %-14.(%l,%c%V%)\ %P

" general defaults, can be overridden by filetypes
set textwidth=80
set shiftwidth=4    " Number of spaces to use for each step of (auto)indent.
set softtabstop=4   " Number of spaces that a <Tab> counts for while editing.
set expandtab       " Insert spaces rather than actual <Tab>s.

" Shortcuts
" ---------

" shortcuts for spell checking
com Fr setl spell spelllang=fr
com En setl spell spelllang=en

" transliterate to ascii using GNU iconv (assumes utf8 input)
com -range Ascii silent <line1>,<line2>!iconv -f utf8 -t ascii//translit

