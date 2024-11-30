local opt = vim.opt
local g = vim.g

opt.laststatus = 3
opt.re = 0
opt.colorcolumn = "80,120"
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 6
opt.pumwidth = 20
opt.syn = "on"
opt.background = "dark"

g.rustfmt_autosave = 1
g.copilot_no_tab_map = true
g.autoformat = true
g.tree_sitter_highlight = { enable = true }
