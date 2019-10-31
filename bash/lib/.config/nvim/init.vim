
" vim-plug
	call plug#begin('~/.config/nvim/plugged')
	" Vim Tools
	Plug 'scrooloose/nerdtree'
	Plug 'junegunn/goyo.vim'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'flazz/vim-colorschemes'
	Plug 'SirVer/ultisnips'
	Plug 'honza/vim-snippets'
	Plug 'vimwiki/vimwiki'
	" Language Tools
	Plug 'leafgarland/typescript-vim'
	Plug 'peitalin/vim-jsx-typescript'
	Plug 'pangloss/vim-javascript'
	Plug 'sheerun/vim-polyglot'
	Plug 'wlangstroth/vim-racket'
	" Formatting
	Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
	call plug#end()

" Plugin Options
	let g:airline_theme='minimalist'
	let g:SuperTabDefaultCompletionType = '<C-n>'
	let g:UltiSnipsExpandTrigger = '<F3>'
	let g:UltiSnipsJumpForwardTrigger = '<F3>'
	let g:UltiSnipsJumpBackwardTrigger = '<s-F3>'
	let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/ultisnips']

	let g:javascript_plugin_jsdoc = 1

	let g:prettier#autoformat = 0
	" autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue,*.yaml,*.html PrettierAsync
	let g:prettier#config#print_width = 80
	let g:prettier#config#tab_width = 2
	let g:prettier#config#use_tabs = 'false'
	let g:prettier#config#semi = 'false'
	let g:prettier#config#single_quote = 'true'
	let g:prettier#config#bracket_spacing = 'true'
	let g:prettier#config#jsx_bracket_same_line = 'false'
	let g:prettier#config#arrow_parens = 'always'
	let g:prettier#config#trailing_comma = 'all'

" Some basics:
	set nocompatible
	filetype plugin on
	syntax on
	let mapleader = ","
	highlight EndOfBuffer ctermfg=black ctermbg=black
	colorscheme darkglass
	autocmd filetype crontab setlocal nobackup nowritebackup

" don't use arrowkeys
	noremap <Up> <NOP>
	noremap <Down> <NOP>
	noremap <Left> <NOP>
	noremap <Right> <NOP>

" really, just don't
	inoremap <Up>    <NOP>
	inoremap <Down>  <NOP>
	inoremap <Left>  <NOP>
	inoremap <Right> <NOP>

" tab sizing
	set tabstop=2
	set shiftwidth=2
	set softtabstop=2

"colorscheme wal
	set encoding=utf-8
	set number
	set relativenumber


" Pandoc compiles
	map <F1> :! md2pdf %<CR>
	map <F2> :! pdflatex %<CR>

" Reset
	map <F4> :! scheme < %<CR>
	map <F5> :noh<CR>

	" setlocal spell! spelllang=en_us

" Spell-check set to F6:
	map <F6> :setlocal spell! spelllang=en_us<CR>
	inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Compile and run c program
	map <F7> :! gcc % -o %.out && chmod +x %.out && ./%.out<CR>

" NERDTree
	let NERDTreeShowHidden=1
	map <silent> <F9> :NERDTreeToggle<CR>

	let g:NERDTreeQuitOnOpen=1

" Goyo plugin makes text more readable when writing prose:
	map <F10> :Goyo<CR>
	inoremap <F10> <esc>:Goyo<CR>a

" Enable autocompletion:
	set wildmode=longest,list,full
	set wildmenu

" Automatically deletes all tralling whitespace on save.
	autocmd BufWritePre * %s/\s\+$//e

" Use urlview to choose and open a url:
	:noremap <leader>u :w<Home>silent <End> !urlview<CR>

" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex
	autocmd BufRead,BufNewFile *.hs set expandtab
	autocmd BufRead,BufNewFile *.pl set filetype=prolog
	autocmd BufRead,BufNewFile *.perl set filetype=perl

" C-T for new tab
	nnoremap <C-t> :tabnew<cr>

" Navigating with guides
	inoremap <leader><leader> <Esc>/<++><Enter>"_c4l
	vnoremap <leader><leader> <Esc>/<++><Enter>"_c4l
	map <leader><leader> <Esc>/<++><Enter>"_c4l
	inoremap ;gui <++>

" For normal mode when in terminals (in X I have caps mapped to esc, this replaces it when I don't have X)
	inoremap jw <Esc>
	inoremap wj <Esc>

"Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

"Replace all is aliased to S. Visual mode shortcut doesn't work yet for some
"reason...
	nnoremap S :%s//g<Left><Left>
	vnoremap S noop
	vnoremap S :s//g<Left><Left>

