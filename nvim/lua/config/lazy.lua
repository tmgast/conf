local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    { "nvim-lualine/lualine.nvim", enabled = false },
    { "MunifTanjim/nougat.nvim" },
    { "LazyVim/LazyVim", import = "lazyvim.plugins", opts = { colorscheme = "kanagawa-wave" } },
    { "rcarriga/nvim-notify" },
    { import = "plugins" },
    { "echasnovski/mini.pairs", enabled = false },
  },
  defaults = {
    lazy = false,
    version = "*",
  },
  install = { colorscheme = { "kanagawa", "tokyonight" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
