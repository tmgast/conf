require'plug'
require'tele'
require'lsp'
require'signs'
require'lline'
require'opts'
require'completion'
require'refactor'

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

require'nvim-tree'.setup {}
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

-- Setup lspconfig.
require("lsp-format").setup({})
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require'ndap'

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
  filetypes = {'javascript', 'javascriptreact'},
}
require('lspconfig')['volar'].setup {
  capabilities = capabilities,
  on_attach = Keys.lsp_bindings,
}
require('lspconfig')['tsserver'].setup {
  root_dir = require('lspconfig').util.root_pattern("yarn.lock", "tsconfig.json", ".git"),
  capabilities = capabilities,
  on_attach = Keys.lsp_bindings,
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
