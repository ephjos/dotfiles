"
" keys.vim
" configure all vim keybindings
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

" Pandoc compiles
map <F1> :! md2pdf %<CR>
map <F2> :! pdflatex %<CR>

" Reset
map <F5> :noh<CR>

" Spell-check set to F6:
" setlocal spell! spelllang=en_us
map <F6> :setlocal spell! spelllang=en_us<CR>
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Compile and run c program
map <F7> :! gcc % -o %.out && chmod +x %.out && ./%.out<CR>

" Format CSV nicely
map <F9> :!sed 's/","/\&/' | column -t -s '&'<CR>

" Goyo plugin makes text more readable when writing prose:
map <F10> :Goyo<CR>
inoremap <F10> <esc>:Goyo<CR>a

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
      call termopen("/bin/bash", {"detach": 0})
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

