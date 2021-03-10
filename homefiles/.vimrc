" *** SEE ~/.vim/after/ftplugin/python.vim FOR PYTHON-SPECIFIC STUFF ***

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Treate semicolon as colon in normal and visual modes
nnoremap ; :
vnoremap ; :


" This must be before anything that tries to use <Leader> in a definition
let mapleader=","

" Use this to display the highlight styles at the current cursor.
map <Leader>1 :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Close HTML Tags
" ,/   Omni-complete the last tag and leave cursor at the end of the line.
" ,,/  Omni-complete the last tage and move cursor to the start of the closing
"      tag.
imap ,/ </<C-X><C-O><C-X>
imap ,,/ </<C-X><C-O><C-X><Esc>F<i
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags

" Common HTML Tag shortcuts
imap ,b <br>

" Crazy common javascript ending '});' can be typed by hitting ';;'
au BufRead,BufNewFile *.js,*.html imap <buffer> ;; });<CR>

" --- Syntastic Python Versions
map <Leader>2 :call Py2()<CR>
map <Leader>3 :call Py3()<CR>

" --- Jump between error locations ---
map <Leader>e :lnext<CR>
map <Leader>E :lprev<CR>

" --- Django template boundaries ---

" Map ',7' to '{%'
au BufRead,BufNewFile *.html imap <Leader>7 {%<space>

" Map ',8' to '%}'
au BufRead,BufNewFile *.html imap <Leader>8 <space>%}

" Map ',9' to '{{'
au BufRead,BufNewFile *.html imap <Leader>9 {{<space>

" Map ',0' to '}}'
au BufRead,BufNewFile *.html imap <Leader>0 <space>}}


" Turn on the "pathogen" plugin -- then complicated plugins can just be put in
" their own subdirectory under ~/.vim/bundle and get automatically loaded.
execute pathogen#infect()
call pathogen#helptags()

" Ansible: A blank line means you want to end indentation in .yml files
let g:ansible_options = {'ignore_blank_lines': 0}

" CtrlP:
" I'm trying to get it to prioritize the files that closely match what I type.
" Unfortunately, it'll only do 'filename only' or 'match the directory before
" the filename'  Annoying.
"let g:ctrlp_by_filename = 1

" The default <F5> key is inconvenient. Make another way to refresh
map <Leader>cp :call ctrlp#clra()<CR>
" Enable using ripgrep (rg) in CtrlP for faster performance
if executable('rg')
  " Use ripgrep instead of grep
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  set grepformat=%f:%l:%c:%m,%f:%l:%m

  " Use ripgrep in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

" DelimitMate: Correctly handle triple-quoting in Python
au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
let g:delimitMate_expand_space = 1
let g:delimitMate_balance_matchpairs = 1

" Syntastic: Enable javascript checking
let g:syntastic_javascript_checkers = ['jshint']

" Syntastic: Make a way to switch between python2 and python3 (,2 and ,3 above)
function! Py2()
  let g:syntastic_python_python_exec = system('which python2.7')
  let g:syntastic_python_checkers = ['pyflakes', 'python']
endfunction

function! Py3()
  " Falls back to Python 2 if Python 3 isn't present
  let g:syntastic_python_python_exec = system('which python3 2>/dev/null || which python')
  let g:syntastic_python_checkers = ['pyflakes', 'python']
endfunction

" Set syntastic to Python 3 by default
call Py3()

" Tell syntastic to always do html5 and to ignore angular directives
let g:syntastic_html_validator_parser='html5'
let g:syntastic_html_tidy_ignore_errors=['proprietary attribute "ng-', 'proprietary attribute "sortable"', "plain text isn't allowed in <head> elements"]

" Tell syntastic to always update the error location list.  Use the mapped
" shortcuts for :lnext and :lprev to move between the syntax errors
let g:syntastic_always_populate_loc_list = 1

" YouCompleteMe Options
" Load the languages keywords for autocompletion
let g:ycm_seed_identifiers_with_syntax = 1

