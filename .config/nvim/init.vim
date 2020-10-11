"
" Joe Hines
" 2020
"

"
" init
"

let mapleader = " "

" On first run, install plug and packages
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    source ~/.vimrc
    autocmd VimEnter * PlugInstall
endif

" For Neovim 0.1.3 and 0.1.4 - https://github.com/neovim/neovim/pull/2198
if (has('nvim'))
    let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
    if empty(glob('~/.config/coc/extensions/node_modules'))
        autocmd VimEnter * CocInstall coc-tsserver coc-json coc-python coc-clangd coc-html coc-css
    endif
endif

" For Neovim > 0.1.5 and Vim > patch 7.4.1799 - https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162
" Based on Vim patch 7.4.1770 (`guicolors` option) - https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd
" https://github.com/neovim/neovim/wiki/Following-HEAD#20160511
if (has('termguicolors'))
    set termguicolors
endif


"
" vim-plug
"
call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.config/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'morhetz/gruvbox'
Plug 'tomasiser/vim-code-dark'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'sheerun/vim-polyglot'
call plug#end()


"
" vim-plug config
"
" Include preview in :Files
command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
" Include preview and hidden files in :Rg
command! -bang -nargs=* Rg
            \ call fzf#vim#grep(
            \   'rg --hidden --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
            \   fzf#vim#with_preview(), <bang>0)

let g:coc_disable_startup_warning = 1

inoremap <silent><expr> <c-space> coc#refresh()

nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gr <Plug>(coc-references)

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<Tab>" :
            \ coc#refresh()

" use <c-space>for trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"


let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'
nnoremap <leader>gf :GitFiles<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>cs :CocSearch
nnoremap <leader>csw :CocSearch <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>rg :Rg<CR>
nnoremap <leader>rgw :Rg <C-R>=expand("<cword>")<CR><CR>

let g:UltiSnipsExpandTrigger = '<F3>'
let g:UltiSnipsJumpForwardTrigger = '<F3>'
let g:UltiSnipsJumpBackwardTrigger = '<s-F3>'
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/ultisnips']

set autowrite
let g:go_version_warning = 0
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

"
" config
"
filetype plugin on
syntax on

set t_Co=256
set t_ut=
colorscheme gruvbox
set background=dark

autocmd filetype crontab setlocal nobackup nowritebackup

set noerrorbells
set nohlsearch
set guicursor=
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
set incsearch
set noswapfile
set nobackup
set undodir=/tmp/undodir
set undofile
set incsearch
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set smartcase
set nu
set nowrap
set scrolloff=8
set noshowmode
set colorcolumn=80
set textwidth=80
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
" autocmd BufRead,BufNewFile *.c,*.h,*.go set noexpandtab
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
        autocmd BufNewFile *.mom 0r ~/.vim/templates/skeleton.mom
    augroup END
endif

"
" keys
"
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

" Spell-check set to F6:
" setlocal spell! spelllang=en_us
map <F6> :setlocal spell! spelllang=en_us<CR>
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" C-T for new tab
nnoremap <C-t> :tabnew<cr>

" Navigating with guides
vnoremap <leader>ng <Esc>/<++><Enter>"_c4l
nnoremap <leader>ng <Esc>/<++><Enter>"_c4l

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Replace all is aliased to S.
nnoremap S :%s//g<Left><Left>
vnoremap S noop
vnoremap S :s//g<Left><Left>
nnoremap <leader>S :%s/<C-R>=expand("<cword>")<CR>//g<Left><Left>

" Clear highlight when pressing enter
nnoremap <silent> <ESC> :noh<CR><CR>

command WQ wq
command Wq wq
command W w
command Q q


