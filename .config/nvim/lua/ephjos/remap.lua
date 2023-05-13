vim.g.mapleader = " "

-- Temporary Autocmds
vim.keymap.set("n", "<C-r>", ":autocmd BufWritePost * !")

-- Substitutions
vim.keymap.set("n", "S", ':%s//g<Left><Left>')
vim.keymap.set("v", "S", ':s//g<Left><Left>')

-- Spellcheck
--vim.keymap.set("n", "<F6>", ':setlocal spell! spelllang=en_us<CR>')
--vim.keymap.set("i", "<C-l>", 'c-g>u<Esc>[s1z=`]a<c-g>u')

-- Clear highlight on ESC
vim.keymap.set("n", "<ESC>", ":noh<CR>", { silent = true })

-- No arrow keys
vim.keymap.set("n", "<Up>", "<NOP>")
vim.keymap.set("n", "<Down>", "<NOP>")
vim.keymap.set("n", "<Left>", "<NOP>")
vim.keymap.set("n", "<Right>", "<NOP>")
vim.keymap.set("i", "<Up>", "<NOP>")
vim.keymap.set("i", "<Down>", "<NOP>")
vim.keymap.set("i", "<Left>", "<NOP>")
vim.keymap.set("i", "<Right>", "<NOP>")

-- Quick switch between panes
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-k>", "<C-w>l")

