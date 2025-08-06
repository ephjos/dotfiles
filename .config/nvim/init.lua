
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
    tag = '0.1.4',
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

  -- Buffer managerment
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {'nvim-lua/plenary.nvim'},
    config = function()
      local harpoon = require("harpoon")
      
      harpoon:setup()
      
      vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      
      vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
      vim.keymap.set("n", "<leader>c", function() harpoon:list():clear() end)
      
      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
      vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end)
    end,
  },

  -- Git
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
    end,
  },

  -- Highlighting
  {
    'nvim-treesitter/nvim-treesitter', 
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
  },

  -- Colorscheme
  {
    'rose-pine/neovim',
    name = 'rose-pine',
  },
  {
    'rebelot/kanagawa.nvim',
  },
  {
    'dasupradyumna/midnight.nvim',
  },
  {
    'ellisonleao/gruvbox.nvim',
    lazy=false,
    config = function()
      ApplyColor("gruvbox")
    end,
  },

  --[[
  -- LSP
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {                                      -- Optional
        'williamboman/mason.nvim',
        cmd = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},     -- Required
      {'hrsh7th/cmp-nvim-lsp'}, -- Required
      {'L3MON4D3/LuaSnip'},     -- Required
    },
    config = function()
      local lsp = require('lsp-zero').preset({})
      local lspconfig = require('lspconfig')
      
      local cmp = require('cmp')
      local cmp_action = require('lsp-zero').cmp_action()
      
      lsp.ensure_installed({
        'tsserver',
        'eslint',
        'lua_ls',
        'rust_analyzer',
        'clangd',
      })
      
      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({buffer = bufnr})
        local opts = {buffer = bufnr, remap  = false}
      
        vim.keymap.set("n", "<leader>gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "<leader>gh", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[g", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "]g", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>gr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
      end)
      
      lsp.setup()
      
      cmp.setup({
        mapping = {
          ['<CR>'] = cmp.mapping.confirm({select = false}),
          ['<C-Space>'] = cmp.mapping.complete(),
        }
      })
      
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = {
                'vim',
              },
            },
          },
        },
      })
      
      lspconfig.pyright.setup({
        settings = {
          python = {
            analysis = {
              diagnosticMode = 'openFilesOnly',
            },
          },
        },
      })
    end,
  },
  ]]--

  -- Focus
  {
    'junegunn/goyo.vim',
    config = function()
      vim.keymap.set("n", "<leader>gy", vim.cmd.Goyo)
    end,
  }
})


