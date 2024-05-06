return {
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  { "SmiteshP/nvim-navic" },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return require("lazyvim.util").has("nvim-cmp")
        end,
      },
    },
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
      },
      -- Automatically format on save
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        prismals = {},
        lua_ls = {},
        dartls = { force = true },
        tsserver = {
          filetypes = { "javascript", "typescript", "vue" },
          settings = {
            typescript = {
              suggest = {
                completeJSDocs = true,
                completeFunctionCalls = true,
                includeAutomaticOptionalChainCompletions = true,
              },
            },
          },
        },
        pyright = {
          settings = {
            disableLanguageServices = false,
            disableOrganizeImports = false,
          },
          python = {
            analysis = {
              autoSearchPaths = true,
              autoImportCompletions = true,
              diagnosticMode = "workspace",
              typeCheckingMode = "off",
              useLibraryCodeForTypes = true,
              diagnosticSeverityOverrides = {
                reportInvalidTypeForm = "information",
              },
            },
          },
        },
        html = {},
        eslint = {},
        volar = {
          filetypes = { "vue" },
          init_options = {
            vue = {
              hybridMode = false,
            },
          },
        },
        vimls = {},
        rls = {},
        jsonls = {},
        gdscript = {},
        clangd = {
          capabilities = {
            offsetEncoding = "utf-16",
          },
          settings = {
            clangd = {
              arguments = { "-offset_encoding", "utf-8", "-compile-commands-dir=./.vscode" },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },
}
