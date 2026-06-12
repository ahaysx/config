-- NOTE: mapleader is set in lazy.lua

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('n', '<leader>v', ':e $MYVIMRC<CR>')
map('n', '<leader>sv', ':source $MYVIMRC<CR>')

-- Diagnostics
map('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
map('n', 'd[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
map('n', 'd]', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
map('n', '<space>d', '<cmd>lua vim.diagnostic.config({virtual_text = not vim.diagnostic.config().virtual_text})<CR>',
  { silent = true, noremap = true })

-- The following command requires plug-ins "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", and optionally "kyazdani42/nvim-web-devicons" for icon support
--map('n', 'dd', '<cmd>Telescope diagnostics<CR>', { noremap = true, silent = true })
-- If you don't want to use the telescope plug-in but still want to see all the errors/warnings, comment out the telescope line and uncomment this:
map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

-- Neotree
map('n', '<leader>fe', '<cmd>Neotree toggle<CR>', { noremap = true, silent = true })

-- Duplicate line
map('n', '<leader>y', 'yyp', { noremap = true, silent = true })

-- On a blank line, use cc instead of i so treesitter picks the right indent
vim.keymap.set('n', 'i', function()
  if vim.fn.match(vim.fn.getline('.'), '\\S') == -1 then
    return '"_cc'
  else
    return 'i'
  end
end, { expr = true })

vim.o.makeprg = "make"
vim.o.errorformat = "%f:%l:%c: %m"

-- Compile and open quickfix
vim.keymap.set("n", "<leader>m", function()
  vim.cmd("make")
  vim.cmd("cwindow")
end, { desc = "Make and show errors" })

-- Run the program in a terminal split
vim.keymap.set("n", "<leader>r", function()
  vim.cmd("split | terminal ./main")
end, { desc = "Run ./main in terminal split" })

-- Build then run only if compilation succeeds
-- vim.keymap.set("n", "<leader>b", function()
--   vim.cmd("make")
--   if vim.v.shell_error == 0 then
--     vim.cmd("split | terminal")
--   else
--     vim.cmd("cwindow")
--   end
-- end, { desc = "Build and run if successful" })
vim.keymap.set("n", "<leader>b", function()
  local current_dir = vim.fn.getcwd()          -- Save current working directory
  local file_dir = vim.fn.expand("%:p:h")       -- Get directory of current file
  vim.cmd("lcd " .. file_dir)                   -- Change to file's directory

  vim.cmd("make")                               -- Run make

  if vim.v.shell_error == 0 then
    vim.cmd("lcd " .. current_dir)              -- Restore original directory
    vim.cmd("split | terminal")                 -- Open terminal
  else
    vim.cmd("lcd " .. current_dir)              -- Restore even if make failed
    vim.cmd("cwindow")                          -- Show quickfix window
  end
end, { desc = "Build and run if successful" })

-- Map <Esc><Esc> in terminal mode to close the terminal split
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>:q<CR>]], { buffer = true })
  end
})