" Make rust work better with YouCompleteMe
let g:ycm_rust_src_path = $HOME . "/rust/rust/src"

" Close the stupid preview window
"let g:ycm_autoclose_preview_window_after_completion = 1

if filereadable("/bin/zsh")
  " Use zsh if we can
  set shell=/bin/zsh
else
  " Use the "login" option for the :shell command so that we get our full bash
  " envirenmont with bash and git completion, etc.
  set shell=/bin/bash\ -l
endif

" Syntax highlighting for odd extensions
au BufRead,BufNewFile *.adp setfiletype tcl
au BufRead,BufNewFile *.nse setfiletype lua
au BufRead,BufNewFile *.md  setfiletype markdown

" Try to change the working directory to the file we started editing (so
" subsequent file-opening commands start by looking in the same directory)
"if exists('+autochdir')
"  set autochdir
"endif

" Turn on line numbers
set number

" Start scrolling this many lines before the top/bottom of the window
set scrolloff=2

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" When hitting tab to complete filenames, act like bash does
set wildmode=longest,list

" How to handle backup files
set backup        " keep a backup file
set backupdir=~/.backup_vim
if !isdirectory($HOME . "/.backup_vim")
  call mkdir($HOME . "/.backup_vim")
endif

" Put all swap files in /tmp instead of the same directory as the file.
set directory=/tmp

set history=50      " keep 50 lines of command line history
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set incsearch       " do incremental searching

" Combining the following two options make searches work like as in emacs; if
" you type in lowercase the search will ignore case, but if you type any upper
" case then the search will match case exactly.
set ignorecase
set smartcase

" (To convert existing tabs to spaces, do :retab
" Tabs loaded from an existing document are displayed as 4 spaces (tabstop).
set tabstop=4
" Instead of adding tab characters while editing, add 4 spaces.
set shiftwidth=4
set expandtab

" Don't use Ex mode, use Q for formatting
"map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 80 characters.
  "autocmd FileType text setlocal textwidth=80

  "autocmd FileType python setlocal textwidth=80

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent        " always set autoindenting on

endif " has("autocmd")


" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

function! <SID>StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

" Map ', ' to call StripTrailingWhitespace
nmap <silent> <Leader><space> :call <SID>StripTrailingWhitespace()<CR>

" Map ',=' to Tab/=
map <Leader>= :Tab/=<CR>

" Map ',;' and ',:' to Tab/:
map <Leader>; :Tab/:<CR>
map <Leader>: :Tab/:<CR>

" Map ',]' to (re)generate a ctags tags file in the cwd
map <Leader>] :silent !ctags -R<CR>:redraw!<CR>

" Map ',j' to collapse large whitespace to one space
map <Leader>j ciw jk

" Map ',l' to run the Syntastic linter, and ',r' to reset (clear) it.
map <Leader>l :SyntasticCheck<CR>
map <Leader>r :SyntasticReset<CR>

" Map ',n' to go to the next search, and then put it near the top of the
" screen
map <Leader>n nzt
map <Leader>N Nzt

" Map ',s' to clear the last search (to stop highlighting it)
map <Leader>s :let @/ = ""<CR>

" Map ',u' to call the gundo plugin.  See http://sjl.bitbucket.org/gundo.vim/
map <Leader>u :GundoToggle<CR>
" Configure some gundo options...
let g:gundo_preview_bottom = 1
let g:gundo_preview_height = 25
let g:gundo_playback_delay = 150
let g:gundo_close_on_revert = 1

" Map C-n to open NERDTree
map <C-n> :NERDTreeToggle<CR>
" Ignore some files
let NERDTreeIgnore = ['\.pyc$', '_trial_temp']
" Close vim if the only window left open is a NERDTree
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" So nerdcommenter will default to adding the comments aligned to the left
let g:NERDDefaultAlign = 'left'

