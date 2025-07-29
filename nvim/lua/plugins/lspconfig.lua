local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-16" }

local filter_dts = function(err, result, ctx, config)
  if not result then
    return
  end
  -- turn single Location into a list, so we can filter uniformly
  local is_list = vim.lsp.util.is_list(result)
  local items = is_list and result or { result }

  -- drop anything whose URI ends in .d.ts
  local filtered = vim.tbl_filter(function(item)
    return not item.uri:match("%.d.ts$")
  end, items)

  -- if nothing left, fall back to the original (so you still jump somewhere)
  local to_send = #filtered > 0 and filtered or items

  -- if it was a single Location originally, unwrap it
  if not is_list then
    to_send = to_send[1]
  end

  -- forward to the default handler
  vim.lsp.handlers["textDocument/definition"](err, to_send, ctx, config)
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
      "williamboman/mason-lspconfig.nvim",
    },
    opts = function(_, opts)
      opts.setup = opts.setup or {}

      local util = require("lspconfig.util")
      local is_vue_project = util.root_pattern("nuxt.config.ts", "nuxt.config.js", "vue.config.js")

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
        if not is_vue_project(ts_opts.root_dir) then
          return true
        end

        ts_opts.handlers = ts_opts.handlers or {}
        ts_opts.handlers["textDocument/definition"] = filter_dts
      end

      -- only start vtsls in Vue roots
      opts.setup["vtsls"] = function(_, vtsls_opts)
        if not is_vue_project(vtsls_opts.root_dir) then
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
