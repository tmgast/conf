local Plug = vim.fn['plug#']
vim.call('plug#begin','~/.config/nvim/plugged')

-- Indexing and search
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})

-- lsp utility runner
Plug 'jose-elias-alvarez/null-ls.nvim'

-- lsp status pane
Plug 'j-hui/fidget.nvim'

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

-- debugging
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'David-Kunz/jester'

-- autoformat
Plug 'lukas-reineke/lsp-format.nvim'
Plug 'MunifTanjim/prettier.nvim'

-- better tree
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

-- icon picker
Plug 'stevearc/dressing.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'ziontee113/icon-picker.nvim'

-- autocomplete
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

-- refactoring
Plug "ThePrimeagen/refactoring.nvim"

-- Install Lualine
Plug 'nvim-lualine/lualine.nvim'
Plug ('akinsho/bufferline.nvim', { tag = 'v2.*' })

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
Plug 'anuvyklack/hydra.nvim'
Plug 'anuvyklack/keymap-layer.nvim'

-- Initialize plugin system
vim.call('plug#end')
