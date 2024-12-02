-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local keymap = vim.keymap

-- 창 이동 단축키
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
keymap.set("n", "<C-l>", "<C-w>l")

-- Telescope 단축키
keymap.set("n", "<leader>e", "<cmd>Telescope find_files<CR>")
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<CR>")
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<CR>")

-- 스크롤과 커서 위치 조정
keymap.set("n", "8", "<C-u>zz")
keymap.set("n", "9", "<C-d>zz")
keymap.set("v", "8", "<C-u>zz")
keymap.set("v", "9", "<C-d>zz")

-- 설정 파일 관련 단축키
keymap.set("n", "<leader>feR", "<cmd>luafile ~/.config/nvim/init.lua<CR>")
keymap.set("n", "<leader>fed", "<cmd>e ~/.config/nvim/<CR>")
keymap.set("n", "<leader>r", "<cmd>cd %:p:h<CR>")

-- 창 크기 조정
keymap.set("n", "<Left>", "<C-w><")
keymap.set("n", "<Right>", "<C-w>>")
keymap.set("n", "<Up>", "<C-w>+")
keymap.set("n", "<Down>", "<C-w>-")

-- 터미널 단축키
keymap.set("n", "\\\\", "<cmd>bel sp | resize 10 | terminal<CR>")
keymap.set("t", "<Esc>", "<C-\\><C-n>")
keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")
keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")

-- 탭 관리 단축키
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>")
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>")
keymap.set("n", "<leader>tp", "<cmd>tabprevious<CR>")
keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>")
