" local syntax file - set colors on a per-machine basis:
" Vim color file
" vim: foldmethod=marker:
" Maintainer:	Joe Shields
" Last Change:	2020-10-18

" setup {{{
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "plasticflower"
" }}}

" see :h group-name for a list of the colorable groups (with a preview!)

" syntax stuff {{{
hi Normal cterm=NONE ctermfg=LightGray ctermbg=NONE
hi Comment ctermfg=227

hi Constant ctermfg=226
hi String cterm=italic ctermfg=41
hi Character cterm=italic ctermfg=36
hi Number ctermfg=215
hi Float ctermfg=210
"hi Boolean ctermfg=203
hi boolean ctermfg=199

hi Identifier cterm=bold ctermfg=38
hi Function cterm=bold ctermfg=135

hi Statement ctermfg=171
hi Conditional cterm=bold ctermfg=199 
hi link Repeat Conditional
hi link Label Conditional
hi Operator cterm=bold ctermfg=165
hi link Keyword Conditional
hi link Exception Conditional

hi PreProc cterm=bold ctermfg=13
hi link Inluce PreProc
hi link Define Include
hi link Macro Include
hi Macro cterm=underline
hi link PreCondit Include

hi Type cterm=bold,italic ctermfg=34
hi StorageClass cterm=bold ctermfg=76
hi Structure cterm=bold ctermfg=35
hi Typedef cterm=bold ctermfg=40

hi Special ctermfg=122
hi SpecialChar cterm=bold,italic ctermfg=51
hi Tag cterm=bold ctermbg=122 ctermfg=Black
hi Delimiter cterm=bold ctermfg=51
hi SpecialComment ctermfg=80
"hi Debug

hi Underlined cterm=underline ctermfg=26

hi Ignore cterm=italic ctermbg=234
hi Error cterm=bold ctermfg=Black ctermbg=196
hi Todo cterm=bold ctermfg=black ctermbg=226
hi SpecialKey cterm=italic ctermfg=208 ctermbg=237

hi SpellBad cterm=bold,italic ctermfg=black ctermbg=9
hi SpellCap cterm=bold,italic ctermfg=black ctermbg=4
hi SpellLocal cterm=bold ctermfg=black ctermbg=11
hi SpellRare cterm=bold ctermfg=black ctermbg=13
" }}}
" UI styling {{{
hi Search cterm=bold ctermbg=46
hi IncSearch cterm=bold ctermbg=201 ctermfg=black
hi Visual cterm=reverse ctermbg=Black

hi TabLine cterm=underline ctermfg=250 ctermbg=none
hi TabLineSel cterm=bold ctermfg=159 ctermbg=235
hi TabLineFill cterm=underline ctermfg=none ctermbg=none
"hi Title ctermfg=246
hi StatusLineNC cterm=underline 
hi StatusLine cterm=bold ctermfg=white ctermbg=238
hi ModeMsg cterm=bold ctermfg=208

hi CursorColumn ctermbg=235
hi! link CursorLine CursorColumn
"hi CursorLine cterm=underline

hi ColorColumn ctermbg=DarkGray guibg=DarkGray
hi Folded ctermfg=250 ctermbg=235
" }}}

" hi! link MoreMsg Comment
" hi! link ErrorMsg Visual
" hi! link WarningMsg ErrorMsg
" hi! link Question Comment
