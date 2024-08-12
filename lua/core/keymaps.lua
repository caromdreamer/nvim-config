vim.g.mapleader = ","

local keymap = vim.keymap

keymap.set("n", "<leader>w", "<cmd>BufExplorer<CR>")
keymap.set("n", "<leader>n", ":NERDTree<CR>")
keymap.set("n", "<c-h>", "<c-w>h")
keymap.set("n", "<c-l>", "<c-w>l")
keymap.set("n", "<c-k>", "<c-w>k")
keymap.set("n", "<c-j>", "<c-w>j")
keymap.set("n", "<leader>e", "<cmd>Telescope find_files<cr>")
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>")
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")
keymap.set("n", "8", "<C-u>zz")
keymap.set("n", "9", "<C-d>zz")
keymap.set("v", "8", "<C-u>zz")
keymap.set("v", "9", "<C-d>zz")
vim.keymap.set("n", "<leader>feR", "<cmd>luafile ~/.config/nvim/init.lua<CR>")
vim.keymap.set("n", "<leader>fed", "<cmd>e ~/.config/nvim/<CR>")
vim.keymap.set("n", "<leader>r", "<cmd>cd %:p:h<CR>")
vim.keymap.set("n", "<left>", "<c-w><")
vim.keymap.set("n", "<right>", "<c-w>>")
vim.keymap.set("n", "<down>", "<c-w>-")
vim.keymap.set("n", "<up>", "<c-w>+")

-- terminal
vim.keymap.set("n", "\\\\", "<cmd>bel sp | resize 10 | terminal<CR>")
vim.keymap.set("t", "<esc>", "<C-\\><C-N>")
vim.keymap.set("t", "<c-k>", "<C-\\><C-n><c-w>k")
vim.keymap.set("t", "<c-j>", "<C-\\><C-n><C-w>j")


keymap.set("n", "<leader>to", ":tabnew<CR>")
keymap.set("n", "<leader>tx", ":tabclose<CR>")
keymap.set("n", "<leader>tp", ":tabp<CR>")
keymap.set("n", "<leader>tn", ":tabn<CR>")


vim.opt.mouse = "a"
vim.opt.updatetime = 1000
-- tnoremap <C-w>j <C-\><C-n><C-w>j

-- tnoremap <C-w>k <C-\><C-n><C-w>k


