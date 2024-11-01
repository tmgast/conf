return {
  {
    "xemptuous/sqlua.nvim",
    lazy = true,
    commit = "ba4ecb1",
    cmd = "SQLua",
    config = function()
      require("sqlua").setup({
        keybinds = {
          execute_query = "<leader>eq",
        },
      })
    end,
  },
}
