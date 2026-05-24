vim.g.mapleader = ","

local keymap = vim.keymap

keymap.set("n", "<leader>w", "<cmd>BufExplorer<CR>", { desc = "BufExplorer" })
keymap.set("n", "<leader>n", "<cmd>Neotree toggle filesystem left reveal<CR>", { desc = "Neo-tree 파일" })
keymap.set("n", "<leader>nb", "<cmd>Neotree toggle buffers left<CR>", { desc = "Neo-tree 버퍼" })
keymap.set("n", "<leader>as", "<cmd>ASToggle<CR>", { desc = "자동 저장 토글" })
keymap.set("n", "<c-h>", "<c-w>h")
keymap.set("n", "<c-l>", "<c-w>l")
keymap.set("n", "<c-k>", "<c-w>k")
keymap.set("n", "<c-j>", "<c-w>j")
keymap.set("n", "<leader>e", "<cmd>Telescope find_files<cr>", { desc = "파일 찾기" })
-- live_grep 기본은 정규식; 코드 한 줄 통째 검색은 -F 리터럴이 낫다
keymap.set("n", "<leader>fs", function()
	require("telescope.builtin").live_grep({ additional_args = { "-F" } })
end, { desc = "live grep" })
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "커서 단어 grep" })
keymap.set("n", "<leader>fk", function()
	require("telescope.builtin").keymaps({ modes = { "n", "i", "c", "x", "v" } })
end, { desc = "키맵 검색" })
vim.keymap.set("n", "<leader>?", function()
	require("which-key").show({ global = false })
end, { desc = "이 버퍼 키맵(which-key)" })
-- Git: 변경 파일 목록 / 워킹트리 diff (IDE 소스 제어·diff 뷰에 가깝게)
-- Diffview는 Ex 명령이 아직 없을 수 있어(설치 전·로드 전) Lua API로 직접 호출
local function diffview_run(fn)
	local ok, dv = pcall(require, "diffview")
	if not ok or dv == nil then
		vim.notify(
			"diffview.nvim을 불러올 수 없습니다. Neovim에서 :PackerSync 실행 후 재시작하세요.",
			vim.log.levels.ERROR
		)
		return
	end
	fn(dv)
end

keymap.set("n", "<leader>gs", "<cmd>Neotree toggle git_status right<cr>", { desc = "Git 변경 사이드바" })
vim.keymap.set("n", "<leader>gv", function()
	diffview_run(function(dv)
		dv.open()
	end)
end, { desc = "Diffview 워킹트리" })
vim.keymap.set("n", "<leader>gh", function()
	diffview_run(function(dv)
		dv.file_history(nil, { "%" })
	end)
end, { desc = "Diffview 현재 파일 히스토리" })
vim.keymap.set("n", "<leader>gx", function()
	diffview_run(function(dv)
		dv.close()
	end)
end, { desc = "Diffview 닫기" })
-- Neogit: 에디터 안 소스컨트롤(diffview/telescope 연동). Lazygit은 터미널 외부에서 단독 사용.
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" })
vim.keymap.set("n", "<leader>gC", "<cmd>Neogit cwd=%:p:h<cr>", { desc = "Neogit (현재 파일 기준 레포)" })
-- 한 nvim = 한 레포면 보통 레포 루트에서 nvim만 켜면 됨. cwd만 하위에 멈춘 경우 등에 git 루트로 맞출 때
local function git_root_of_buffer()
	local anchor = vim.api.nvim_buf_get_name(0)
	if anchor == "" then
		anchor = vim.fn.getcwd()
	end
	if vim.fs and vim.fs.root then
		return vim.fs.root(anchor, ".git")
	end
	local dir = vim.fn.isdirectory(anchor) == 1 and anchor or vim.fn.fnamemodify(anchor, ":p:h")
	local out = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--show-toplevel" })
	if vim.v.shell_error == 0 and out[1] and out[1] ~= "" then
		return vim.trim(out[1])
	end
	return nil
end

vim.keymap.set("n", "<leader>cd", function()
	local root = git_root_of_buffer()
	if root then
		vim.cmd("cd " .. vim.fn.fnameescape(root))
		vim.notify("cd → " .. vim.fn.fnamemodify(root, ":~"), vim.log.levels.INFO)
	else
		vim.notify("상위에 .git이 없습니다.", vim.log.levels.WARN)
	end
end, { desc = "cwd를 git 루트로" })
keymap.set("n", "8", "<C-u>zz")
keymap.set("n", "9", "<C-d>zz")
keymap.set("v", "8", "<C-u>zz")
keymap.set("v", "9", "<C-d>zz")
vim.keymap.set("n", "<leader>feR", "<cmd>luafile ~/.config/nvim/init.lua<CR>", { desc = "init.lua 다시 로드" })
vim.keymap.set("n", "<leader>fed", "<cmd>e ~/.config/nvim/<CR>", { desc = "설정 폴더 열기" })
vim.keymap.set("n", "<leader>r", "<cmd>cd %:p:h<CR>", { desc = "cwd → 버퍼 디렉터리" })
vim.keymap.set("n", "<left>", "<c-w><")
vim.keymap.set("n", "<right>", "<c-w>>")
vim.keymap.set("n", "<down>", "<c-w>-")
vim.keymap.set("n", "<up>", "<c-w>+")

-- 터미널: toggleterm.nvim — Normal·Terminal 모드 둘 다에서 토글
-- ,th 하단(가로) · ,tv 오른쪽(세로) · ,tt 플로팅(AI/짧은 작업 등)
vim.keymap.set({ "n", "t" }, "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "터미널(가로)" })
vim.keymap.set({ "n", "t" }, "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "터미널(세로)" })
vim.keymap.set({ "n", "t" }, "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", { desc = "터미널(플로트)" })
-- 터미널에서 <Esc>를 매핑하면 일부 TUI(fzf 등)에서 Esc가 전달되지 않음
vim.keymap.set("t", "<c-k>", "<C-\\><C-n><c-w>k")
vim.keymap.set("t", "<c-j>", "<C-\\><C-n><c-w>j")


keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "탭 새로" })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "탭 닫기" })
keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "이전 탭" })
keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "다음 탭" })


vim.opt.mouse = "a"
vim.opt.updatetime = 1000
