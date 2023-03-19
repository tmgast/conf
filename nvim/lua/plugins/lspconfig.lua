return {
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
    autoformat = true,
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
      prismals = {
        mason = false, -- set to false if you don't want this server to be installed with mason
      },
      tsserver = {
        mason = false, -- set to false if you don't want this server to be installed with mason
      },
      pyright = {
        mason = false, -- set to false if you don't want this server to be installed with mason
      },
      html = {
        mason = false, -- set to false if you don't want this server to be installed with mason
      },
      eslint = {
        mason = false, -- set to false if you don't want this server to be installed with mason
      },
      volar = {
        mason = false, -- set to false if you don't want this server to be installed with mason
      },
      vimls = {
        mason = false, -- set to false if you don't want this server to be installed with mason
      },
      rls = {
        mason = false, -- set to false if you don't want this server to be installed with mason
      },
      jsonls = {
        mason = false, -- set to false if you don't want this server to be installed with mason
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
}
