-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
require("plenary.filetype").add_file("javascript")

-- set filetype "docker-compose.yml" to yaml.docker-compose
vim.api.nvim_create_autocmd({
  "BufRead",
  "BufNewFile",
}, {
  pattern = "docker-compose.yml",
  command = "set filetype=yaml.docker-compose",
})
