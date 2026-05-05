-- 외부 colorscheme 플러그인 선택 (packer에 해당 플러그인이 있어야 함)
-- 지원: "tokyonight" | "gruvbox" | "catppuccin"
-- 더 쓰고 싶으면 packer에 플러그인 추가 후 아래 M.apply()에 분기만 넣으면 됨.
--   예: rebelot/kanagawa.nvim → colorscheme "kanagawa-wave"
--   예: rose-pine/neovim (as rose-pine) → colorscheme "rose-pine"
--   예: EdenEast/nightfox.nvim → colorscheme "nightfox" | "carbonfox" 등

local M = {}

M.scheme = "tokyonight"

function M.apply()
	local s = M.scheme
	if s == "tokyonight" then
		require("tokyonight").setup({
			style = "storm", -- storm | moon | night | day
			terminal_colors = true,
		})
		vim.cmd.colorscheme("tokyonight-day")
	elseif s == "gruvbox" then
		pcall(require("gruvbox").setup, {
			contrast = "hard", -- soft | medium | hard
			italic = {
				strings = true,
				comments = true,
				folds = true,
			},
		})
		vim.cmd.colorscheme("gruvbox")
	elseif s == "catppuccin" then
		require("catppuccin").setup({
			flavour = "latte", -- latte | frappe | macchiato | mocha
		})
		vim.cmd.colorscheme("catppuccin")
	elseif s == "retrobox" then
		vim.cmd.colorscheme("retrobox")
	else
		vim.notify(("[theme] 알 수 없는 scheme: %s → tokyonight"):format(tostring(s)), vim.log.levels.WARN)
		require("tokyonight").setup({ style = "storm", terminal_colors = true })
		vim.cmd.colorscheme("tokyonight")
	end
end

return M
