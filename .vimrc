" turn on line numbers
set relativenumber

" To get around Chrome grabbing <C-w>
" Mostly useful for ChromeOS terminal
nmap <C-H> <C-W><C-H>
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-L> <C-W><C-L>

syntax on

" turn on omnicompletion
filetype plugin on
set omnifunc=syntaxcomplete#Complete

" set the color scheme for gvim
:colo slate

" add manually downloaded plugins
set runtimepath+=$HOME/.vim/manual/*
" Notes:
" Conque-Term comes from https://code.google.com/archive/p/conque/downloads

" Only enable mouse mode when in normal mode
" This allows pasting in chromeos (at least when not in tmux)
set mouse=n

" This would be a nice way to have RStudio-like functionality, if Vim would
" not freeze the pane as soon as it is left.
" map <c-k> <F9><Enter><Esc><C-W>k

command NT NERDTreeToggle

"~~~~~~~~~~ Vundle stuff ~~~~~~~~~~
set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'togglecursor' "hasn't really been useful yet
Plugin 'godlygeek/tabular' "rare to use, but nice
Plugin 'plasticboy/vim-markdown' "frequently used
" Plugin 'python-mode/python-mode'
" Plugin 'vim-ipython'
" Plugin 'Conque-Shell'
Plugin 'scrooloose/nerdTree'
Plugin 'tarruda/vim-conque-repl' "nice, but usually outdone by tmux
Plugin 'ctrlpvim/ctrlp.vim' "nice, but I usually know where my files are
Plugin 'tpope/vim-surround' "not used to bindings yet; often just do it manually
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
