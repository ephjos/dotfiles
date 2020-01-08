
	let mapleader = ","

	" On first run, install plug and packages
	if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
		echo "Downloading junegunn/vim-plug to manage plugins..."
		silent !mkdir -p ~/.config/nvim/autoload/
		silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
		autocmd VimEnter * PlugInstall
	endif

  " vim-plug
	call plug#begin('~/.config/nvim/plugged')
	" Vim Tools
	" Plug 'scrooloose/nerdtree'
	Plug 'junegunn/goyo.vim'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'ludovicchabant/vim-gutentags'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'flazz/vim-colorschemes'
	Plug 'SirVer/ultisnips'
	Plug 'honza/vim-snippets'
	Plug 'vimwiki/vimwiki'

	" Language Tools
	Plug 'sheerun/vim-polyglot'
  Plug 'dense-analysis/ale'
	Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
	call plug#end()

" Plugin Options
" format with goimports instead of gofmt
  nnoremap <C-p> :Files<CR>
  nnoremap <Leader>b :Buffers<CR>
  nnoremap <Leader>h :History<CR>

  nnoremap <Leader>t :BTags<CR>
  nnoremap <Leader>T :Tags<CR>
  let g:gutentags_cache_dir = expand('/tmp/.cache/vim/ctags/')
  "set tags+='/tmp/.cache/vim/ctags/'
  let g:gutentags_generate_on_new = 1
  let g:gutentags_generate_on_missing = 1
  let g:gutentags_generate_on_write = 1
  let g:gutentags_generate_on_empty_buffer = 0
  let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ '*/tests/*',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '.*rc',
      \ '*rc',
      \ '.*profile*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]


	let g:airline_theme='minimalist'

	let g:UltiSnipsExpandTrigger = '<F3>'
	let g:UltiSnipsJumpForwardTrigger = '<F3>'
	let g:UltiSnipsJumpBackwardTrigger = '<s-F3>'
	let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/ultisnips']

  nmap <silent> [c <Plug>(ale_previous_wrap)
  nmap <silent> ]c <Plug>(ale_next_wrap)

  let g:ale_sign_error = '❌'
  let g:ale_sign_warning = '⚠️'
  let g:ale_fixers = {
  \ 'javascript': ['prettier'],
  \ 'javascriptreact': ['prettier'],
  \ 'typescript': ['prettier'],
  \ 'typescriptreact': ['prettier'],
  \}
  let g:ale_fix_on_save = 1

	let g:go_fmt_command = "goimports"
	let g:go_auto_type_info = 1
	let g:go_def_mode='godef'

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
	set number
	set relativenumber

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

" Goyo plugin makes text more readable when writing prose:
	map <F10> :Goyo<CR>
	inoremap <F10> <esc>:Goyo<CR>a

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

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Replace all is aliased to S. Visual mode shortcut doesn't work yet for some
" reason...
	nnoremap S :%s//g<Left><Left>
	vnoremap S noop
	vnoremap S :s//g<Left><Left>

	" Terminal Function
	let g:term_buf = 0
	let g:term_win = 0
	function! TermToggle(height)
			if win_gotoid(g:term_win)
					hide
			else
					botright new
					exec "resize " . a:height
					try
							exec "buffer " . g:term_buf
					catch
							call termopen($SHELL, {"detach": 0})
							let g:term_buf = bufnr("")
							set nonumber
							set norelativenumber
							set signcolumn=no
					endtry
					startinsert!
					let g:term_win = win_getid()
			endif
	endfunction

	" Toggle terminal on/off (neovim)
	nnoremap <A-t> :call TermToggle(12)<CR>
	inoremap <A-t> <Esc>:call TermToggle(12)<CR>
	tnoremap <A-t> <C-\><C-n>:call TermToggle(12)<CR>

	" Terminal go back to normal mode
	tnoremap <Esc> <C-\><C-n>
	tnoremap :q! <C-\><C-n>:q!<CR>

