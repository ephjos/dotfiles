"
" Vim Plug
" All vim-plug imports
"

" vim-plug
call plug#begin('~/.config/nvim/plugged')
" Vim Tools
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'flazz/vim-colorschemes'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'vimwiki/vimwiki'

" Language Tools
"Plug 'ludovicchabant/vim-gutentags'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

