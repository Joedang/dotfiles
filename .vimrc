"~~~~~~~~~~ GLOBAL SETTINGS ~~~~~~~~~~ 
set nocompatible " don't try to be compatible with Vi; required for Vundle

" turn on line numbers
set relativenumber
set number

" Only enable mouse mode when in normal mode
" This allows pasting in chromeos (at least when not in tmux)
set mouse=n

" put the swap file next to the edited file if possible
" otherwise, put it in .cache (with a unique name), if possible
" otherwise, put it in /tmp (with a unique name), if possible
set directory=.,~/.cache/vim/swap//,/tmp//

" don't flash the screen when there's a bell
set novb

" Use extended mousey stuff; enables drag-resize within tmux
" might break things with old terminals or terminal emulators
set ttymouse=xterm2

syntax on

" turn on omnicompletion
filetype plugin on
set omnifunc=syntaxcomplete#Complete

" disable modelines at start, only evaluate the first 5 lines
set nomodeline
set modelines=5

" toggle modelines on/off and display the status
nmap   <Leader>ml :set modeline! modeline?<Return>:ed<Return>:set modeline?<Return>
imap <c-l>ml <Esc>:set modeline! modeline?<Return>:ed<Return>:set modeline?<Return>

" key used for completions
set wildchar=<Tab>

" ignore case when completing file/directory names
set wildignorecase

" when hitting wildchar, complete as much as you can, then start the wildmenu
set wildmode=longest:full
set wildmenu

" use the custom dictionary (~/.vim/en.utf-8.add) for word completion
set complete+=kspell

" show hidden files in the NERD tree
let NERDTreeShowHidden=1

" allow the cursor to go all the way to the top and bottom of the screen
" (makes pressing L or H more useful)
set scrolloff=0

" do not sort bookmarks; use the order they appear in NERDTreeBookmarksFile
let NERDTreeBookmarksSort=0

" always show the tab line
set showtabline=2

" set the width of a tab
set tabstop=4

" set the width of an indent
set shiftwidth=4

" set the number of columns of a tab
set softtabstop=4

" use multiple spaces in place of tabs
set expandtab

" view the highlighting info at a location
noremap <Leader>H :echo "visible<"
            \ . synIDattr(synID(line("."),col("."),1),"name") . '> top<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> translated<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

"set completeopt="menuone,preview,noinsert,popup"

" use these chars to indicate whitespace
" when `:set list` is used
" end-of-line shows as '$', trailing spaces show as '~', etc.
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,nbsp:%

" set the color scheme for gvim
:colo plasticflower

" highlight long lines
set cc=+1  " highlight column after 'textwidth'
" set cc=+1,+2,+3  " highlight three columns after 'textwidth'
" This must come after :colo slate 
hi ColorColumn ctermbg=DarkGray
hi ColorColumn guibg=DarkGray
hi Folded ctermfg=250
hi Folded ctermbg=235

" paren matching and visual selections invert colors
hi MatchParen term=reverse cterm=reverse ctermbg=black
hi Visual  term=reverse cterm=reverse ctermbg=black

" Leave textwidth at 0, so it doesn't display by default.
" set textwidth=80

" a more eye-friendly theme for vimdiff
if &diff
    colorscheme darkdiff
endif

let &t_SI = "\<Esc>[6 q" " IBeam shape in insert mode
let &t_SR = "\<Esc>[4 q" " underline shape in replace mode 
let &t_EI = "\<Esc>[2 q" " block shape in normal mode

" Set the default method of encryption for encrypted files
" This is the strongest available by default, according to the help.
set cryptmethod=blowfish2
" When real security is required, use vim-gnupg. 
" Just resave via gpg -a -r 'example@email.com' --encrypt foo.txt
" Open the cipher text (foo.txt.asc) in Vim.
" Remember to shred the clear text via shred -xzf foo.txt

