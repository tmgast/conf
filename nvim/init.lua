require'plug'
require'lline'
require'ndap'
require'lsp'

vim.opt.laststatus = 3
vim.g.loaded_perl_provider = 0

vim.cmd([[
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
colorscheme yokai
" colorscheme kanagawa
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

set cursorline
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

require'nvim-treesitter.configs'.setup {
    highlight = {
    enable = true,
  },
}

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
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

require'nvim-tree'.setup {}
local Keys = require'keymaps'

prettier = require'prettier'
prettier.setup({
  ["null-ls"] = {
    runtime_condition = function(params)
      -- return false to skip running prettier
      return true
    end,
    timeout = 5000,
  }
})

prettier.setup({
  bin = 'prettier', -- or `prettierd`
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "vue",
    "yaml",
  },
})

-- Setup lspconfig.
require("lsp-format").setup({})
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
require('lspconfig')['pyright'].setup {
  capabilities = capabilities,
  on_attach = Keys.lsp_bindings,
}
require('lspconfig')['html'].setup {
  capabilities = capabilities,
  on_attach = Keys.lsp_bindings,
}
require('lspconfig')['eslint'].setup{
  capabilities = capabilities,
  on_attach = Keys.lsp_bindings,
  filetypes = {'javascript', 'javascriptreact', 'typescript', 'typescriptreact'},
}
require('lspconfig')['volar'].setup {
  capabilities = capabilities,
  on_attach = Keys.lsp_bindings,
}
require('lspconfig')['tsserver'].setup {
  capabilities = capabilities,
  on_attach = Keys.lsp_bindings,
}
require('lspconfig')['vimls'].setup {
  capabilities = capabilities,
  on_attach = Keys.lsp_bindings,
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
  on_attach = Keys.lsp_bindings,
}


require'tele'
