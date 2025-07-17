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
      vim.keymap.set('n', '<leader>ws', function()
        builtin.find_files { cwd = '~/wiki' }
      end, { desc = '[W]iki [S]earch' })
    end,
  },
  --'qadzek/link.nvim',
}
