local ts_ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
local tsdk = function()
  return vim.fn.getcwd() .. "/node_modules/typescript/lib"
end
return {
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  { "SmiteshP/nvim-navic" },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.black)
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["python"] = { "black" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim",  enabled = false, opts = { experimental = { pathStrict = true } } },
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
        dartls = { force = true },
        lua_ls = {
          mason = false
        },
        luastyle = {
          mason = false
        },
        ruff = {
          mason = false
        },
        tsserver = {
          filetypes = ts_ft,
          init_options = {
            typescript = {
              tsdk = tsdk(),
            },
          },
        },
        volar = {
          filetypes = { "vue" },
          init_options = {
            vue = {
              hybridMode = false,
              scss = {
                enable = true,
              },
              typescript = {
                enable = true,
              },
            },
            typescript = {
              tsdk = tsdk(),
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
        vimls = {},
        rls = {},
        jsonls = {},
        gdscript = {},
        clangd = {
          mason = false,
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
