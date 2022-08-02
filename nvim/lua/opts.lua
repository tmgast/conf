vim.o.t_Co = 256
vim.o.termguicolors = true
vim.o.laststatus = 3
vim.o.re=0
vim.g.loaded_perl_provider = 0
vim.o.exrc = true
vim.o.errorbells = false
vim.o.visualbell = false
vim.o.swapfile = false
vim.o.backup = false
vim.o.scrolloff = 8
vim.o.hidden = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.shiftround = true
vim.o.nu = true
vim.o.wrap = false
vim.o.smartcase = true
vim.cmd 'set mouse=a'
vim.o.shell = '/bin/zsh'
vim.o.spell = true
vim.o.cursorline = true
vim.o.colorcolumn = "80,120"
vim.o.wildignore = "*/node_modules,coverage,*/dist"
vim.g.mapleader = " "
vim.o.completeopt = "menu,menuone,noselect"

vim.g.rustfmt_autosave = 1

vim.g.copilot_no_tab_map = true

vim.cmd([[
if(exists('+termguicolors'))
  let &t_8f = "<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "<Esc>[48;2;%lu;%lu;%lum"
endif

autocmd BufEnter * syntax sync minlines=4000

let g:python3_host_prog="/usr/bin/python3"
]])

vim.cmd([[colorscheme yokai]])
