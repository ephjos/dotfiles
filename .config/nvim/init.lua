
-- Helpers
function ApplyColor(color)
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, "LineNR", { bg = "none" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
end

-- Grab personal vim._ config
require("ephjos")

-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- Fuzzy find
  {
    'nvim-telescope/telescope.nvim', 
    version = '*',
    dependencies = {'nvim-lua/plenary.nvim'},
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', function ()
        builtin.find_files({ hidden = true })
      end, {})
      vim.keymap.set('n', '<leader>fa', builtin.git_files, {})
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, {})
      vim.keymap.set('n', '<leader>ss', builtin.live_grep, {})
    end,
  },

  -- Git
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
    end,
  },

  -- Colorscheme
  {
    'ellisonleao/gruvbox.nvim',
    lazy=false,
    config = function()
      ApplyColor("gruvbox")
    end,
  },

  -- Focus
  {
    'junegunn/goyo.vim',
    config = function()
      vim.keymap.set("n", "<leader>gy", vim.cmd.Goyo)
    end,
  },

  -- Highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = {"javascript", "typescript", "python", "c", "lua", "vim", "vimdoc", "query" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        highlight = {
          enable = true,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
      }
    end,
  }
})


