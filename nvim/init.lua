vim.cmd([[
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

" autoformat
Plug 'sbdchd/neoformat'

" better tree
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

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
let g:loaded_perl_provider = 0

set laststatus=3

" use 256 colors in terminal
if !has("gui_running")
  set t_Co=256
  set termguicolors
endif

if(exists('+termguicolors'))
  let &t_8f = "<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "<Esc>[48;2;%lu;%lu;%lum"
endif

autocmd BufEnter * syntax sync minlines=4000
" colorscheme tokyonight
" colorscheme yokai
colorscheme kanagawa
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

set colorcolumn=80,120

set wildignore=*/node_modules,coverage,*/dist

" use shift-tab mapping for copilot
let g:copilot_no_tab_map = v:true

let s:uname = system("uname -s")
if s:uname == "Darwin\n"
  let g:python3_host_prog="/usr/bin/python3"
else
  let g:python3_host_prog="/bin/python3.10"
endif

let g:rustfmt_autosave = 1
let g:neoformat_try_node_exe = 1

let mapleader = " "

" show buffer tabs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" Language Server configs
set completeopt=menu,menuone,noselect
]])

-- Setup nvim-cmp.
local cmp = require'cmp'

require('colorizer').setup()
require('gitsigns').setup()

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require('luasnip').expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      elseif vim.b._copilot_suggestion ~= nil then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes(vim.fn['copilot#Accept'](), true, true, true), '')
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline', keyword_pattern=[=[[^[:blank:]\!]*]=] }
  })
})

local attach_bindings = function(client)
	vim.keymap.set('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
	vim.keymap.set('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
	vim.keymap.set('n','K','<cmd>lua vim.lsp.buf.hover()<CR>')
	vim.keymap.set('n','gr','<cmd>lua vim.lsp.buf.references()<CR>')
	vim.keymap.set('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>')
	vim.keymap.set('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
	vim.keymap.set('n','gt','<cmd>lua vim.lsp.buf.type_definition()<CR>')
	vim.keymap.set('n','<leader>gw','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
	vim.keymap.set('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
	vim.keymap.set('n','<leader>ah','<cmd>lua vim.lsp.buf.hover()<CR>')
	vim.keymap.set('n','<leader>af','<cmd>lua vim.lsp.buf.code_action()<CR>')
	vim.keymap.set('n','<leader>ee','<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>')
	vim.keymap.set('n','<leader>ar','<cmd>lua vim.lsp.buf.rename()<CR>')
	vim.keymap.set('n','<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
	vim.keymap.set('n','<leader>ai','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
	vim.keymap.set('n','<leader>ao','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
  vim.keymap.set('n', 'e', '<cmd>lua vim.diagnostic.open_float(0, { scope = "line", border = "single" })<CR>')
  vim.keymap.set('n', 'E', '<cmd>lua vim.diagnostic.open_float(0, { scope = "buffer", border = "single" })<CR>')
end

require'nvim-tree'.setup {}

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['pyright'].setup {
  capabilities = capabilities,
  on_attach=attach_bindings,
}
require('lspconfig')['html'].setup {
  capabilities = capabilities,
  on_attach=attach_bindings,
}
require('lspconfig')['eslint'].setup{
  capabilities = capabilities,
  on_attach=attach_bindings,
}
require('lspconfig')['tsserver'].setup {
  capabilities = capabilities,
  on_attach=attach_bindings,
}
require('lspconfig')['vimls'].setup {
  capabilities = capabilities,
  on_attach=attach_bindings,
}
require('lspconfig')['volar'].setup {
  capabilities = capabilities,
  on_attach=attach_bindings,
}
require('lspconfig')['rls'].setup {
  settings = {
    rust = {
      unstable_features = true,
      build_on_save = false,
      all_features = true,
    },
  },
  capabilities = capabilities,
  on_attach=attach_bindings,
}

require'keymaps'
