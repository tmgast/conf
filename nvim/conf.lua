-- Setup nvim-cmp.
local cmp = require'cmp'

require('colorizer').setup()
require('gitsigns').setup()

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require('luasnip').expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      elseif vim.b._copilot_suggestion ~= nil then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes(vim.fn['copilot#Accept'](), true, true, true), '')
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline', keyword_pattern=[=[[^[:blank:]\!]*]=] }
  })
})

local attach_bindings = function(client)
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
  vim.keymap.set('n', 'e', '<cmd>lua vim.diagnostic.open_float(0, { scope = "line", border = "single" })<CR>')
  vim.keymap.set('n', 'E', '<cmd>lua vim.diagnostic.open_float(0, { scope = "buffer", border = "single" })<CR>')
end

require'nvim-tree'.setup {
  open_on_setup = true,
}

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['pyright'].setup {
  capabilities = capabilities,
  on_attach=attach_bindings,
}
require('lspconfig')['html'].setup {
  capabilities = capabilities,
  on_attach=attach_bindings,
}
require('lspconfig')['eslint'].setup{
  capabilities = capabilities,
  on_attach=attach_bindings,
}
require('lspconfig')['tsserver'].setup {
  capabilities = capabilities,
  on_attach=attach_bindings,
}
require('lspconfig')['vimls'].setup {
  capabilities = capabilities,
  on_attach=attach_bindings,
}
require('lspconfig')['volar'].setup {
  capabilities = capabilities,
  on_attach=attach_bindings,
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
  on_attach=attach_bindings,
}