" Map ',y' to yank a window (mark as source for swap), ',p' in another window
" to swap.
let g:windowswap_map_keys = 0 "prevent default bindings
nnoremap <silent> <leader>y :call WindowSwap#MarkWindowSwap()<CR>
nnoremap <silent> <leader>p :call WindowSwap#DoWindowSwap()<CR>
" Make it so when writing filenames, you can use '%%' to expand to directory
" of the file of the current buffer.
cabbr <expr> %% expand('%:p:h')

" Make it so that pressing 'jk' (with or without caps) in insert mode is the
" same as <ESC>
inoremap jk <ESC>
inoremap JK <ESC>
inoremap jK <ESC>
inoremap Jk <ESC>

let python_highlight_all = 1

" Show the statusline even if only one window is in this tab
set laststatus=2

" Configure a custom statusline
set statusline  =%<%F\           " Full path to file
set statusline +=%w%m            " Preview & Modified flags
"set statusline +=%{fugitive#statusline()}
set statusline +=\ %y            " FiletypE
" set statusline +=\ %{getcwd()}
set statusline +=%#warningmsg#   " Any messages
set statusline +=%*              " Set the color back after messages
"set statusline +=\ %a
set statusline +=%=              " Switch to right-side of statusline
set statusline +=col\ %c\ \|     " Column number
set statusline +=\ %L\ lines     " Total lines
set statusline +=\ %3p%%         " Percentage of the way through the file

colorscheme nathan

set cursorline
set tabpagemax=500
set clipboard=unnamed
set guioptions=gm

" Override the dispatch handlers vim-dispatch looks for to run the omnisharp
" server so that it doesn't open up a tab in iTerm
  let g:dispatch_handlers = [
        \ 'tmux',
        \ 'screen',
        \ 'windows',
        \ 'x11',
        \ 'headless',
        \ ]

"Showmatch significantly slows down omnicomplete
"when the first match contains parentheses.
set noshowmatch

"Super tab settings - uncomment the next 4 lines
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabDefaultCompletionTypeDiscovery = ["&omnifunc:<c-x><c-o>","&completefunc:<c-x><c-n>"]
"let g:SuperTabClosePreviewOnPopupClose = 1

"don't autoselect first item in omnicomplete, show if only one item (for preview)
"remove preview if you don't want to see any documentation whatsoever.
set completeopt=longest,menuone,preview
" Fetch full documentation during omnicomplete requests.
" There is a performance penalty with this (especially on Mono)
" By default, only Type/Method signatures are fetched. Full documentation can still be fetched when
" you need it with the :OmniSharpDocumentation command.
let g:omnicomplete_fetch_documentation=1

"Move the preview window (code documentation) to the bottom of the screen, so it doesn't move the code!
"You might also want to look at the echodoc plugin
set splitbelow

" Get Code Issues and syntax errors
let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']

" this setting controls how long to wait (in ms) before fetching type / symbol information.
set updatetime=500
" Remove 'Press Enter to continue' message when type information is longer than one line.
"set cmdheight=2

" Contextual code actions (requires CtrlP)
nnoremap <leader><return> :OmniSharpGetCodeActions<cr>
" Run code actions with text selected in visual mode to extract method
vnoremap <leader><return> :call OmniSharp#GetCodeActions('visual')<cr>

" rename with dialog
"nnoremap <leader>nm :OmniSharpRename<cr>
nnoremap <F2> :OmniSharpRename<cr>
" rename without dialog - with cursor on the symbol to rename... ':Rename newname'
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

" Force OmniSharp to reload the solution. Useful when switching branches etc.
nnoremap <leader>rl :OmniSharpReloadSolution<cr>
nnoremap <leader>cf :OmniSharpCodeFormat<cr>
" Load the current .cs file to the nearest project
nnoremap <leader>tp :OmniSharpAddToProject<cr>

" (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp server for the current solution
nnoremap <leader>ot :OmniSharpStartServer<cr>
nnoremap <leader>op :OmniSharpStopServer<cr>

" Add syntax highlighting for types and interfaces
nnoremap <leader>th :OmniSharpHighlightTypes<cr>
"Don't ask to save when changing buffers (i.e. when jumping to a type definition)
set hidden

" vim: sw=2
