local M = {}

-- Convert "#rrggbb" to {r,g,b}
local function hex2rgb(hex)
  local h = hex:gsub("#", "")
  return {
    tonumber(h:sub(1, 2), 16),
    tonumber(h:sub(3, 4), 16),
    tonumber(h:sub(5, 6), 16),
  }
end

-- Convert {r,g,b} to "#rrggbb"
local function rgb2hex(rgb)
  return string.format("#%02x%02x%02x", rgb[1], rgb[2], rgb[3])
end

-- Blend color1 toward color2 by alpha (0 ≤ alpha ≤ 1)
-- $$ C = (1-\alpha)C_1 + \alpha\,C_2 $$
local function blend(c1, c2, alpha)
  local rgb1 = hex2rgb(c1)
  local rgb2 = hex2rgb(c2)
  local out = {}
  for i = 1, 3 do
    out[i] = math.floor((1 - alpha) * rgb1[i] + alpha * rgb2[i] + 0.5)
  end
  return rgb2hex(out)
end

-- Apply highlights
local function apply(highlights)
  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

-- Main setup
function M.setup(config)
  config = vim.tbl_deep_extend("force", {
    style = "dark",
    blend_factor = 0.5,
    colors = {
      base = "#1e1e2e",
      keyword = "#c678dd",
      variable = "#8ec07c",
      attribute = "#d19a66",
      text = "#abb2bf",
      digit = "#ff6c6b",
    },
  }, config or {})

  local bg0 = (config.style == "dark") and "#111111" or "#eeeeee"
  local fg0 = (config.style == "dark") and "#eeeeee" or "#111111"
  local mp0 = "#888888"
  local blend_to = bg0 -- for comments & bg
  local bf = config.blend_factor

  -- derived colors
  local comment_fg = blend(config.colors.base, mp0, 0.45)
  local bg = blend(blend_to, config.colors.base, 0.25)
  local fg = blend(fg0, config.colors.text, bf)

  -- core syntax groups
  local groups = {
    -- basics
    Normal = { fg = fg, bg = bg },
    CursorLine = { bg = blend(bg0, mp0, 0.15) },
    ColorColumn = { bg = blend(bg, mp0, 0.25) },

    -- syntax
    Comment = { fg = comment_fg, italic = true },
    Keyword = { fg = config.colors.keyword, italic = true, bold = true },
    Identifier = { fg = config.colors.variable },
    Function = { fg = config.colors.variable },
    Statement = { fg = config.colors.keyword },
    Type = { fg = config.colors.attribute },
    Constant = { fg = config.colors.digit },
    String = { fg = blend(config.colors.base, "#99ff99", 0.6) },
    Number = { fg = config.colors.digit },
    Operator = { fg = config.colors.keyword },

    -- LSP diagnostics
    DiagnosticError = { fg = config.colors.digit },
    DiagnosticWarn = { fg = config.colors.attribute },
    DiagnosticInfo = { fg = config.colors.text },
    DiagnosticHint = { fg = config.colors.variable },

    -- underline errors/warnings
    DiagnosticUnderlineError = { undercurl = true, sp = config.colors.digit },
    DiagnosticUnderlineWarn = { undercurl = true, sp = config.colors.attribute },

    -- LSP references
    LspReferenceText = { bg = blend(bg, "#ffff00", 0.15) },
    LspReferenceRead = { bg = blend(bg, "#00ff00", 0.15) },
    LspReferenceWrite = { bg = blend(bg, "#ff0000", 0.15) },
  }

  apply(groups)
end

return M
