"
" General Config
" Tweak vim settings
"

" Some basics:
set nocompatible
filetype plugin on
syntax on

"let g:material_terminal_italics = 1
"let g:material_theme_style = 'palenight'
"colorscheme material

set t_Co=256
set t_ut=
colorscheme codedark

"set background=dark
"highlight EndOfBuffer ctermfg=black ctermbg=black
autocmd filetype crontab setlocal nobackup nowritebackup

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set encoding=utf-8
set path+=**
set wildmenu
set clipboard=unnamedplus
set number relativenumber
set list
set listchars=tab:→→
set hidden
set nrformats=
set hlsearch
set smartcase
set incsearch
set nobackup
set nowritebackup
set updatetime=300

hi NonText ctermfg=DarkGrey guifg=#4a4a59
hi SpecialKey ctermfg=DarkGrey guifg=#4a4a59

" Automatically deletes all tralling whitespace on save.
autocmd BufWritePre * %s/\s\+$//e

" Fix highlighting
autocmd BufEnter * :syntax sync fromstart

" Ensure files are read as what I want:
let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile *.tex set filetype=tex
autocmd BufRead,BufNewFile *.hs set expandtab
autocmd BufRead,BufNewFile *.pl set filetype=prolog
autocmd BufRead,BufNewFile *.perl set filetype=perl
autocmd BufRead,BufNewFile dockerfile set filetype=Dockerfile
autocmd BufRead,BufNewFile *.c,*.h,*.go set noexpandtab
autocmd BufRead,BufNewFile *.b set filetype=c
autocmd BufRead,BufNewFile *.sent set filetype=markdown

" Skeleton Template Setup
if has("autocmd")
  augroup templates
    autocmd BufNewFile *.sh 0r ~/.vim/templates/skeleton.sh
    autocmd BufNewFile *.hs 0r ~/.vim/templates/skeleton.hs
    autocmd BufNewFile *.json 0r ~/.vim/templates/skeleton.json
    autocmd BufNewFile *.py 0r ~/.vim/templates/skeleton.py
    autocmd BufNewFile *.go 0r ~/.vim/templates/skeleton.go
    autocmd BufNewFile *.tex 0r ~/.vim/templates/skeleton.tex
  augroup END
endif

