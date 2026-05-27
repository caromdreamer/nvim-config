-- go.nvim: gopls semantic tokens (IDE 스타일 의미 하이라이트)
local ok = pcall(require, "go")
if not ok then
	return
end

require("go").setup({
	lsp_semantic_highlights = true,
})
