
" vim-plug
	call plug#begin('~/.config/nvim/plugged')
	Plug 'scrooloose/nerdtree'
	Plug 'junegunn/goyo.vim'
	Plug 'leafgarland/typescript-vim'
	Plug 'peitalin/vim-jsx-typescript'
	call plug#end()

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

" Some basics:
	set nocompatible
	filetype plugin on
	syntax on

"colorscheme wal
	set encoding=utf-8
	set number
	set relativenumber

" Push F2 to add one &nbsp;
	map <F2> :r! echo "&nbsp;" && echo<CR>

" Push F3 to make md friendly paragraph indent
	map <F3> :r! space_indent<CR>

" Spell-check set to F6:
	map <F6> :setlocal spell! spelllang=en_us,es<CR>

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

" C-T for new tab
	nnoremap <C-t> :tabnew<cr>

" Navigating with guides
	inoremap <Space><Tab> <Esc>/<++><Enter>"_c4l
	vnoremap <Space><Tab> <Esc>/<++><Enter>"_c4l
	map <Space><Tab> <Esc>/<++><Enter>"_c4l
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

