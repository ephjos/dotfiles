"
" Configure plugins
" All plugin settings
"

" Plugin Options

" Include preview in :Files
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
" Include preview and hidden files in :Rg
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

nnoremap <C-p> :Files<CR>
nnoremap <C-s> :Snippets<CR>
nnoremap <Leader>fa :Rg
nnoremap <Leader>fw :Rg <C-R><C-W><space>

let g:UltiSnipsExpandTrigger = '<F3>'
let g:UltiSnipsJumpForwardTrigger = '<F3>'
let g:UltiSnipsJumpBackwardTrigger = '<s-F3>'
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/ultisnips']

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

