local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', function ()
  builtin.find_files({ hidden = true })
end, {})
vim.keymap.set('n', '<leader>fa', builtin.git_files, {})
vim.keymap.set('n', '<leader>sw', builtin.grep_string, {})
vim.keymap.set('n', '<leader>ss', builtin.live_grep, {})

