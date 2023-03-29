return {
  'hrsh7th/nvim-cmp',
  opt = {
    sources = {
      {
        namne = 'nvim_lsp',
        entry_filter = function(entry, ctx)
          return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
        end
      }
    },
  },
}
