return {
  {
    "brenoprata10/nvim-highlight-colors",
    lazy = false,
    opts = {},
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      colorscheme = "kanagawa",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "svermeulen/text-to-colorscheme.nvim",
    opts = {
      ai = {
        gpt_model = "gpt-4o",
        openai_api_key = os.getenv("OPENAI_API_KEY"),
        green_darkening_amount = 0.65,
      },
      hex_palettes = {
        {
          name = "Gundam 001",
          background_mode = "dark",
          background = "#0c0d11",
          foreground = "#ffffff",
          accents = {
            "#ff65a9",
            "#65a9ff",
            "#ffc265",
            "#59e1ac",
            "#c265ff",
            "#ff6565",
            "#59e159",
          },
        },

        {
          name = "ghibli park",
          background_mode = "dark",
          background = "#0d1a1e",
          foreground = "#c7d5d8",
          accents = {
            "#a8f7f7",
            "#8fd28f",
            "#f7d8a8",
            "#8fd2b8",
            "#f7f7a8",
            "#a8a8f7",
            "#f7a8a8",
          },
        },
        {
          name = "night shrine",
          background_mode = "dark",
          background = "#1a1a1a",
          foreground = "#eaeaea",
          accents = {
            "#b064f9",
            "#007b63",
            "#3aa285",
            "#8a8a8a",
            "#6e8926",
            "#ff6b6b",
            "#ff9f43",
          },
        },
        {
          name = "vaporwave",
          background_mode = "dark",
          background = "#1a1832",
          foreground = "#f7e8f5",
          accents = {
            "#6a4fa8",
            "#b28df2",
            "#3b6ea8",
            "#8bd0f1",
            "#f28bd1",
            "#f9a1bc",
            "#f9c1a8",
          },
        },
      },
      default_palette = "Gundam 001",
    },
  },
}
