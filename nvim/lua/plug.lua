local Plug = vim.fn['plug#']
vim.call('plug#begin','~/.config/nvim/plugged')

-- Indexing and search
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})

-- Rust Lang
Plug 'rust-lang/rust.vim'

-- colors
Plug 'cocopon/iceberg.vim'
Plug 'cocopon/pgmnt.vim'
Plug 'cocopon/inspecthi.vim'
Plug 'cocopon/colorswatch.vim'
Plug 'rktjmp/lush.nvim'

-- color-preview
Plug 'norcalli/nvim-colorizer.lua'

-- Fuzzy Finder
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

-- nvim language server config
Plug 'neovim/nvim-lspconfig'

-- autoformat
Plug 'sbdchd/neoformat'

-- better tree
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

-- autocomplete
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

-- Install Lualine
Plug 'nvim-lualine/lualine.nvim'

-- choice themes
Plug('folke/tokyonight.nvim', { branch = 'main' })
Plug 'rebelot/kanagawa.nvim'
Plug 'tmgast/yokai.vim'

-- git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'lewis6991/gitsigns.nvim'
Plug 'kdheepak/lazygit.nvim'

-- magic
Plug 'github/copilot.vim'

-- Initialize plugin system
vim.call('plug#end')
