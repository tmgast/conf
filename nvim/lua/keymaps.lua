local hydra = require('hydra')
local splits = require('smart-splits')
local dap = require('dap')
local dapui = require('dapui')
local jester = require('jester')
local silent = { silent = true }
local nowait = { nowait = true }
local snow = { silent = true, nowait = true }

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

vim.keymap.set({"n","v"}, ';', ':')
vim.keymap.set({"n","v"}, ';;', ';')

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
  vim.keymap.set('n', 'e', vim.diagnostic.open_float, { buffer = 0 })
  vim.keymap.set('n', 'e.', vim.diagnostic.goto_next, { buffer = 0 })
  vim.keymap.set('n', 'e,', vim.diagnostic.goto_prev, { buffer = 0 })
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { buffer = 0 })
  vim.keymap.set('n', '<leader>p', '<cmd>! ./deploy.sh<CR>', silent )

  -- remap to open the Telescope refactoring menu in visual mode
  vim.keymap.set('v', '<leader>r', require('telescope').extensions.refactoring.refactors)
end

function M.debug_bindings(client)
end

vim.keymap.set('i', '~', '<Cmd>call copilot#Next()<CR>', silent)

vim.keymap.set('n', '<Leader>dl', require'dap'.run_last, silent )

vim.keymap.set("n", "<Leader>pi", "<cmd>PickIcons<cr>", silent )
vim.keymap.set("i", "@@", "<cmd>PickIconsInsert<cr>", silent )
vim.keymap.set("i", "<A-i>", "<cmd>PickAltFontAndSymbolsInsert<cr>", silent )

hydra({
    name = "Debugger",
    hint = [[

     --- Movement ---   
   _L_ - step out
   _H_ - step into
   _J_ - step over
   _<space>_ - continue

      --- Actions ---
   _i_ - inspect
   _U_ - toggle UI
   _d_ - debug
   _f_ - debug file
   _r_ - debug last
   _R_ - run

      - Breakpoints -
   _b_ - toggle breakpoint  
   _B_ - set condition
   _m_ - set log point


       --- QUIT ---
       _<ESC>_, _q_

    ]],
    config = {
      color = 'pink',
      invoke_on_body = true,
      hint = {
         position = 'middle-right',
         border = 'none'
      },
      on_enter = function()
         vim.bo.modifiable = false
      end,
      on_exit = function()
        vim.cmd 'echo'
      end
    },
    mode = 'n',
    body = '<leader>d',
    heads = {
      -- Inspect
      {'i', dapui.eval, snow },
      {'U', dapui.toggle, snow },

      -- run (JEST)
      {'d', jester.debug, nowait },
      {'r', jester.debug_last, nowait },
      {'R', jester.run, nowait },
      {'f', jester.debug_file, nowait },

      -- Debugger movement
      {'L', dap.step_out, nowait },
      {'J', dap.step_over, nowait },
      {'H', dap.step_into, nowait },
      {'<space>', dap.continue, nowait },

      -- Breakpoints
      {'b', dap.toggle_breakpoint, nowait },
      {'B', '<cmd>lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', snow },
      {'m', '<cmd>lua require("dap").set_breakpoint(nil, vim.fn.input("Log point message: "))<CR>', snow },
      {'q', nil, { exit = true }},
      {'<ESC>', nil, { exit = true }}
    }
})

hydra({
  name = "Split movements and resizing",
  mode = 'n',
  body = '<leader>w',
  config = {
    invoke_on_body = true,
    timeout = 2500,
  },
  heads = {
    { 'h', splits.move_cursor_left },
    { 'j', splits.move_cursor_down },
    { 'k', splits.move_cursor_up },
    { 'l', splits.move_cursor_right },
    { 'H', splits.resize_left },
    { 'J', splits.resize_down },
    { 'K', splits.resize_up },
    { 'L', splits.resize_right },
  },
})

return M
