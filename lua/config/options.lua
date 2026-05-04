local opt = vim.opt

opt.number = true

opt.wrap = false

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

opt.termguicolors = true
opt.signcolumn = "yes"

opt.backspace = "indent,eol,start"

opt.clipboard:append("unnamedplus")
opt.autochdir = false

-- 터미널(AI CLI 등)이 디스크의 파일을 바꾼 뒤, 포커스/터미널 나올 때 다시 읽기 (IDE 자동 반영에 가깝게)
opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "TermLeave", "TermClose" }, {
	callback = function()
		if vim.fn.getcmdwintype() == "" then
			vim.cmd("checktime")
		end
	end,
})

-- IDE에 가까운 자동 저장: Neovim에서도 어렵지 않음 (:w를 언제 칠지 정하는 문제)
-- 1) 다른 버퍼로 넘어갈 때 등 수정분 기록 (:help 'autowrite')
opt.autowrite = true
-- 2) 삽입 모드에서 나올 때 현재 파일만 저장 (scratch·퀵픽 제외). 싫으면 이 블록만 지우면 됨.
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	callback = function()
		local bo = vim.bo
		if not bo.modified or not bo.buflisted or bo.buftype ~= "" then
			return
		end
		if vim.api.nvim_buf_get_name(0) == "" then
			return
		end
		vim.cmd({ cmd = "update", mods = { emsg_silent = true } })
	end,
})
