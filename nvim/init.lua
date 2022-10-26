require'plug'
require'split'
require'tele'
require'lsp'
require'signs'
require'lline'
require'opts'
require'completion'
require'refactor'
require'vista'

require('tint').setup{}
require('treesitter-context').setup{}
require('dressing').setup({})
require("icon-picker")

require('fidget').setup({
  window = {
    blend = 30,
  },
  text = {
    spinner = "dots_pulse",
  },
  fmt = {
    stack_upwards = false,
    max_width = 80,
  },
})

require('colorizer').setup()

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "javascript", "typescript" },
  highlight = {
    enable = true
  }
}

require'nvim-tree'.setup {
  view = {
    width = 50,
  }
}
local Keys = require'keymaps'

prettier = require'prettier'
prettier.setup({
  ["null-ls"] = {
    runtime_condition = function(params)
      -- return false to skip running prettier
      return true
    end,
    timeout = 5000,
  }
})

prettier.setup({
  bin = 'prettier', -- or `prettierd`
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "vue",
    "yaml",
    "py",
  },
})

vim.o.winwidth = 10
vim.o.winminwidth = 10
vim.o.equalalways = false
require('windows').setup{}

-- Setup lspconfig.
require("lsp-format").setup({})
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local navic = require("nvim-navic")
require'ndap'

local luadev = require("neodev").setup({})
local lspconfig = require('lspconfig')
lspconfig.sumneko_lua.setup(luadev)

require'lspconfig'.prismals.setup{
  capabilities = capabilities,
  on_attach = Keys.lsp_bindings,
}

require('lspconfig')['pyright'].setup {
  capabilities = capabilities,
  on_attach = Keys.lsp_bindings,
}
require('lspconfig')['html'].setup {
  capabilities = capabilities,
  on_attach = Keys.lsp_bindings,
}
require('lspconfig')['eslint'].setup{
  capabilities = capabilities,
  on_attach = Keys.lsp_bindings,
  filetypes = {'javascript', 'javascriptreact', 'typescript'},
}
require('lspconfig')['volar'].setup {
  capabilities = capabilities,
  on_attach = Keys.lsp_bindings,
}
require('lspconfig')['tsserver'].setup {
  root_dir = require('lspconfig').util.root_pattern("yarn.lock", "tsconfig.json", ".git"),
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    Keys.lsp_bindings(client)
    navic.attach(client, bufnr)
  end,
  settings = {documentFormatting = true},
}
require('lspconfig')['vimls'].setup {
  capabilities = capabilities,
  on_attach = Keys.lsp_bindings,
}
require('lspconfig')['rls'].setup {
  settings = {
    rust = {
      unstable_features = true,
      build_on_save = false,
      all_features = true,
    },
  },
  capabilities = capabilities,
  on_attach = Keys.lsp_bindings,
}
