function ApplyColor(color)
  color = color or "midnight"
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, "LineNR", { bg = "none" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
end

ApplyColor()
