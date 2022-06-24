local silent = { silent = true }

-- Ctrl jump between buffers
vim.keymap.set('n', '<C-j>', '<cmd>bnext<CR>')
vim.keymap.set('n', '<C-k>', '<cmd>bprevious<CR>')

vim.keymap.set('n', '<Tab>', '<cmd>bnext<CR>')
vim.keymap.set('n', '<S-Tab>', '<cmd>bprevious<CR>')

vim.keymap.set('n', 'Y', 'yg$')

-- keep cursor in place when searching and line concat actions
vim.keymap.set('n', 'z', 'nzzzv')
vim.keymap.set('n', 'Z', 'Nzzzv')
vim.keymap.set('n', 'J', 'mzJ`z')

-- shifting lines
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('i', '<C-j>', '<esc>:m .+1<CR>==i')
vim.keymap.set('i', '<C-k>', '<esc>:m .-2<CR>==i')
vim.keymap.set('n', '<leader>j', ':m .+1<CR>==')
vim.keymap.set('n', '<leader>k', ':m .-2<CR>==')

-- quick delete inside
vim.keymap.set('n', '<leader>d', 'di(')
vim.keymap.set('n', '<leader>D', 'di{')

-- better i-mode escape
vim.keymap.set('i', 'jj', '<ESC>')
vim.keymap.set('v', 'jj', '<ESC>')

-- safe close buffer
vim.keymap.set('n', '<leader>q', '<cmd>BW :bn|:bd#<CR>', silent )

-- Git
vim.keymap.set('n', '<leader>ga', '<cmd>Git add -A<CR>')
vim.keymap.set('n', '<leader>gc', '<cmd>Git commit<CR>')
vim.keymap.set('n', '<leader>gp', '<cmd>Git push<CR>')
vim.keymap.set('n', '<leader>gu', '<cmd>Git pull<CR>')
vim.keymap.set('n', '<leader>gs', '<cmd>Git status<CR>')
vim.keymap.set('n', '<leader>gb', '<cmd>Gitsigns toggle_current_line_blame<CR>')

-- toggle map
vim.keymap.set('n', '<leader>m', '<cmd>NvimTreeToggle<CR>')

-- formatter
vim.keymap.set('n', '<leader>f', '<cmd>Prettier<CR>')

-- jump through quickfix list
vim.keymap.set('n', '<leader>.', '<cmd>cnext<CR>')
vim.keymap.set('n', '<leader>,', '<cmd>cprevious<CR>')

vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("<CR>")', { silent = true, expr = true, script = true })

vim.keymap.set({"n","v","i"}, ';', ':')
vim.keymap.set({"n","v","i"}, ';;', ';')

-- Find files using Telescope command-line sugar.
vim.keymap.set('n', 'ff', '<cmd>Telescope find_files<CR>')
vim.keymap.set('n', 'fg', '<cmd>Telescope live_grep<CR>')
vim.keymap.set('n', 'fd', '<cmd>Telescope lsp_document_symbols<CR>')
vim.keymap.set('n', 'fb', '<cmd>Telescope buffers<CR>')
vim.keymap.set('n', 'fh', '<cmd>Telescope help_tags<CR>')
vim.keymap.set('n', 'E', '<cmd>Telescope diagnostics theme=ivy<CR>')

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
  vim.keymap.set('n', 'e', vim.lsp.diagnostic.show_line_diagnostics, { buffer = 0 })
  vim.keymap.set('n', 'e.', vim.lsp.diagnostic.goto_next, { buffer = 0 })
  vim.keymap.set('n', 'e,', vim.lsp.diagnostic.goto_prev, { buffer = 0 })
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { buffer = 0 })

  -- remap to open the Telescope refactoring menu in visual mode
  vim.keymap.set('v', '<leader>r', require('telescope').extensions.refactoring.refactors)
end

function M.debug_bindings(client)
end

vim.keymap.set('i', '~', '<Cmd>call copilot#Next()<CR>', silent)

vim.keymap.set('n', '<leader>dc', require'dap'.continue, silent )
vim.keymap.set('n', '<C-/>', require'dap'.step_over, silent )
vim.keymap.set('n', '<C-.>', require'dap'.step_into, silent )
vim.keymap.set('n', '<C-.>', require'dap'.step_back, silent )
vim.keymap.set('n', '<C-,>', require'dap'.step_out, silent )
vim.keymap.set('n', '<Leader>b', require'dap'.toggle_breakpoint, silent )
vim.keymap.set('n', '<Leader>B', "<Cmd> lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", silent )
vim.keymap.set('n', '<Leader>lp', "<Cmd> lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", silent )
vim.keymap.set('n', '<Leader>dr', require'dap'.repl.open, silent )
vim.keymap.set('n', '<Leader>dl', require'dap'.run_last, silent )
vim.keymap.set('n', '<Leader>du', require'dapui'.toggle, silent )

vim.keymap.set('n', '<Leader>tr', '<cmd>lua require"jester".run({dap = {console = ""}})<CR>', silent )
vim.keymap.set('n', '<Leader>td', require'jester'.debug, silent )
vim.keymap.set('n', '<Leader>tl', require'jester'.debug_last, silent )
vim.keymap.set('n', '<Leader>tf', require'jester'.debug_file, silent )
vim.keymap.set('n', '<Leader>i', require("dapui").eval, silent )

vim.keymap.set("n", "<Leader>pi", "<cmd>PickIcons<cr>", silent )
vim.keymap.set("i", "<C-i>", "<cmd>PickIconsInsert<cr>", silent )
vim.keymap.set("i", "<A-i>", "<cmd>PickAltFontAndSymbolsInsert<cr>", silent )

local Hydra = require('hydra')
Hydra({
    name = "Debugger",
    config = {
      color = 'amaranth',
      invoke_on_body = true
    },
    mode = 'n',
    body = '<leader>d',
    heads = {
      -- Debugger movement
      {'L', '<C-.>'},
      {'J', '<C-/>'},
      {'H', '<C-,>'},

      -- Breakpoints
      {'b','<leaderb>'},
      {'B','<leader>B'},
      {'m','<leader>lp'},

      { '<Esc>', nil, { exit = true, nowait = true }},
      { 'q',     nil , { exit = true, nowait = true }},
    },
})

return M
