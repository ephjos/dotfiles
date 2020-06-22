"
" Joe Hines
" 2020
"

" On first run, install plug and packages
if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
  echo "Downloading junegunn/vim-plug to manage plugins..."
  silent !mkdir -p ~/.config/nvim/autoload/
  silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
  autocmd VimEnter * PlugInstall
endif

" Check if Coc Plugins are installed
" and install them if not
if ! filereadable(expand('~/.config/coc/extensions/package.json'))
  echo "Downloading coc plugins..."
  autocmd VimEnter * CocInstall coc-tsserver coc-json coc-go coc-python coc-clangd
endif

source $HOME/.config/nvim/plug.vim
source $HOME/.config/nvim/plug_config.vim
source $HOME/.config/nvim/config.vim
source $HOME/.config/nvim/keys.vim




