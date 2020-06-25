"
" Joe Hines
" 2020
"

" On first run, install plug and packages
if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
  augroup install_group
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !mkdir -p ~/.config/nvim/autoload/
    silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
    autocmd VimEnter * PlugInstall

    echo "Downloading coc plugins..."
    autocmd VimEnter * CocInstall coc-tsserver coc-json coc-go coc-python coc-clangd coc-html coc-css
  augroup END
endif

" For Neovim 0.1.3 and 0.1.4 - https://github.com/neovim/neovim/pull/2198
if (has('nvim'))
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

" For Neovim > 0.1.5 and Vim > patch 7.4.1799 - https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162
" Based on Vim patch 7.4.1770 (`guicolors` option) - https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd
" https://github.com/neovim/neovim/wiki/Following-HEAD#20160511
if (has('termguicolors'))
  set termguicolors
endif

source $HOME/.config/nvim/plug.vim
source $HOME/.config/nvim/plug_config.vim
source $HOME/.config/nvim/config.vim
source $HOME/.config/nvim/keys.vim




