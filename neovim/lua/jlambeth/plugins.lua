return {
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
