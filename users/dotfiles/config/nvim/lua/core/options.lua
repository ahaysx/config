-- options
-- :help <variable>

-- number of lines remembered in command history table
vim.opt.history = 1000
-- precede each line with its line number
vim.opt.number = true
vim.opt.relativenumber = true
-- options for Insert mode completion
vim.opt.completeopt = { 'menuone', 'noselect' }
-- enable mouse support all modes
vim.opt.mouse = 'a'
-- vertical split will put the new window to the right (:vsplit)
vim.opt.splitright = true
-- horizontal split will put the new window below (:split)
vim.opt.splitbelow = true
-- in insert mode: use appropriate number of spaces to insert a <Tab>
vim.opt.expandtab = true
-- number of spaces that a <Tab> in the file counts for.
vim.opt.tabstop = 2
-- number of spaces indented with '>'
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.shiftround = true
-- ignore case of normal letters in a pattern unless /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- show where the searched pattern is matching as you type
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- do not save when switching buffers
vim.opt.hidden = true
-- always draw the sign column
vim.opt.signcolumn = 'yes'
-- swap file will be written to disk if nothing is typed in this many ms
vim.opt.updatetime = 250
-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 400
-- save undo history
vim.opt.undofile = true
-- do not backup file when writing to an existing file
vim.opt.backup = false
-- all folds are closed
vim.opt.foldenable = true
-- folds with a higher level will be closed
vim.opt.foldlevel = 99
-- sets 'foldlevel' when starting to edit another buffer in a window
vim.opt.foldlevelstart = 10
-- sets the maximum nesting of folds
vim.opt.foldnestmax = 10
--vim.opt.spell = true
--vim.opt.spelllang = { 'en_us' }
vim.opt.cmdheight = 2
-- experimenting
vim.opt.inccommand = 'split'
vim.opt.scrolloff = 10

vim.cmd [[colorscheme no-clown-fiesta]]

-- The pinned theme commit predates the @punctuation.* treesitter group names,
-- so its intended white punctuation never applies; restore it here.
vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = "#E1E1E1" })
vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = "#E1E1E1" })

vim.g.netrw_liststyle = 3

-- vim-terraform
vim.g.terraform_fmt_on_save = true

-- enable loading the plugin files for specific file types
vim.cmd('filetype plugin on')

-- save undo history
vim.cmd [[set undofile]]

vim.cmd [[highlight CursorLineNr cterm=NONE ctermbg=15 ctermfg=8 gui=NONE guibg=#2E3436 guifg=#C4A000]]
vim.opt.cursorline = true

vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.autoread = true

vim.opt.clipboard = "unnamedplus"

vim.cmd [[ set noswapfile ]]

-- Highlight on yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)

-- Close location list when navigating out by cr
vim.api.nvim_exec([[
autocmd FileType qf nmap <buffer> <cr> <cr>:lcl<cr>
]], false)

-- Diagnostics
vim.diagnostic.config({
  virtual_text = {
    source = "always", -- Or "if_many"
    prefix = '■',    -- Could be '■', '▎', 'x'
  },
  severity_sort = true,
  float = {
    source = "always", -- Or "if_many"
  },
})

-- Close neotree fs viewer and exit if it is the last window open
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local invalid_win = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("neotree filesystem") ~= nil then
        table.insert(invalid_win, w)
      end
    end
    if #invalid_win == #wins - 1 then
      -- Should quit, so we close all invalid windows.
      for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
    end
  end
})
