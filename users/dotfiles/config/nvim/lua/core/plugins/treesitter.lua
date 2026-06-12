return {
  -- https://github.com/nvim-treesitter/nvim-treesitter
  'nvim-treesitter/nvim-treesitter',
  build = function()
    require('nvim-treesitter.install').update({ with_sync = true })
  end,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require('nvim-treesitter.configs').setup {
      highlight = {
        enable = true
      },
      indent = {
        enable = true,
        -- treesitter's python indent over-indents (e.g. o inside a function
        -- body); vim's built-in python indent is more reliable
        disable = { "python" }
      },
      ensure_installed = {
        "c",
        "clojure",
        "go",
        "java",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "vim",
        "vimdoc",
        "query",
        -- broken!
        -- "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    }
  end
}
