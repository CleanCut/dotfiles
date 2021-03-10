" Custom Color Theme - Based off of $VIMRC/colors/delek.vim (and then
" modified heavily)
"
set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "nathan"

if has("gui_running")
  if has("gui_gtk2")
    set guifont=Ubuntu\ Mono\ 13
  elseif has("gui_macvim")
    set guifont=Ubuntu\ Mono:h18
  elseif has("gui_win32")
    set guifont=Consolas:h13:cANSI
  endif
endif

set guicursor=a:blinkon0

" Highlight all trailing whitespace, except for the line we're currently on.
" Note that this is already taken care of in python files from the
" python_highlight_all variable we set above, but this enables it in
" everything else.
" I got this from the following URL on 2013-10-21:
" http://sartak.org/2011/03/end-of-line-whitespace-in-vim.html
"autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
"autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
"hi EOLWS        cterm=NONE     ctermbg=198          ctermfg=NONE    guibg=#ff0000

" Normal should come first
"hi Normal       cterm=NONE     ctermbg=233          ctermfg=248       guifg=#F8F8F2 guibg=#272822
hi Normal       cterm=NONE     ctermbg=233          ctermfg=248       guifg=#cccccc guibg=#20211b
"hi Cursor       cterm=NONE     ctermbg=LightBlue    ctermfg=LightBlue guibg=fg
hi Cursor       cterm=NONE     ctermbg=LightBlue    ctermfg=LightBlue guibg=#0081ff guifg=#ffffff
"hi lCursor

" Note: we never set 'term' because the defaults for B&W terminals are OK
hi ColorColumn  cterm=NONE     ctermbg=234          ctermfg=NONE      guibg=#2e2d25
hi CursorLine   cterm=NONE     ctermbg=234          ctermfg=NONE      guibg=#2e2d25
hi CursorLineNr cterm=NONE     ctermbg=234          ctermfg=208       guibg=bg      guifg=#75715E gui=none
hi DiffAdd      cterm=NONE     ctermbg=LightBlue    ctermfg=Black     guifg=bg      guibg=#A6E22E
hi DiffChange   cterm=NONE     ctermbg=LightMagenta ctermfg=Black     guifg=bg      guibg=#E6DB74
hi DiffDelete   cterm=NONE     ctermbg=LightCyan    ctermfg=Black     guifg=bg      guibg=#F92672
hi DiffText     cterm=NONE     ctermbg=Red          ctermfg=Black     guifg=bg      guibg=#E6DB74
hi Directory    cterm=NONE     ctermbg=NONE         ctermfg=DarkBlue  guifg=#66D9EF gui=none
hi ErrorMsg     cterm=NONE     ctermbg=DarkRed      ctermfg=White     guifg=#F92672 guibg=bg gui=none
hi FoldColumn   cterm=NONE     ctermbg=Grey         ctermfg=DarkBlue  guifg=#75715E guibg=#3E3D32 gui=none
hi Folded       cterm=NONE     ctermbg=Grey         ctermfg=DarkBlue  guifg=#75715E guibg=bg gui=none
hi IncSearch    cterm=NONE     ctermbg=LightBlue    ctermfg=Black     guifg=#F92672 guibg=white gui=none
hi LineNr       cterm=NONE     ctermbg=NONE         ctermfg=236       guifg=#4a473b guibg=#1b1c17 gui=none
hi MatchParen   cterm=NONE     ctermbg=DarkGray     ctermfg=White     guifg=#ffffff guibg=#F92672 gui=none
hi ModeMsg      cterm=NONE     ctermbg=NONE         ctermfg=NONE      gui=none
hi MoreMsg      cterm=NONE     ctermbg=NONE         ctermfg=DarkGreen guifg=#66D9EF gui=none
hi NonText      cterm=NONE     ctermbg=NONE         ctermfg=Blue      guifg=#3B3A32 gui=none
hi Pmenu        cterm=NONE     ctermfg=Black        ctermbg=250       guifg=fg guibg=#3E3D32
hi PmenuSel     cterm=NONE     ctermbg=DarkBlue     ctermfg=White     guifg=fg guibg=bg
hi PmenuSbar    guibg=bg
hi PmenuThumb   guifg=fg
hi Question     cterm=NONE     ctermbg=NONE         ctermfg=DarkGreen guifg=#A6E22E gui=none
hi Search       cterm=NONE     ctermbg=126          ctermfg=252       guifg=white guibg=#F92672 gui=none
hi SignColum    guifg=#75715E guibg=#3E3D32 gui=none
hi SpecialKey   cterm=NONE     ctermbg=NONE         ctermfg=DarkBlue  guifg=#3B3A32 gui=none
hi SpellBad     guisp=#F92672
hi SpellCap     guisp=#65D9EF
"hi SpellLocal
hi SpellRare    guisp=#AE81FF
hi StatusLine   cterm=NONE     ctermbg=DarkBlue     ctermfg=White     guifg=black guibg=#bfb899 gui=none
hi StatusLineNC cterm=NONE     ctermbg=236          ctermfg=248       guifg=black guibg=#75715E gui=none
hi TabLine      cterm=NONE     ctermbg=DarkGray     ctermfg=Black     guifg=#75715E guibg=#3E3D32 gui=none
hi TabLineFill  cterm=NONE     ctermbg=DarkGray     ctermfg=NONE      guifg=fg guibg=#3E3D32 gui=none
hi TabLineSel   cterm=NONE     ctermbg=DarkBlue     ctermfg=White     guifg=fg guibg=#3E3D32 gui=none
" # of tabs in a window
hi Title        cterm=NONE     ctermbg=NONE         ctermfg=White     guifg=#F92672 gui=none
hi VertSplit    cterm=NONE     ctermbg=NONE         ctermfg=244       guifg=#3B3A32 guibg=bg gui=none
hi Visual       cterm=reverse  ctermbg=NONE         ctermfg=NONE      guibg=#49483E gui=none
hi VisualNOS    cterm=underline,bold ctermbg=NONE   ctermbg=NONE
hi WarningMsg   cterm=NONE     ctermbg=DarkRed      ctermfg=White     guifg=#F92672 gui=none
hi WildMenu     cterm=NONE     ctermbg=Yellow       ctermfg=Black

