vim.cmd([[
let g:vista_default_executive = 'ctags'
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista_executive_for = {
  \ 'dart': 'vim_lsc',
  \ 'go': 'vim_lsc',
  \ 'rust': 'vim_lsc',
  \ 'javascript': 'vim_lsc',
  \ 'markdown': 'vim_lsc'
  \ }
]])
