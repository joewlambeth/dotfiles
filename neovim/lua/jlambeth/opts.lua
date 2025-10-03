vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false -- Set to true if you have a Nerd Font installed and selected in the terminal

-- [[ Setting options ]]
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'nosplit'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true

-- https://www.reddit.com/r/neovim/comments/1djjc6q/statuscolumn_a_beginers_guide/

_G.MY_STATUS = function()
  local screen_height = #tostring(vim.api.nvim_win_get_height(0))
  local buffer_height = #tostring(vim.api.nvim_buf_line_count(0))
  local border = function()
    return '│'
  end

  local rnu = function()
    if vim.v.relnum == 0 then
      return string.rep(' ', screen_height)
    end
    return string.format('%' .. screen_height .. 'd', vim.v.relnum)
  end

  local text = table.concat({
    '',
    rnu(),
    string.format('%' .. buffer_height .. 'd', vim.v.lnum),
    border(),
  }, ' ')
  return text
end

vim.o.statuscolumn = '%!v:lua.MY_STATUS()'
