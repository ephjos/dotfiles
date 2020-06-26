"
" Vim Plug
" All vim-plug imports
"

" vim-plug
call plug#begin('~/.config/nvim/plugged')
" Vim Tools
Plug 'junegunn/goyo.vim'
Plug 'junegunn/fzf', { 'dir': '~/.config/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

"Plug 'franbach/miramare'
"Plug 'morhetz/gruvbox'
Plug 'kaicataldo/material.vim'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Language Tools
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
call plug#end()

