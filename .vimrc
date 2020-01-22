"~~~~~~~~~~ GLOBAL SETTINGS ~~~~~~~~~~ 

" turn on line numbers
set relativenumber
set number

" Only enable mouse mode when in normal mode
" This allows pasting in chromeos (at least when not in tmux)
set mouse=n

" Use extended mousey stuff; enables drag-resize within tmux
" might break things with old terminals or terminal emulators
set ttymouse=xterm2

syntax on

" turn on omnicompletion
filetype plugin on
set omnifunc=syntaxcomplete#Complete

" show hidden files in the NERD tree
let NERDTreeShowHidden=1

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

" use these chars to indicate whitespace
" when `:set list` is used
" end-of-line shows as '$', trailing spaces show as '~', etc.
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,nbsp:%

" set the color scheme for gvim
:colo slate

" highlight long lines
set cc=+1  " highlight column after 'textwidth'
" set cc=+1,+2,+3  " highlight three columns after 'textwidth'
" This must come after :colo slate 
hi ColorColumn ctermbg=DarkGray
hi ColorColumn guibg=DarkGray
" Leave textwidth at 0, so it doesn't display by default.
" set textwidth=80

let &t_SI = "\<Esc>[6 q" " IBeam shape in insert mode
let &t_SR = "\<Esc>[4 q" " underline shape in replace mode 
let &t_EI = "\<Esc>[2 q" " block shape in normal mode

" Set the default method of encryption for encrypted files
" This is the strongest available by default, according to the help.
set cryptmethod=blowfish2

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

" shortcuts for editing and reloading .vimrc
command RCedit :ed $MYVIMRC
command RCsoruce :source $MYVIMRC

" seek to the next instance of (!)
nmap <Leader>! /(!)
vmap <Leader>! /(!)

" shortcut for :tabnew MYFILE
nmap <Leader>tn :tabnew 

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

" dates and times:
" Note that the dates will be in local time, not UTC!
" ISO
imap <c-l>id <c-r>=strftime('%Y-%m-%d')<cr>
nmap <leader>id i<c-r>=strftime('%Y-%m-%d')<cr><Esc>
" ANSI
imap <c-l>ad <c-r>=strftime('%d/%m/%Y')<cr>
nmap <leader>ad i<c-r>=strftime('%d/%m/%Y')<cr><Esc>
" local time
imap <c-l>lt <c-r>=strftime('%H:%M:%S %z')<cr>
nmap <leader>lt i<c-r>=strftime('%H:%M:%S %z')<cr><Esc>
" UTC time
imap <c-l>utc <c-r>=system('date -u "+%Y-%m-%d:%H:%M:%S %Z"')<cr>
nmap <leader>utc i<c-r>=system('date -u "+%Y-%m-%d:%H:%M:%S %Z"')<cr><Esc>

" command NT NERDTreeToggle
" open a NERDTree tab ahead of all the other tabs
command NT :0tabnew | :NERDTree | :wincmd l | :q

nmap <Leader>nt :NERDTreeToggle

vmap <Leader>tab :Tabularize 

nmap <Leader>toc :Toc<cr>:vertical res 20<cr>:set nonu<cr>:set nornu<cr>:set nowrap<cr>

" convenient typo mappings:
command W w
command Q q
command Wq wq
command WQ wq

"~~~~~~~~~~  LIMELIGHT AND GOYO STUFF ~~~~~~~~~~ 
" maps
" toggle Limelight
nmap <Leader>ll :Limelight!!
" toggle Goyo
nmap <Leader>gy :Goyo
" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
" Color name (:help gui-colors) or RGB color
let g:limelight_conceal_guifg = 'DarkGray'
" Highlighting priority (default: 10)
"   Set it to -1 not to overrule hlsearch
let g:limelight_priority = -1
" highlight lines instead of paragraphs
let g:limelight_bop = '^'
let g:limelight_eop = '$'
" tie it into goyo
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

"~~~~~~~~~~ FILETYPE SPECIFIC STUFF ~~~~~~~~~~

" add TODO list item 
autocmd FileType markdown nmap <Leader>td o- [ ] 
autocmd FileType markdown imap <c-l>td <Esc>o- [ ] 
" check off a TODO item
autocmd FileType markdown nmap <Leader>ck 0f[lrX<Esc>
autocmd FileType markdown imap <c-l>ck <Esc>0f[lrX<Esc>
" mark a TODO item as critical
autocmd FileType markdown nmap <Leader>cr 0f]a<Space>(!)<Esc>
autocmd FileType markdown imap <c-l>cr <Esc>0f]a<Space>(!)<Esc>
" uncheck a TODO item
autocmd FileType markdown nmap <Leader>uk 0f[lr <Esc>
autocmd FileType markdown imap <c-l>uk 0f[lr <Esc>

" add an item to a list
autocmd FileType tex nmap <Leader>it o\item 
autocmd FileType tex imap <c-l>it \item 

"~~~~~~~~~~ VUNDLE STUFF ~~~~~~~~~~
set nocompatible              " be iMproved, required
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
Plugin 'plasticboy/vim-markdown' "frequently used
" Plugin 'python-mode/python-mode'
" Plugin 'vim-ipython'
" Plugin 'Conque-Shell'
Plugin 'scrooloose/nerdTree'
Plugin 'tarruda/vim-conque-repl' "nice, but usually outdone by tmux
Plugin 'ctrlpvim/ctrlp.vim' "nice, but I usually know where my files are
Plugin 'tpope/vim-surround' "not used to bindings yet; often just do it manually
Plugin 'wesQ3/vim-windowswap' "<leader>ww select another pane <leader>ww panes are swapped
Plugin 'junegunn/goyo.vim' "minimal single-column editing
Plugin 'junegunn/limelight.vim' "darken non-current line. special colors req.
Plugin 'alx741/vinfo' "tool for reading info pages with vim
Plugin 'mrk21/yaml-vim' "indentation and highlighting for YAML
Plugin 'jamessan/vim-gnupg' "integration with GPG; still buggy, use when fixed
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
