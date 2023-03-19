local dap = require('dap')

-- dap theme
vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl= 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', linehl='DapLogPoint', numhl= 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })

dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

-- Adapter configs
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/utils/vscode-node-debug2/out/src/nodeDebug.js'},
}

require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7"),
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position.
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
      -- Elements can be strings or table with id and size keys.
        "breakpoints",
        { id = "stacks", size = 0.7 },
        { id = "watches", size = 0.1 },
        { id = "variables", size = 0.2 },
      },
      size = 45,
      position = "left",
    },
    {
      elements = {
        "repl",
        { id = "scopes", size = 0.65 },
      },
      size = 20,
      position = "bottom",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
  }
})

-- Language configs
dap.configurations.typescript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${workspaceFolder}/src/index.ts',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    outDir = "${workspaceFolder}/dist",
    runtimeArgs = {'--inspect-brk', './node_modules/.bin/jest', '--no-coverage', '-t', '${result}', '--', '${file}'},
    protocol = 'inspector',
    console = '',
  },
  
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require'dap.utils'.pick_process,
  },
}

require("jester").setup({
  path_to_jest_run = './node_modules/.bin/jest',
  command = 'yarn',
  terminal_cmd = 'bo vnew | term',
  dap = {
    args = {'node', os.getenv('HOME') .. '/utils/vscode-node-debug2/out/src/nodeDebug.js'},
    console = '',
    outDir = "${workspaceFolder}/dist",
  }
})
