"
" General Config
" Tweak vim settings
"

" Some basics:
set nocompatible
filetype plugin on
syntax on
highlight EndOfBuffer ctermfg=black ctermbg=black
colorscheme darkglass
autocmd filetype crontab setlocal nobackup nowritebackup

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set encoding=utf-8
set path+=**
set wildmenu
"set wildignore+=**/node_modules/**,**/dist/**,**_site/**,*.swp,*.png,*.jpg,*.gif,*.webp,*.jpeg,*.map
set clipboard=unnamedplus
set number relativenumber
set list
"set listchars=tab:→→,eol:¬,space:.
set listchars=tab:→→,space:.
set hidden
set nrformats=
set hlsearch
set smartcase
set incsearch
set noswapfile
set nobackup
set nowritebackup
set updatetime=300

hi NonText ctermfg=DarkGrey guifg=#4a4a59
hi SpecialKey ctermfg=DarkGrey guifg=#4a4a59

" Automatically deletes all tralling whitespace on save.
autocmd BufWritePre * %s/\s\+$//e

" Ensure files are read as what I want:
let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile *.tex set filetype=tex
autocmd BufRead,BufNewFile *.hs set expandtab
autocmd BufRead,BufNewFile *.pl set filetype=prolog
autocmd BufRead,BufNewFile *.perl set filetype=perl

" Skeleton Template Setup
"if has("autocmd")
"augroup templates
"autocmd BufNewFile *.sh 0r ~/.vim/templates/skeleton.sh
"augroup END
"endif

