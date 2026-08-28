
-- Helpers
function ApplyColor(color)
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, "LineNR", { bg = "none" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
end

--
-- :remap
--
vim.g.mapleader = " "

-- Temporary Autocmds
vim.keymap.set("n", "<leader>r", function()
  vim.ui.input({ prompt = "Enter make command: " }, function(command)
    if not command or command == "" then
      return
    end

    vim.opt.makeprg = command
    vim.cmd.make()
  end)
end, {
  desc = "Set makeprg and run make",
})
vim.keymap.set("n", "<CR>", function() vim.cmd.make() end, {
  desc = "Run make",
})

-- Substitutions
vim.keymap.set("n", "S", ':%s//g<Left><Left>')
vim.keymap.set("v", "S", ':s//g<Left><Left>')

-- Spellcheck
vim.keymap.set("n", "<F6>", ':setlocal spell! spelllang=en_us<CR>')

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

--
-- :set
--
vim.opt.backupcopy="yes"
vim.opt.background="dark"
vim.opt.clipboard="unnamedplus"
vim.opt.colorcolumn="80"
vim.opt.encoding="utf-8"
vim.opt.errorbells=false
vim.opt.errorbells=true
vim.opt.expandtab=true
vim.opt.expandtab=true
vim.opt.guicursor=""
vim.opt.hidden=true
vim.opt.hlsearch=false
vim.opt.hlsearch=true
vim.opt.incsearch=true
vim.opt.incsearch=true
vim.opt.linebreak=true
vim.opt.list=true
vim.opt.listchars="tab:>-"
vim.opt.mouse="i"
vim.opt.nrformats=""
vim.opt.number=true
vim.opt.relativenumber=true
vim.opt.scrolloff=8
vim.opt.shiftwidth=2
vim.opt.showmode=false
vim.opt.smartcase=true
vim.opt.smartindent=true
vim.opt.softtabstop=2
vim.opt.swapfile=false
vim.opt.tabstop=2
vim.opt.termguicolors=false
vim.opt.undodir="/tmp/vim_undos_" .. os.getenv("USER")
vim.opt.undofile=true
vim.opt.wildmenu=true
vim.opt.wrap=false

--
-- :plugins
--
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
        builtin.find_files()
      end, {})
      vim.keymap.set('n', '<leader>fa', function ()
        builtin.find_files({ no_ignore = true, hidden = true })
      end, {})
      vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
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
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup({
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
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  }
})


