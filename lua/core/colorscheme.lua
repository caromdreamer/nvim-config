-- gruvbox.nvim 은 Packer 이후에만 rtp에 올라옴. 여기서는 내장 테마만 안전하게 적용.
local builtins = { "habamax", "slate", "default" }
for _, name in ipairs(builtins) do
	if pcall(vim.cmd, "colorscheme " .. name) then
		break
	end
end