" add manually downloaded plugins
set runtimepath+=$HOME/.vim/manual/*
" Notes:
" Conque-Term comes from https://code.google.com/archive/p/conque/downloads

"~~~~~~~~~~  GLOBAL MAPPINGS ~~~~~~~~~~ 

" To get around Chrome grabbing <C-w>
" Mostly useful for ChromeOS terminal
" Also just nice to do half as many key presses, lol.
nmap <C-H> <C-W><C-H>
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-L> <C-W><C-L>

" somehow makes the real leader backslash
" let mapleader = "."

nmap <Leader>rd :redraw!<Return>
vmap <Leader>rd :redraw!<Return>
vmap <c-l>rd <Esc>:redraw!<Return>a

" toggle both cursorline and cursorcol
command Reticule :set cuc! | :set cul!
nmap <Leader>ret :Reticule<Return>
vmap <Leader>ret :Reticule<Return>
imap <c-l>ret <Esc>:Reticule<Return>a

" default to reticule on
set cursorcolumn
set cursorline

" shortcuts for editing and reloading .vimrc
command RCedit :ed $MYVIMRC
command RCsoruce :source $MYVIMRC

" seek to the next instance of (!)
nmap <Leader>! /(!)
vmap <Leader>! /(!)

" shortcut for :tabnew MYFILE
nmap <Leader>tn :tabnew 

" close the current tab
nmap <Leader>tc :tabclose<Return>

" shortcut to turn on spelling
nmap <Leader>sp :set spell!

" toggle match highlihting in searches
nmap <Leader>hls :set hlsearch!

" set the text width for highlighting purposes
nmap <Leader>tw :set textwidth=

" match and highlight the word under the cursor
" autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))
" to see available highlight groups:
" :so $VIMRUNTIME/syntax/hitest.vim

" shortcut to show whitespace characters
nmap <Leader>ws :set list!

" search for Git conflict markers
" TODO: figure out how to make this work, lol. It doesn't like the \(
" nmap <Leader>/df /\(<<<<<<<\)\|\(|||||||\)\|\(>>>>>>>\)

" dates and times:
" Note that the dates will be in local time, not UTC!
" ISO
imap <c-l>id <c-r>=strftime('%Y-%m-%d')<cr>
nmap <leader>id i<c-r>=strftime('%Y-%m-%d')<cr><Esc>
" ANSI
imap <c-l>ad <c-r>=strftime('%d/%m/%Y')<cr>
nmap <leader>ad i<c-r>=strftime('%d/%m/%Y')<cr><Esc>
" local time
imap <c-l>tl <c-r>=strftime('%H:%M:%S %z')<cr>
nmap <leader>tl i<c-r>=strftime('%H:%M:%S %z')<cr><Esc>
" UTC time
imap <c-l>utc <c-r>=system('date -u "+%Y-%m-%dT%H:%M:%SZ"')<cr>
nmap <leader>utc i<c-r>=system('date -u "+%Y-%m-%dT%H:%M:%SZ"')<cr><Esc>
" middle finger emoji
imap <c-l>fu     🖕
nmap <leader>fu i🖕<Esc>

" command NT NERDTreeToggle
" open a NERDTree tab ahead of all the other tabs
command NT :0tabnew | :NERDTree | :wincmd l | :q

nmap <Leader>nt :NERDTreeToggle

vmap <Leader>tab :Tabularize 

nmap <Leader>toc :Toc<cr>:vertical res 20<cr>:set nonu<cr>:set nornu<cr>:set nowrap<cr>

" automatically do the header for a script
imap <c-l>sh <Esc>:call Shhead()<Return>
nmap <leader>sh :call Shhead()<Return>
command Shhead call Shhead()
function! Shhead() 
    let l:header=["#!/usr/bin/bash"
                \ , "# DESCRIPTION"
                \ , "# USAGE"
                \ , "# DEPENDENCIES"
                \ , "# Copyright " . system("date -I | tr -d '\n'") . ", Joe Shields"
                \ , "# This work is free. You can redistribute it and/or modify it under the"
                \ , "# terms of the Do What The Fuck You Want To Public License, Version 2,"
                \ , "# as published by Sam Hocevar. See COPYING/WTFPL.txt for more details."
                \ ]
    call append(0, l:header)
endfunction

" convenient typo mappings:
command W w
command Q q
command Wq wq
command WQ wq

"~~~~~~~~~~ LANGUAGE SERVER STUFF ~~~~~~~~~~
if executable('rust-analyzer') " to install, run: rustup component add rust-analyzer
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'Rust Language Server',
        \ 'cmd': {server_info->['rust-analyzer']},
        \ 'allowlist': ['rust'],
        \ })
endif

if executable('pylsp') " pacman -S python-lsp-server
    " pip install python-lsp-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> <Leader>ldf   <plug>(lsp-definition)
    nmap <buffer> <Leader>lds   <plug>(lsp-document-symbol-search)
    nmap <buffer> <Leader>lws   <plug>(lsp-workspace-symbol-search)
    nmap <buffer> <Leader>lrf   <plug>(lsp-references)
    nmap <buffer> <Leader>li    <plug>(lsp-implementation)
    nmap <buffer> <Leader>lt    <plug>(lsp-type-definition)
    nmap <buffer> <Leader>lrn   <plug>(lsp-rename)
    nmap <buffer> <Leader>lh    <plug>(lsp-hover)
    nmap <buffer> <Leader>ldl   <plug>(lsp-document-diagnostics)
    " undesired behavior when there are no errors
    "nmap <buffer> <Leader>ldb   <plug>(lsp-document-diagnostics):q<Return>:lbefore<Return>
    "nmap <buffer> <Leader>lda   <plug>(lsp-document-diagnostics):q<Return>:lafter<Return>
    nmap <buffer> <Leader>la    <plug>(lsp-code-action-float)
    " TODO: figure out a sensible binding to scroll the lsp popup
    "nnoremap <buffer> <expr><c-U> lsp#scroll(+4)
    "nnoremap <buffer> <expr><c-D> lsp#scroll(-4)

    " automatically re-style the document when saving (obnoxious)
    " let g:lsp_format_sync_timeout = 1000
    " autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    let g:lsp_diagnostics_enabled = 1
    let g:lsp_diagnostics_signs_delay = 100
    let g:lsp_diagnostics_virtual_text_enabled = 0
    "let g:lsp_diagnostics_echo_cursor = 1 " Doesn't seem to work

endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

"~~~~~~~~~~  LIMELIGHT AND GOYO STUFF ~~~~~~~~~~ 
" " maps
" " toggle Limelight
" nmap <Leader>ll :Limelight!!
" " toggle Goyo
" nmap <Leader>yo :Goyo
" " Color name (:help cterm-colors) or ANSI code
" let g:limelight_conceal_ctermfg = 'gray'
" " Color name (:help gui-colors) or RGB color
" let g:limelight_conceal_guifg = 'DarkGray'
" " Highlighting priority (default: 10)
" "   Set it to -1 not to overrule hlsearch
" let g:limelight_priority = -1
" " highlight lines instead of paragraphs
" let g:limelight_bop = '^'
" let g:limelight_eop = '$'
" " tie it into goyo
" autocmd! User GoyoEnter Limelight
" autocmd! User GoyoLeave Limelight!

"~~~~~~~~~~ FILETYPE SPECIFIC STUFF ~~~~~~~~~~
" non-trivial stuff should go in ~/.vim/after/syntax/MYFILETYPE.vim
" determine MYFILETYPE by running :set ft?

" look for my custom markdown syntax stuff
if empty(globpath(&rtp, '/after/syntax/markdown.vim'))
    echoerr "couldn't find markdown syntax file"
endif

" spell checking in plain text files
autocmd FileType text set spell

" add an item to a list
autocmd FileType tex nmap <Leader>it o\item 
autocmd FileType tex imap <c-l>it \item 

" template for functions
autocmd FileType sh nmap <Leader>fn ofunctionName() { # {{{<Return>} # }}}<Esc>k0
autocmd FileType sh imap <c-l>fn functionName() { # {{{<Return>} # }}}<Esc>k0

" Comment the selection with a #
autocmd FileType sh vmap <Leader>cc I#<Space><Esc>
autocmd FileType sh vmap <Leader>cu :s/^#\ \?//g<Return>

autocmd FileType rust set foldmethod=syntax

"syn match rc_indentStart      /^\ \{4}/  nextgroup=rc_indentEven
"syn match rc_indentEven        /\ \{4}/  contained nextgroup=rc_indentOdd
"syn match rc_indentOdd         /\ \{4}/  contained nextgroup=rc_indentEven
"
"hi rc_indentStart ctermbg=Red   
"hi rc_indentEven  ctermbg=Green 
"hi rc_indentOdd   ctermbg=Blue 

"~~~~~~~~~~ VUNDLE STUFF ~~~~~~~~~~
" Setting nocompatible has side effects on lots of other settings, 
" so it's set at the top of the config instead.
"set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" Plugin 'togglecursor' "hasn't really been useful yet
Plugin 'godlygeek/tabular' "rare to use, but nice
" Plugin 'plasticboy/vim-markdown' "frequently used
" Plugin 'python-mode/python-mode'
" Plugin 'vim-ipython'
" Plugin 'Conque-Shell'
Plugin 'scrooloose/nerdTree'
" Plugin 'tarruda/vim-conque-repl' "nice, but usually outdone by tmux
" Plugin 'ctrlpvim/ctrlp.vim' "nice, but I usually know where my files are
" Plugin 'tpope/vim-surround' "not used to bindings yet; often just do it manually
Plugin 'wesQ3/vim-windowswap' "<leader>ww select another pane <leader>ww panes are swapped
" Plugin 'junegunn/goyo.vim' "minimal single-column editing
" Plugin 'junegunn/limelight.vim' "darken non-current line. special colors req.
Plugin 'alx741/vinfo' "tool for reading info pages with vim
Plugin 'mrk21/yaml-vim' "indentation and highlighting for YAML
Plugin 'jamessan/vim-gnupg' "integration with GPG; still buggy, use when fixed
Plugin 'goerz/jupytext.vim' "for editing .ipynb files in the style of Rmarkdown; relies on Python's jupytext package
Plugin 'prabirshrestha/vim-lsp'
" Plugin 'csv.vim'
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"~~~~~~~~~~ end of Vundle stuff ~~~~~~~~~~

let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_frontmatter = 1
" This does nothing with pythonic folding is enabled:
let g:vim_markdown_folding_level = 3
let g:vim_markdown_new_list_item_indent = 0
