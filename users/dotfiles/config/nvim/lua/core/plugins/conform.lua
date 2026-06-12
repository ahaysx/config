return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  config = function()
    local conform = require('conform')
    conform.setup({
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" }, -- sort imports, then format
        lua    = { "injected" },
        rust   = { "injected" },
        nix    = { "injected" },
      },
      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = true, -- fallback to LSP for filetypes not listed above
      },
    })

    vim.keymap.set({ 'n', 'x' }, 'gq', function()
      conform.format({ async = false, timeout_ms = 2000 })
    end)
  end
}
