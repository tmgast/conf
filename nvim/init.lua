require'plug'
require'tele'
require'lsp'
require'ndap'
require'refactor'
require'signs'
require'lline'
require'opts'
require'completion'

require('colorizer').setup()

require'nvim-treesitter.configs'.setup {
    highlight = {
    enable = true,
  },
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
  filetypes = {'javascript', 'javascriptreact', 'typescript', 'typescriptreact'},
}
require('lspconfig')['volar'].setup {
  capabilities = capabilities,
  on_attach = Keys.lsp_bindings,
}
require('lspconfig')['tsserver'].setup {
  capabilities = capabilities,
  on_attach = Keys.lsp_bindings,
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
