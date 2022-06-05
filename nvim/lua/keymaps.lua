-- Ctrl jump between buffers
vim.keymap.set('n', '<C-j>', '<cmd>bnext<CR>', { noremap = true })
vim.keymap.set('n', '<C-k>', '<cmd>bprevious<CR>', { noremap = true })

vim.keymap.set('n', '<Tab>', '<cmd>bnext<CR>', { noremap = true })
vim.keymap.set('n', '<S-Tab>', '<cmd>bprevious<CR>', { noremap = true })

vim.keymap.set('n', 'Y', 'yg$', { noremap = true })

-- keep cursor in place when searching and line concat actions
vim.keymap.set('n', 'z', 'nzzzv', { noremap = true })
vim.keymap.set('n', 'Z', 'Nzzzv', { noremap = true })
vim.keymap.set('n', 'J', 'mzJ`z', { noremap = true })

-- shifting lines
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true })
vim.keymap.set('i', '<C-j>', '<esc>:m .+1<CR>==i', { noremap = true })
vim.keymap.set('i', '<C-k>', '<esc>:m .-2<CR>==i', { noremap = true })
vim.keymap.set('n', '<leader>j', ':m .+1<CR>==', { noremap = true })
vim.keymap.set('n', '<leader>k', ':m .-2<CR>==', { noremap = true })

-- quick delete inside
vim.keymap.set('n', '<leader>d', 'di(', { noremap = true })
vim.keymap.set('n', '<leader>D', 'di{', { noremap = true })

-- better i-mode escape
vim.keymap.set('i', 'jj', '<ESC>', { noremap = true })
vim.keymap.set('v', 'jj', '<ESC>', { noremap = true })

-- safe close buffer
vim.keymap.set('n', '<leader>q', '<cmd>BW :bn|:bd#<CR>', { noremap = true, silent = true })

-- quick format
vim.keymap.set('n', '<leader>f', '<cmd>Neoformat prettier<CR>', { noremap = true })

-- toggle map
vim.keymap.set('n', '<leader>m', '<cmd>NvimTreeToggle<CR>', { noremap = true })

-- jump through quickfix list
vim.keymap.set('n', '<leader>.', '<cmd>cnext<CR>', { noremap = true })
vim.keymap.set('n', '<leader>,', '<cmd>cprevious<CR>', { noremap = true })

vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("<CR>")', { noremap = true, silent = true, expr = true, script = true })

vim.keymap.set({"n","v","i"}, ';', ':', { noremap = true })
vim.keymap.set({"n","v","i"}, ';;', ';', { noremap = true })

-- Find files using Telescope command-line sugar.
vim.keymap.set('n', 'ff', '<cmd>Telescope find_files<CR>', { noremap = true })
vim.keymap.set('n', 'fg', '<cmd>Telescope live_grep<CR>', { noremap = true })
vim.keymap.set('n', 'fd', '<cmd>Telescope lsp_document_symbols<CR>', { noremap = true })
vim.keymap.set('n', 'fb', '<cmd>Telescope buffers<CR>', { noremap = true })
vim.keymap.set('n', 'fh', '<cmd>Telescope help_tags<CR>', { noremap = true })
vim.keymap.set('n', 'E', '<cmd>Telescope diagnostics theme=ivy<CR>', { noremap = true })

local M = {}

function M.lsp_bindings(client)
	vim.keymap.set('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
	vim.keymap.set('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
	vim.keymap.set('n','K','<cmd>lua vim.lsp.buf.hover()<CR>')
	vim.keymap.set('n','gr','<cmd>lua vim.lsp.buf.references()<CR>')
	vim.keymap.set('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>')
	vim.keymap.set('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
	vim.keymap.set('n','gt','<cmd>lua vim.lsp.buf.type_definition()<CR>')
	vim.keymap.set('n','<leader>gw','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
	vim.keymap.set('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
	vim.keymap.set('n','<leader>ah','<cmd>lua vim.lsp.buf.hover()<CR>')
	vim.keymap.set('n','<leader>af','<cmd>lua vim.lsp.buf.code_action()<CR>')
	vim.keymap.set('n','<leader>ee','<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>')
	vim.keymap.set('n','<leader>ar','<cmd>lua vim.lsp.buf.rename()<CR>')
	vim.keymap.set('n','<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
	vim.keymap.set('n','<leader>ai','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
	vim.keymap.set('n','<leader>ao','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
  vim.keymap.set('n', 'e.', vim.diagnostic.goto_next, { buffer = 0 })
  vim.keymap.set('n', 'e,', vim.diagnostic.goto_prev, { buffer = 0 })
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { buffer = 0 })
end

return M
