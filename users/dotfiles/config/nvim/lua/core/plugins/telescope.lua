function open_online_doc()
  local word = vim.fn.expand("<cword>")
  if not word or word == "" then
    print("No word under cursor")
    return
  end

  -- Prefer man7.org (POSIX); fallback is cppreference
  local posix_url = "https://man7.org/linux/man-pages/man3/" .. word .. ".3.html"
  local fallback_url = "https://en.cppreference.com/mwiki/index.php?search=" .. word

  -- macOS uses 'open', Linux uses 'xdg-open'
  local opener = vim.fn.has("mac") == 1 and "open" or "xdg-open"
  local handle = io.popen("curl -s -o /dev/null -w '%{http_code}' " .. posix_url)
  local code = handle:read("*a")
  handle:close()

  local url = code == "200" and posix_url or fallback_url
  os.execute(opener .. " " .. url)
end


return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fs', builtin.grep_string, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})
    vim.keymap.set('n', '<leader>ft', builtin.treesitter, {})
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
    vim.keymap.set('n', '<leader>fS', builtin.lsp_document_symbols, {})
    -- Search for the word under the cursor in the project.
    vim.keymap.set('n', '<leader>pws', function()
      local word = vim.fn.expand('<cword>')
      builtin.grep_string({ search = word })
    end)
    -- Search for the WORD under the cursor in the project.
    vim.keymap.set('n', '<leader>pWs', function()
      local word = vim.fn.expand('<cWORD>')
      builtin.grep_string({ search = word })
    end)
    -- vim.keymap.set('n', 'gm', builtin.man_pages, {})
    vim.keymap.set('n', 'gm', function()
      local word = vim.fn.expand('<cword>')
      builtin.man_pages({
        sections = { '3' }, -- section 3 for C library functions
        query = word,
        default_text = word,
      })
    end, { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>d", function()
      open_online_doc()
    end, { desc = "Open online C doc for word under cursor" })

    -- LSP
    vim.keymap.set('n', 'gr', builtin.lsp_references, {})
    vim.keymap.set('n', 'gi', builtin.lsp_implementations, {})
    vim.keymap.set('n', 'gd', builtin.lsp_definitions, {})
    vim.keymap.set('n', 'go', builtin.lsp_type_definitions, {})

    telescope.setup {
      defaults = {
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
          horizontal = {
            width_padding = 0.04,
            height_padding = 0.1,
            preview_width = 0.6,
          },
          vertical = {
            width_padding = 0.05,
            height_padding = 1,
            preview_height = 0.5,
          },
        },
        file_ignore_patterns = {
          "%.svg",
          "%.bmp",
          "%.jpg",
          "%.jpeg",
          "%.gif",
          "%.png",
        },
        mappings = {
          i = {
            -- actions.which_key shows the mappings for your picker
            ["<C-h>"] = "which_key",
            ['<esc>'] = actions.close,
          }
        }
      },

      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
        live_grep = {
          only_sort_text = true, -- don't include the filename in the search results
        },
        grep_string = {
          -- Setup for fuzzy text search
          shorten_path = true,
          word_match = "-w",
          only_sort_text = true,
          search = ''
        },
      },

      extensions = {
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        }
      }
    }

    telescope.load_extension('fzf')
  end
}
