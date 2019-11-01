"        _                       _
" __   _(_)_ __ ___        _ __ | |_   _  __ _
" \ \ / / | '_ ` _ \ _____| '_ \| | | | |/ _` |
"  \ V /| | | | | | |_____| |_) | | |_| | (_| |
"   \_/ |_|_| |_| |_|     | .__/|_|\__,_|\__, |
"                         |_|            |___/

" Keep Plugin commands between plug#begin/end.
"  ____  _             _
" |  _ \| |_   _  __ _(_)_ __  ___ 
" | |_) | | | | |/ _` | | '_ \/ __|
" |  __/| | |_| | (_| | | | | \__ \
" |_|   |_|\__,_|\__, |_|_| |_|___/
"                |___/
set nocompatible " be iMproved, required

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'         " dep for airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sheerun/vim-polyglot'
Plug 'StanAngeloff/php.vim'       " PHP Syntax
Plug 'scrooloose/nerdtree'
Plug 'flazz/vim-colorschemes'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-surround'
Plug 'scrooloose/syntastic'
Plug 'vim-scripts/Align'
Plug 'evidens/vim-twig'
Plug 'ap/vim-css-color'
Plug 'sjl/gundo.vim'
Plug 'mileszs/ack.vim'
Plug 'ajh17/VimCompletesMe'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'sbdchd/vim-shebang'
Plug 'vimwiki/vimwiki'
Plug 'drmikehenry/vim-fontsize'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'vim-scripts/EnhCommentify.vim' " dependency for my figlet script

Plug 'pearofducks/ansible-vim'

"if v:version > 704
"	Plug 'ludovicchabant/vim-gutentags'
"endif

call plug#end()
