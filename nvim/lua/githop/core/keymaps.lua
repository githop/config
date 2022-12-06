-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make split windows equal width and height" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current split window" })
keymap.set("n", "<leader>[", ":bp<CR>", { desc = "Previous buffer" })
keymap.set("n", "<leader>]", ":bn<CR>", { desc = "Next buffer" })
-- nvim tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle nvim tree" })

-- telescope
keymap.set(
	"n",
	"<leader>ff",
	"<cmd>Telescope find_files<cr>",
	{ desc = "find files within current working directory, respects .gitignore" }
)
keymap.set(
	"n",
	"<leader>fs",
	"<cmd>Telescope live_grep<cr>",
	{ desc = "find string in current working directory as you type" }
)
keymap.set(
	"n",
	"<leader>fc",
	"<cmd>Telescope grep_string<cr>",
	{ desc = "find string under cursor in current working directory" }
)
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "list open buffers in current neovim instance" })
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "list available help tags" })
