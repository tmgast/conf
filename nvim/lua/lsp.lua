require("null-ls").setup({
    sources = {
        require("null-ls").builtins.completion.luasnip,

        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.formatting.prettierd,

        require("null-ls").builtins.diagnostics.eslint_d,
        require("null-ls").builtins.diagnostics.tsc,

        require("null-ls").builtins.code_actions.eslint_d,
        require("null-ls").builtins.code_actions.gitsigns,
    },
})

