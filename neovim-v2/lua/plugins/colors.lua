vim.pack.add({
	"https://github.com/sainnhe/everforest",
})

vim.g.everforest_enable_italic = true
vim.g.everforest_background = "hard"
vim.cmd.colorscheme("everforest")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatTitle", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatFooter", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

vim.api.nvim_set_hl(0, "StGit", { bg = "#55544a", fg = "#ebdbb2" })
vim.api.nvim_set_hl(0, "StFile", { bg = "#3c4841", fg = "#fbf1c7" })
vim.api.nvim_set_hl(0, "StFlags", { bg = "#665c54", fg = "#fbf1c7" })
vim.api.nvim_set_hl(0, "StMid", { bg = "#282828", fg = "#a89984" })
vim.api.nvim_set_hl(0, "StAFYes", { bg = "#3f5865", fg = "#fbf1c7" })
vim.api.nvim_set_hl(0, "StAFNo", { bg = "#59464c", fg = "#fbf1c7" })
vim.api.nvim_set_hl(0, "StPos", { bg = "#b16286", fg = "#fbf1c7" })
