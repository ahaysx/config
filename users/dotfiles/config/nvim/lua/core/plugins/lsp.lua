return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  dependencies = {
    -- LSP Support
    { 'neovim/nvim-lspconfig' },
    {
      'williamboman/mason.nvim',
      build = function()
        pcall(vim.cmd, 'MasonUpdate')
      end,
    },
    { 'williamboman/mason-lspconfig.nvim' },

    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'L3MON4D3/LuaSnip' },

    -- Improve nvim-cmp
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-buffer' },
    { 'lukas-reineke/cmp-under-comparator' },
    { 'hrsh7th/cmp-nvim-lsp' },
  },
  config = function()
    local lsp = require('lsp-zero').preset({
      manage_nvim_cmp = {
        set_sources = 'lsp',
        set_basic_mappings = true,
        set_extra_mappings = true,
        use_luasnip = true,
        set_format = true,
        documentation_window = true,
      }
    })

    lsp.on_attach(function(client, bufnr)
      -- goto: https://github.com/VonHeikemen/lsp-zero.nvim#keybindings
      -- Autocomplete: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/autocomplete.md#basic-mappings
      lsp.default_keymaps({ buffer = bufnr })


      -- Rename symbol
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

      -- Code actions
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      -- vim.keymap.set('v', '<leader>ca', vim.lsp.buf.range_code_action, opts) -- For visual mode
    end)

    -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
    lsp.ensure_installed({
      'basedpyright',
      'rust_analyzer',
      'lua_ls',
      'gopls',
      'terraformls',
      'nil_ls',
      'clangd',
      'ruff'
      -- Requires npm
      -- 'yamlls',
      -- 'jsonls'
    })


    -- Configure lua language server for neovim
    require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

    -- Tone down basedpyright's aggressive type checking
    require('lspconfig').basedpyright.setup({
      settings = {
        basedpyright = {
          typeCheckingMode = "standard"
        }
      }
    })


    -- Speficically require clangd since it can't be installed via Mason on ARM64
    require 'lspconfig'.clangd.setup {}

    lsp.setup()

    local cmp = require('cmp')
    local cmp_buffer = require('cmp_buffer')
    local cmp_action = require('lsp-zero').cmp_action()

    cmp.setup({
      mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
      },

      sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'buffer',  keyword_length = 3 },
        { name = 'luasnip', keyword_length = 2 },
      },

      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          require('cmp-under-comparator').under,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
          function(...) return cmp_buffer:compare_locality(...) end,
        }
      },
    })
  end
}
