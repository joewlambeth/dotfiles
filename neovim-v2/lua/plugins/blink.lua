vim.pack.add({
	gh("saghen/blink.lib"),
	gh("saghen/blink.cmp"),
})

local cmp = require("blink.cmp")
cmp.build():wait(60000)
cmp.setup({
	keymap = { preset = "default" },
	completion = {
		accept = {
			-- Enable auto-brackets to automatically jump into ()
			auto_brackets = { enabled = true },
			create_undo_point = true,
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200, -- Delay before showing
			window = {
				border = "rounded", -- Recommended for better visibility
			},
		},
	},
	signature = { enabled = true },
})
