-- ahays nvim config 11/20/21
vim.g.mapleader = " "

require('plugins')

-- set colorscheme (order is important)
--vim.opt.termguicolors = false
--vim.cmd[[colorscheme Oblivion]]
--vim.g.aldmeris_termcolors = "tango"
--vim.cmd[[colorscheme aldmeris]]
vim.g.gruvbox_contrast_dark = 'hard'
--vim.cmd[[colorscheme gruvbox]]
vim.cmd[[colorscheme no-clown-fiesta]]
--vim.cmd[[colorscheme holokai]]
--vim.g.ayucolor = "dark"
--vim.cmd[[colorscheme ayu]]
--vim.cmd[[colorscheme nord]]

-- options
-- :help <variable>

-- number of lines remembered in command history table
vim.opt.history = 1000
-- precede each line with its line number
vim.opt.number = true 
-- options for Insert mode completion
vim.opt.completeopt = {'menuone', 'noselect'}
-- enable mouse support all modes
vim.opt.mouse = 'a'
-- vertical split will put the new window to the right (:vsplit)
vim.opt.splitright = true
-- horizontal split will put the new window below (:split)
vim.opt.splitbelow = true
-- in insert mode: use appropriate number of spaces to insert a <Tab>
vim.opt.expandtab = true
-- number of spaces that a <Tab> in the file counts for.
vim.opt.tabstop = 4
-- number of spaces indented with '>'
vim.opt.shiftwidth = 4
-- ignore case of normal letters in a pattern unless /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- show where the searched pattern is matching as you type
vim.opt.incsearch = true
vim.opt.hlsearch = false
-- do not save when switching buffers
vim.opt.hidden = true
-- always draw the sign column
vim.opt.signcolumn = 'yes'
-- swap file will be written to disk if nothing is typed in this many ms
vim.opt.updatetime = 520
vim.opt.undofile = true
-- do not backup file when writing to an existing file
vim.opt.backup = false
-- all folds are closed
vim.opt.foldenable = true
-- folds with a higher level will be closed
vim.opt.foldlevel=99
-- sets 'foldlevel' when starting to edit another buffer in a window
vim.opt.foldlevelstart=10
-- sets the maximum nesting of folds
vim.opt.foldnestmax=10
--vim.opt.spell = true
--vim.opt.spelllang = { 'en_us' }

vim.g.netrw_liststyle = 3

-- vim-terraform
vim.g.terraform_fmt_on_save = true

-- enable loading the plugin files for specific file types
vim.cmd('filetype plugin on')

-- save undo history
vim.cmd[[set undofile]]

vim.cmd[[highlight CursorLineNr cterm=NONE ctermbg=15 ctermfg=8 gui=NONE guibg=#2E3436 guifg=#C4A000]]
vim.opt.cursorline = true

-- Automatically switch relative number on and off depending on mode
-- Credit: https://jeffkreeftmeijer.com/vim-number/
vim.api.nvim_exec([[
augroup NumberToggle
autocmd!
autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | :set rnu | endif
autocmd BufLeave,FocusLost,InsertEnter,WinLeave * if &nu | :set nornu | endif
augroup END
]], false)

-- Automatically run :PackerCompile whenever plugins.lua is updated
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Highlight on yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)


-- gofmt on file write
vim.api.nvim_exec([[
autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 100)
]], false)

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Mappings

map('n', '<leader>v', ':e $MYVIMRC<CR>')

map('n', '<leader>dp', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
map('n', '<leader>dn', '<cmd>lua vim.diagnostic.goto_next()<CR>')

-- Close location list when navigating out by cr
vim.api.nvim_exec([[
autocmd FileType qf nmap <buffer> <cr> <cr>:lcl<cr>
]], false)

-- Toggle diagnostics in location list 
--vim.g.diagnostics_loclist = false
--function _G.toggle_diagnostics_loclist()
 -- if vim.g.diagnostics_loclist then
  --  vim.g.diagnostics_loclist = false
   -- vim.cmd[[window lcl<CR>]]
--  else
 --   vim.g.diagnostics_loclist = true
  --  vim.diagnostic.setloclist()
--  end
--end
vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>ds', '<cmd> lua vim.diagnostic.setloclist()<CR>', {silent=true, noremap=true})

-- Toggle diagnostics 
vim.g.diagnostics_visible = true
function _G.toggle_diagnostics()
  if vim.g.diagnostics_visible then
    vim.g.diagnostics_visible = false
    vim.diagnostic.disable()
  else
    vim.g.diagnostics_visible = true
    vim.diagnostic.enable()
  end
end
vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>l', ':call v:lua.toggle_diagnostics()<CR>', {silent=true, noremap=true})

-- colorbuddy config for cmp text
--local Group = require("colorbuddy.group").Group
--local g = require("colorbuddy.group").groups
--local s = require("colorbuddy.style").styles

--Group.new("CmpItemAbbr", g.Comment)
--Group.new("CmpItemAbbrDeprecated", g.Error)
--Group.new("CmpItemAbbrMatchFuzzy", g.CmpItemAbbr.fg:dark(), nil, s.italic)
--Group.new("CmpItemKind", g.Special)
--Group.new("CmpItemMenu", g.NonText)

-- hrsh7th/vim-vsnip
vim.cmd([[
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
]])