"hi Menu
"hi ScrollBar
"hi Tooltip

hi pythonParameters guifg=#FD971F
hi pythonParam guifg=#FD971F
hi pythonClass guifg=#A6E22E
hi pythonClassParameters guifg=#A6E22E
hi Todo         cterm=NONE           ctermbg=033          ctermfg=0 guibg=NONE guifg=#00ff00
hi pythonBuiltin guifg=#66D9EF
hi pythonSurrounders guifg=#ff0000

" Color groups (LEAVE FOR REFERENCE!)
hi BlueCursor guifg=#2080f9 gui=none
hi Blue       guifg=#66D9EF gui=none
hi Green      guifg=#A6E22E gui=none
hi Grey       guifg=#75715E gui=none
hi Orange     guifg=#FD971F gui=none
hi Purple     guifg=#AE81FF gui=none
hi Red        guifg=#F92672 gui=none
hi White      guifg=#F8F8F2 gui=none
hi Yellow     guifg=#E6DB74 gui=none

hi BlueU   guifg=#66D9EF gui=underline

hi RedR    guifg=fg guibg=#F92672 gui=none
hi YellowR guifg=bg guibg=#FD971F gui=none

" syntax highlight groups
"hi Comment      cterm=NONE           ctermbg=NONE         ctermfg=238  guifg=#75715E gui=none
hi Comment      cterm=NONE           ctermbg=NONE         ctermfg=238  guifg=#75715E gui=none

hi Constant     cterm=NONE           ctermbg=NONE         ctermfg=034  guifg=#AE81FF gui=none
hi String   guifg=#E6DB74 gui=none
hi! link Character    Yellow
"hi Number
"hi Boolean
"hi Float

hi Identifier   cterm=NONE           ctermbg=NONE         ctermfg=202  guifg=#A6E22E gui=none
hi Function     cterm=NONE           ctermbg=NONE         ctermfg=198    guifg=#A6E22E gui=none

hi Statement    cterm=NONE           ctermbg=NONE         ctermfg=Blue    guifg=#F92672 gui=none
"hi Conditional
"hi Repeat
"hi Label
"hi! link Operator     Green
hi! link Operator     Statement
"hi Keyword
"hi Exception

hi PreProc      cterm=NONE           ctermbg=NONE         ctermfg=DarkMagenta  guifg=#FD971F gui=none
"hi Include
"hi Define
"hi Macro
"hi PreCondit

hi Type         cterm=NONE           ctermbg=NONE         ctermfg=198    guifg=#66D9EF gui=none
hi! link StorageClass Red
"hi Structure
"hi Typedef

hi Special      cterm=NONE           ctermbg=NONE         ctermfg=LightRed   guifg=#AE81FF gui=none
"hi SpecialChar
hi! link Tag          Green
"hi Delimiter
"hi SpecialComment
"hi Debug

hi! link Underlined   BlueU
"hi Ignore
"hi! link Error        RedR
hi Error    guifg=fg guibg=bg gui=undercurl guisp=#F92672

" Language specific highlight groups
" C
hi link cStatement              Green
" C++
hi link cppStatement            Green
" CSS
hi link cssBraces               White
hi link cssFontProp             White
hi link cssColorProp            White
hi link cssTextProp             White
hi link cssBoxProp              White
hi link cssRenderProp           White
hi link cssAuralProp            White
hi link cssRenderProp           White
hi link cssGeneratedContentProp White
hi link cssPagingProp           White
hi link cssTableProp            White
hi link cssUIProp               White
hi link cssFontDescriptorProp   White
" Java
hi link javaStatement           Green
" Ruby
hi link rubyClassVariable       White
hi link rubyControl             Green
hi link rubyGlobalVariable      White
hi link rubyInstanceVariable    White

" vim: sw=2
