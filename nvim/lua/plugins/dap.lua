return {
  "mfussenegger/nvim-dap",
  recommended = true,
  desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

  dependencies = {
    "rcarriga/nvim-dap-ui",
    -- virtual text for the debugger
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },
    config = function()
      local dap = require("dap")
      dap.adapters.godot = function(callback)
        local adapter = {
          type = "server",
          host = "127.0.0.1",
          port = 6006,
        }
        callback(adapter)
      end

      dap.configurations.gdscript = {
        type = "godot",
        request = "launch",
        name = "Launch scene",
        project = "${workspaceFolder}",
        launch_scene = true,
      }
    end,
  },
}
