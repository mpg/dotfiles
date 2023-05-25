" mpg.vim - my vim color scheme for cterm
"
" Author:	Manuel Pégourié-Gonnard <mpg@elzevir.fr>
" Description:	Loosely based on delek.vim by David Schweikert
"		and adapted to my custom urxvt color settings
"		(`dark' colors are actually bright,
"		`light' colors are faded towards white).

let g:colors_name = expand('<sfile>:t:r')

set background=dark
hi clear

" default groups, see :h highlight-groups
"hi Cursor
"hi CursorIM
"hi CursorColumn
"hi CusorLine
hi Directory	ctermfg=DarkBlue
hi DiffAdd				ctermbg=Blue
hi DiffChange				ctermbg=Magenta	cterm=bold
hi DiffDelete   ctermfg=DarkBlue	ctermbg=Cyan	cterm=bold
hi DiffText				ctermbg=Red	cterm=bold
hi ErrorMsg	ctermfg=White		ctermbg=Red	cterm=bold
hi VertSplit						cterm=reverse
hi Folded	ctermfg=DarkBlue	ctermbg=LightGrey
hi FoldColumn	ctermfg=DarkBlue	ctermbg=LightGrey
"hi SignColumn
hi IncSearch	ctermfg=White		ctermbg=DarkRed	cterm=bold
hi LineNr	ctermfg=Brown
hi MatchParen	ctermfg=Black		ctermbg=Cyan
hi ModeMsg						cterm=bold
hi MoreMsg	ctermfg=DarkGreen
hi NonText	ctermfg=DarkBlue
"hi Normal
"hi Pmenu
hi PmenuSel	ctermfg=White		ctermbg=Blue
"hi PmenuSbar
"hi PmenuThumb
hi Question	ctermfg=DarkGreen
hi Search	ctermfg=NONE		ctermbg=Yellow	cterm=bold
hi SpecialKey	ctermfg=DarkBlue
hi SpellBad				ctermbg=Red
hi SpellCap				ctermbg=Blue
hi SpellLocal				ctermbg=Cyan
hi SpellRare				ctermbg=Magenta
hi StatusLine	ctermfg=DarkYellow	ctermbg=DarkBlue cterm=bold
hi StatusLineNC	ctermfg=Black		ctermbg=DarkBlue cterm=bold
"hi TabLine
"hi TabLineFill
hi Title	ctermfg=DarkMagenta
hi Visual				ctermbg=NONE	cterm=reverse
hi VisualNOS						cterm=underline,bold
hi WarningMsg	ctermfg=DarkRed
hi WildMenu	ctermfg=Black		ctermbg=Yellow

" syntax groups, see :h group-name
hi Comment	ctermfg=DarkRed				cterm=NONE
hi Constant	ctermfg=DarkGreen			cterm=NONE
hi Identifier	ctermfg=DarkCyan			cterm=NONE
hi Statement	ctermfg=DarkBlue			cterm=bold
hi PreProc	ctermfg=DarkMagenta			cterm=NONE
hi Type		ctermfg=DarkBlue			cterm=NONE
hi Special	ctermfg=DarkRed				cterm=NONE
"hi Underlined
"hi Ignore
"hi Error
"hi Todo


" vim: noet ts=8 sts=8
