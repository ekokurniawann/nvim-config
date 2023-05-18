return {
	{
		"echasnovski/mini.nvim",
		version = "*",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("mini.indentscope").setup()
			require('mini.comment').setup()
			require('mini.bracketed').setup()
			require('mini.bufremove').setup({
        silent = true,
      })
			require('mini.move').setup()
			require('mini.tabline').setup()
			require('mini.statusline').setup()
      require('mini.pairs').setup()
		end,
	},
}
