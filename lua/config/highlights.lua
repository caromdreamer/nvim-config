-- ColorScheme 이후: 어떤 테마든 Vim 기본 그룹(Function, Type 등)을 resolve 해서만 덧칠 (팔레트 이름에 비의존)

local HL_KEYS = {
	fg = true,
	bg = true,
	sp = true,
	bold = true,
	standout = true,
	underline = true,
	undercurl = true,
	underdouble = true,
	underdotted = true,
	underdashed = true,
	strikethrough = true,
	italic = true,
	reverse = true,
	nocombine = true,
	blend = true,
	ctermfg = true,
	ctermbg = true,
	cterm = true,
}

--- 링크를 따라가며 실제 속성만 모은다. 칠할 속성이 없으면 nil.
local function hl_resolved(name)
	local ok, h = pcall(vim.api.nvim_get_hl, 0, { name = name, link = true })
	if not ok or type(h) ~= "table" then
		return nil
	end
	local out = {}
	for k, v in pairs(h) do
		if HL_KEYS[k] and v ~= nil then
			out[k] = v
		end
	end
	if out.fg == nil and out.bg == nil and out.ctermfg == nil and out.ctermbg == nil and out.cterm == nil then
		return nil
	end
	return out
end

local function first_resolved(names)
	for _, n in ipairs(names) do
		local a = hl_resolved(n)
		if a then
			return a
		end
	end
	return nil
end

local function strengthen_functions()
	local fn_like = first_resolved({ "Function", "Statement", "Identifier" })
	local type_like = first_resolved({ "Type", "Function", "Identifier" })

	if fn_like then
		-- 호출: 테마가 쓰는 함수색 + 굵게
		local call = vim.tbl_extend("force", fn_like, { bold = true, default = false })
		vim.api.nvim_set_hl(0, "@function.call", call)
		vim.api.nvim_set_hl(0, "@function.method.call", call)
		vim.api.nvim_set_hl(0, "@method.call", call)
		vim.api.nvim_set_hl(0, "@lsp.type.function", call)
		vim.api.nvim_set_hl(0, "@lsp.type.method", call)
		-- 정의 이름: 같은 계열 + 이탤릭으로 호출과 구분
		local decl = vim.tbl_extend("force", fn_like, { italic = true, default = false })
		vim.api.nvim_set_hl(0, "@function", decl)
	end

	if type_like then
		vim.api.nvim_set_hl(
			0,
			"@function.method",
			vim.tbl_extend("force", type_like, { italic = true, default = false })
		)
	end
end

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = strengthen_functions,
})
