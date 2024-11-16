return {
  {
    "xemptuous/sqlua.nvim",
    lazy = true,
    cmd = "SQLua",
    commit = "ba4ecb1",
    config = function()
      require("sqlua").setup()
    end,
  },
}
