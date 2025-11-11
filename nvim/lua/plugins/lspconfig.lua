local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-16" }

local filter_dts = function(err, result, ctx, cfg)
  if not result then
    return vim.lsp.handlers["textDocument/definition"](err, result, ctx, cfg)
  end

  -- use the built-in is_list helper
  local is_list = vim.lsp.util.is_list(result)
  local items = is_list and result or { result }

  -- keep only entries whose URI or targetUri does NOT end in .d.ts
  local filtered = vim.tbl_filter(function(item)
    local uri = item.uri or item.targetUri or ""
    return not uri:match("%.d.ts$")
  end, items)

  -- if we filtered everything away, fall back to original
  if vim.tbl_isempty(filtered) then
    filtered = items
  end

  local to_send = is_list and filtered or filtered[1]
  return vim.lsp.handlers["textDocument/definition"](err, to_send, ctx, cfg)
end

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
        preselect = false,
        auto_insert = false,
      }

      return opts
    end,
  },

  {
    "nvim-mini/mini.pairs",
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
      return opts
    end,
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff format %" },
      },
    },
  },
  {},
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        opts = {},
      },
      {
        "folke/neodev.nvim",
        enabled = false,
        opts = { experimental = { pathStrict = true } },
      },
      "mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    opts = function(_, opts)
      opts.setup = opts.setup or {}

      local util = require("lspconfig.util")
      -- 3) Detect Vue/Nuxt by looking upward for one of these files
      local function is_vue_project(fname)
        return vim.fs.find({ "nuxt.config.ts", "nuxt.config.js", "vue.config.js" }, { path = fname, upward = true })[1]
          ~= nil
      end

      -- only start Volar in Vue/Nuxt roots
      opts.setup["volar"] = function(_, volar_opts)
        if is_vue_project(volar_opts.root_dir) then
          return true
        end

        volar_opts.handlers = volar_opts.handlers or {}
        volar_opts.handlers["textDocument/definition"] = filter_dts
      end

      -- only start tsserver in non-Vue roots
      opts.setup["ts_ls"] = function(_, ts_opts)
        ts_opts.handlers = ts_opts.handlers or {}
        ts_opts.handlers["textDocument/definition"] = filter_dts
      end

      -- only start vtsls in Vue roots
      opts.setup["vtsls"] = function(_, vtsls_opts)
        if is_vue_project(vtsls_opts.root_dir) then
          return true
        end
      end

      opts.servers = {
        volar = {
          on_attach = function(client, bufnr)
            -- Disable formatting capability for Volar to prevent slowness on save
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        },
        ts_ls = {
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = vim.fn.stdpath("data")
                  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                languages = { "vue" },
              },
            },
          },
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        },
        vtsls = {},
      }

      return opts
    end,
  },
}
