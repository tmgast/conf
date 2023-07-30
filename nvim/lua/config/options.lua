local opt = vim.opt
local g = vim.g

opt.laststatus = 0
opt.re = 0
opt.colorcolumn = "80,120"
opt.completeopt = "menu,menuone,noselect"
opt.syn = "on"
opt.background = "dark"

g.rustfmt_autosave = 1
g.copilot_no_tab_map = true
