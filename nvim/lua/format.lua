-- Utilities for creating configurations
local util = require "formatter.util"

-- Provides the Format and FormatWrite commands
require('formatter').setup {
  -- All formatter configurations are opt-in
  filetype = {
    lua = {
      require('formatter.filetypes.lua').stylua,
    },
    python = {
      require('formatter.filetypes.python').yapf,
    },
    typescript = {
      require('formatter.filetypes.typescript').prettier,
    },
    javascript = {
      require('formatter.filetypes.javascript').prettier,
    },
  }
}
