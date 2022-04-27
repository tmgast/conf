call plug#begin('~/.config/nvim/plugged')
" Indexing and search
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Rust Lang
Plug 'rust-lang/rust.vim'

" colors
Plug 'cocopon/iceberg.vim'
Plug 'cocopon/pgmnt.vim'
Plug 'cocopon/inspecthi.vim'
Plug 'cocopon/colorswatch.vim'

" color-preview
Plug 'norcalli/nvim-colorizer.lua'

" Fuzzy Finder
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" nvim language server config
Plug 'neovim/nvim-lspconfig'

" autocomplete
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Install Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" choice themes
Plug 'folke/tokyonight.nvim', {'branch': 'main' }
Plug 'rebelot/kanagawa.nvim'
Plug 'tmgast/yokai.vim'

" git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'lewis6991/gitsigns.nvim'
Plug 'kdheepak/lazygit.nvim'

" magic
Plug 'github/copilot.vim'

" Initialize plugin system
call plug#end()

set laststatus=2

" use 256 colors in terminal
if !has("gui_running")
  set t_Co=256
  set termguicolors
endif

if(exists('+termguicolors'))
  let &t_8f = "<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "<Esc>[48;2;%lu;%lu;%lum"
endif

" colorscheme tokyonight
" colorscheme kanagawa
colorscheme yokai
" hi Normal guibg=NONE ctermbg=NONE

set exrc
set noerrorbells
set noswapfile
set nobackup
set scrolloff=8
set hidden
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set shiftround
set nu
set nowrap
set smartcase
set mouse=a
set shell=zsh
set spell

set wildignore=*/node_modules,coverage,*/dist

let g:python3_host_prog="/bin/python3.10"

let g:rustfmt_autosave = 1

let mapleader = " "

" show buffer tabs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" Ctrl jump between buffers
nnoremap <C-k> :bnext<CR>
nnoremap <C-j> :bprevious<CR>

nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

nnoremap Y yg$

" Language Server configs
set completeopt=menu,menuone,noselect
source $HOME/.config/nvim/conf.lua

" Find files using Telescope command-line sugar.
nnoremap ff <cmd>Telescope find_files<cr>
nnoremap fg <cmd>Telescope live_grep<cr>
nnoremap fb <cmd>Telescope buffers<cr>
nnoremap fh <cmd>Telescope help_tags<cr>

" keep cursor in place when searching and line concat actions
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" shifting lines
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> <esc>:m .+1<CR>==i
inoremap <C-k> <esc>:m .-2<CR>==i
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==

" better i-mode escape
inoremap jj <ESC>
vnoremap jj <ESC>

" use shift-tab mapping for copilot
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <S-Tab> copilot#Accept("\<CR>")

" show diagnostics
nnoremap <S-e> :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

map      ; :
noremap  ;; ;
