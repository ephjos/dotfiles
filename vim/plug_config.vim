"
" Configure plugins
" All plugin settings
"

" Plugin Options
" format with goimports instead of gofmt
nnoremap <C-p> :Files<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>h :History<CR>

nnoremap <Leader>t :BTags<CR>
nnoremap <Leader>T :Tags<CR>

let g:gutentags_cache_dir = expand('/tmp/.cache/vim/ctags/')
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_exclude_filetypes=[
      \ 'css',
      \ 'json',
      \ 'vim',
      \ 'vimwiki',
      \ 'tex',
      \ 'pdf',
      \ 'markdown',
      \]
let g:gutentags_exclude=[
      \ '*.css',
      \ '*.json',
      \ '*.*rc*',
      \]
let g:gutentags_ctags_extra_args=[
      \ '--langmap=javascript:.js.es6.es.jsx',
      \ '--langmap=typescript:.ts.es6.es.tsx',
      \ '--javascript-kinds=-c-f-m-p-v',
      \]
set statusline+=%{gutentags#statusline()}

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

let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1

" Automatically import packages on save
let g:go_fmt_command = "goimports"
let g:go_def_mode='godef'

" Prevent errors from opening the location list
let g:go_fmt_fail_silently = 1

" Automatically get signature/type info for object under cursor
let g:go_auto_type_info = 1

" Open local documentation
let g:go_doc_url = 'http://localhost:6060'

