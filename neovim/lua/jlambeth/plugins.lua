return {
  {
    'tadmccorkle/markdown.nvim',
    ft = 'markdown', -- or 'event = "VeryLazy"'
    opts = {
      -- configuration here or empty for defaults
    },
    config = function()
      require('markdown').setup {
        on_attach = function(bufnr)
          local opts = { buffer = bufnr }

          -- require('markdown.list').insert_list_item_below()
          local do_set = function(key, command)
            vim.keymap.set({ 'n' }, key, function()
              if command() then
                return
              end

              -- otherwise act exactly like pressing 'o' <count> times and enter insert mode
              local cnt = vim.v.count1 -- 1 when no count given, preserves counts like 3o
              vim.cmd('normal! ' .. cnt .. key) -- runs the builtin 'o' with the count
              vim.cmd 'startinsert' -- ensure we are in insert mode
            end, opts)
          end

          do_set('o', require('markdown.list').insert_list_item_below)
          do_set('O', require('markdown.list').insert_list_item_above)
        end,
      }
    end,
  },
  {
    'lervag/wiki.vim',
    tag = 'v0.10',
    init = function()
      vim.g.wiki_root = '~/wiki'
    end,
    config = function()
      vim.keymap.set('n', '<leader>wt', ':WikiJournal<CR>')
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sw', function()
        builtin.live_grep {
          cwd = '~/wiki',
        }
      end, { desc = '[S]earch [W]iki' })

      vim.keymap.set('n', '<leader>sa', function()
        require('wiki.telescope').pages {
          file_ignore_patterns = {
            '%journal/*',
          },
        }
      end, { desc = '[S]earch [A]rticles' })

      vim.keymap.set('n', '<leader>lw', function()
        require('wiki.telescope').links('insert', {
          file_ignore_patterns = {
            '%journal/*',
          },
        })
      end, { desc = '[L]ink [W]iki', remap = true })
    end,
  },
  {
    'lervag/lists.vim',
    init = function()
      vim.g.lists_filetypes = { 'md' }
    end,
    config = function()
      vim.keymap.set('n', '<leader>tl', ':ListsToggle<CR>', { desc = '[T]oggle [L]ist' })
    end,
  },
  -- 'MeanderingProgrammer/render-markdown.nvim',
  --'qadzek/link.nvim',
  --
}
