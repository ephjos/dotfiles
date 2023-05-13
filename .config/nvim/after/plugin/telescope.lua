local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fa', builtin.git_files, {})
vim.keymap.set('n', '<leader>ss', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
