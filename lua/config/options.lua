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
