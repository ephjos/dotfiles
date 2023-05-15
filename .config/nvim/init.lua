local fn = vim.fn

-- Automatically install packer
-- https://www.reddit.com/r/neovim/comments/tzwsjs/comment/i42dwpf/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer, close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])

  local packer_lua = fn.stdpath("config") .. '/lua/ephjos/packer.lua'
  print("Sourcing " .. packer_lua)
  vim.cmd('source ' .. packer_lua)

  print("Running PackerSync")
  vim.cmd('PackerSync')
end

require("ephjos")

