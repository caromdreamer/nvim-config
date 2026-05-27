-- packer_compiled이 오래되어도 Treesitter 하이라이트가 켜지도록 init에서 로드
local ok = pcall(require, "nvim-treesitter.configs")
if not ok then
	return
end

require("nvim-treesitter").setup()
require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	ensure_installed = { "go", "gomod", "gowork", "lua", "vim", "vimdoc", "query" },
	auto_install = true,
})
