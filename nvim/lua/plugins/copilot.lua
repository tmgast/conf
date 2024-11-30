return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      auto_trigger = false,
      suggestion = {
        enabled = false,
        auto_trigger = false,
        auto_refresh = true,
      },
      panel = { enabled = false },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = "copilot.lua",
    config = function()
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup()
    end,
    specs = {
      {
        "nvim-cmp",
        optional = true,
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
          table.insert(opts.sources, 1, {
            name = "copilot",
            group_index = 2,
            max_item_count = 5,
          })
        end,
      },
    },
  },
}
