require('silicon').setup({
  output = string.format(
              "%s/codeshots/SS_%s-%s-%s_%s-%s.png",
              os.getenv("HOME"),
              os.date("%Y"),
              os.date("%m"),
              os.date("%d"),
              os.date("%H"),
              os.date("%M")
            ),
  theme = "auto",
  bgColor = vim.g.terminal_color_5,
  bgImage = "", -- path to image, must be png
  roundCorner = true,
  windowControls = true,
  lineNumber = true,
  font = "Victor Mono Nerd Font",
  lineOffset = 1, -- from where to start line number
  linePad = 2, -- padding between lines
  padHoriz = 20, -- Horizontal padding
  padVert = 20, -- vertical padding
  shadowBlurRadius = 10,
  shadowColor = "#555555",
  shadowOffsetX = 8,
  shadowOffsetY = 8,
})
