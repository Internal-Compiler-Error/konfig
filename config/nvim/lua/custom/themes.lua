return {
	-- Themes
	-- { "ellisonleao/gruvbox.nvim", priority = 1000 },
	{ "rose-pine/neovim", name = "rose-pine", priority = 1000 },
	{
		"sainnhe/everforest",
		-- lazy = false,
		priority = 1000,
		config = function()
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			vim.g.everforest_enable_italic = true
		end,
	},
	{ -- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
		"folke/tokyonight.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- Load the colorscheme here.
			-- Like many other themes, this one has different styles, and you could load
			-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
			-- vim.cmd.colorscheme("tokyonight-night")

			-- You can configure highlights by doing something like
			vim.cmd.hi("Comment gui=none")
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
	},
	-- {
	-- 	"sainnhe/gruvbox-material",
	-- 	priority = 1000,
	-- },
	{
		"luisiacc/gruvbox-baby",
		priority = 1000,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},
}
-- vim: ts=2 sts=2 sw=2 et
