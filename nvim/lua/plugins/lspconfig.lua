local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-16" }
return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = {
        preset = "default",
        ["<CR>"] = {},
        ["<S-CR>"] = { "select_and_accept", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
      }

      opts.completion = opts.completion or {}
      opts.completion.list = opts.completion.list or {}
      opts.completion.list.selection = {
        preselect = false, -- Do not preselect
        auto_insert = false, -- Do not auto insert
      }
      return opts
    end,
  },
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
        ["python"] = { "ruff format %" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", enabled = false, opts = { experimental = { pathStrict = true } } },
      { "mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    opts = function(_, opts)
      local util = require("lspconfig.util")

      -- helper: detect Vue/Nuxt tree by dev-config files
      local function is_vue_project(fname)
        return util.root_pattern("nuxt.config.ts", "nuxt.config.js", "vue.config.js")(fname)
      end

      -- make sure we have a setup table
      opts.setup = opts.setup or {}

      -- 1) only start Volar in Vue/Nuxt projects
      opts.setup["volar"] = function(server, volar_opts)
        if not is_vue_project(vim.loop.cwd()) then
          -- skip default volar.setup()
          return true
        end
        -- else fall through and let LazyVim do the normal volar setup
      end

      -- 2) only start ts_ls in non-Vue projects
      opts.setup["ts_ls"] = function(server, ts_opts)
        if is_vue_project(vim.loop.cwd()) then
          -- skip default ts_ls.setup()
          return true
        end
        -- else normal ts_ls setup
      end

      -- 3) if you still have vtsls around, you can also disable it in pure-TS
      opts.setup["vtsls"] = function(server, vtsls_opts)
        if not is_vue_project(vim.loop.cwd()) then
          return true
        end
      end

      return opts
    end,
  },
}
