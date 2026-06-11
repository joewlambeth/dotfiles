vim.pack.add({
	gh("kevinhwang91/promise-async"),
	gh("kevinhwang91/nvim-ufo"),
})

vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.opt.foldopen:append("search")

vim.keymap.set("n", "n", "nzzzv", { silent = true })
vim.keymap.set("n", "N", "Nzzzv", { silent = true })

vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zR", require("ufo").closeAllFolds)

require("ufo").setup({
	provider_selector = function(bufnr, filetype, buftype)
		if filetype == "markdown" then
			return require("plugins.wiki").fold
		end
		local treesitter_enabled = false
		for _, ft in ipairs(require("plugins.treesitter").filetypes) do
			if ft == filetype then
				treesitter_enabled = true
				break
			end
		end
		return { "lsp", treesitter_enabled and "treesitter" or "indent" }
	end,
	fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
		local newVirtText = {}
		local suffix = (" 󰁂 %d "):format(endLnum - lnum)
		local sufWidth = vim.fn.strdisplaywidth(suffix)
		local targetWidth = width - sufWidth
		local curWidth = 0
		for _, chunk in ipairs(virtText) do
			local chunkText = chunk[1]
			local chunkWidth = vim.fn.strdisplaywidth(chunkText)
			if targetWidth > curWidth + chunkWidth then
				table.insert(newVirtText, chunk)
			else
				chunkText = truncate(chunkText, targetWidth - curWidth)
				local hlGroup = chunk[2]
				table.insert(newVirtText, { chunkText, hlGroup })
				chunkWidth = vim.fn.strdisplaywidth(chunkText)
				-- str width returned from truncate() may less than 2nd argument, need padding
				if curWidth + chunkWidth < targetWidth then
					suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
				end
				break
			end
			curWidth = curWidth + chunkWidth
		end
		table.insert(newVirtText, { suffix, "MoreMsg" })
		return newVirtText
	end,
})
