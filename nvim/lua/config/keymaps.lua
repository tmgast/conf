-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys

  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

map("n", "<Tab>", "<cmd>bnext<cr>")
map("n", "<S-Tab>", "<cmd>bprevious<cr>")
map({ "i", "v" }, "jj", "<ESC>", { desc = "jj escape" })

map("n", "<leader>.", "<cmd>cnext<cr>", { desc = "QF List: next" })
map("n", "<leader>,", "<cmd>cprevious<cr>", { desc = "QF List: previous" })

map("n", "E", vim.diagnostic.open_float)
map("n", "e.", vim.diagnostic.goto_next)
map("n", "e,", vim.diagnostic.goto_prev)
map("n", "<leader>r", vim.lsp.buf.rename)

map("n", "<C-s>", "<cmd>T2CAddSaturation -0.1<cr>")
map("n", "<C-w>", "<cmd>T2CAddSaturation 0.1<cr>")
map("n", "<C-a>", "<cmd>T2CAddContrast -0.1<cr>")
map("n", "<C-d>", "<cmd>T2CAddContrast 0.1<cr>")
map("n", "<C-e>", "<cmd>T2CShuffleAccents<cr>")
map("n", "<C-C>", ":T2CGenerate ")
