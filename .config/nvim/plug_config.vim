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

inoremap <silent><expr> <c-space> coc#refresh()

nnoremap <C-p> :Files<CR>
nnoremap <C-s> :Snippets<CR>
nnoremap <Leader>fa :Rg
nnoremap <Leader>fw :Rg <C-R><C-W><space>

let g:UltiSnipsExpandTrigger = '<F3>'
let g:UltiSnipsJumpForwardTrigger = '<F3>'
let g:UltiSnipsJumpBackwardTrigger = '<s-F3>'
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/ultisnips']

