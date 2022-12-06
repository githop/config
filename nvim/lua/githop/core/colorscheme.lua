local colorscheme = "everforest"

vim.g.everforest_background = "hard"
vim.g.everforest_better_performance = 1

local status, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status then
	print("Colorscheme not found")
	return
end
