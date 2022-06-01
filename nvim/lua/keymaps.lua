
-- Ctrl jump between buffers
vim.keymap.set('n', '<C-j>', '<cmd>bnext<CR>', { noremap = true})
vim.keymap.set('n', '<C-k>', '<cmd>bprevious<CR>', { noremap = true})

vim.keymap.set('n', '<Tab>', '<cmd>bnext<CR>', { noremap = true})
vim.keymap.set('n', '<S-Tab>', '<cmd>bprevious<CR>', { noremap = true})

vim.keymap.set('n', 'Y', 'yg$', { noremap = true})

-- Find files using Telescope command-line sugar.
vim.keymap.set('n', 'ff', '<cmd>Telescope find_files<CR>', { noremap = true})
vim.keymap.set('n', 'fg', '<cmd>Telescope live_grep<CR>', { noremap = true})
vim.keymap.set('n', 'fb', '<cmd>Telescope buffers<CR>', { noremap = true})
vim.keymap.set('n', 'fh', '<cmd>Telescope help_tags<CR>', { noremap = true})

-- keep cursor in place when searching and line concat actions
vim.keymap.set('n', 'z', 'nzzzv', { noremap = true})
vim.keymap.set('n', 'Z', 'Nzzzv', { noremap = true})
vim.keymap.set('n', 'J', 'mzJ`z', { noremap = true})

-- shifting lines
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true})
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true})
vim.keymap.set('i', '<C-j>', '<esc>:m .+1<CR>==i', { noremap = true})
vim.keymap.set('i', '<C-k>', '<esc>:m .-2<CR>==i', { noremap = true})
vim.keymap.set('n', '<leader>j', ':m .+1<CR>==', { noremap = true})
vim.keymap.set('n', '<leader>k', ':m .-2<CR>==', { noremap = true})

-- better i-mode escape
vim.keymap.set('i', 'jj', '<ESC>', { noremap = true})
vim.keymap.set('v', 'jj', '<ESC>', { noremap = true})

-- safe close buffer
vim.keymap.set('n', '<leader>q', '<cmd>BW :bn|:bd#<CR>', { noremap = true, silent = true})

-- quick format
vim.keymap.set('n', '<leader>f', '<cmd>Neoformat prettier<CR>', { noremap = true})

-- toggle map
vim.keymap.set('n', '<leader>m', '<cmd>NvimTreeToggle<CR>', { noremap = true})

-- jump through quickfix list
vim.keymap.set('n', '<leader>.', '<cmd>cnext<CR>', { noremap = true})
vim.keymap.set('n', '<leader>,', '<cmd>cprevious<CR>', { noremap = true})

vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("<CR>")', { noremap = true, silent = true, expr = true, script = true})

vim.keymap.set({"n","v","i"}, ';', ':', { noremap = true})
vim.keymap.set({"n","v","i"}, ';;', ';', { noremap = true})

