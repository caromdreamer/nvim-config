-- LSP: Neovim 0.11+ / nvim-lspconfig v3 전 `require("lspconfig")` 대신 vim.lsp.config + vim.lsp.enable
-- (:help lspconfig-nvim-0.11)

--- LSP Position 전 순서 (0.11에서 vim.lsp.util.compare_positions 제거됨)
local function position_before(a, b)
	if a.line < b.line then
		return true
	end
	if a.line > b.line then
		return false
	end
	return a.character < b.character
end

---@param pos lsp.Position
---@param range lsp.Range
local function position_in_range(pos, range)
	if not range or not range.start or not range["end"] then
		return false
	end
	-- range["end"] 는 LSP 기준 exclusive → [start, end)
	if position_before(pos, range.start) then
		return false
	end
	if not position_before(pos, range["end"]) then
		return false
	end
	return true
end

--- textDocument/definition 응답 → Location|LocationLink 배열 (0.11에서 util.locations_from_result 제거됨)
local function locations_from_definition_result(result)
	if not result then
		return {}
	end
	if vim.islist(result) then
		return result
	end
	return { result }
end

--- IDE처럼: 심볼 정의(선언) 위에 있으면 레퍼런스, 사용처에 있으면 정의로 이동
local function smart_gd()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	local enc = (clients[1] and clients[1].offset_encoding) or "utf-16"
	local params = vim.lsp.util.make_position_params(0, enc)
	vim.lsp.buf_request_all(bufnr, "textDocument/definition", params, function(results)
		local locations = {}
		for client_id, resp in pairs(results) do
			if resp.error == nil and resp.result then
				local locs = locations_from_definition_result(resp.result)
				vim.list_extend(locations, locs)
			end
		end

		local ok_telescope, tb = pcall(require, "telescope.builtin")
		local function show_refs()
			if ok_telescope then
				tb.lsp_references({ include_declaration = false })
			else
				vim.lsp.buf.references({ includeDeclaration = false })
			end
		end

		local cur_uri = vim.uri_from_bufnr(bufnr)
		local pos = params.position

		for _, loc in ipairs(locations) do
			local uri = loc.uri or loc.targetUri
			-- LocationLink: targetSelectionRange는 식별자만, targetRange가 본문 포함 전체 → 본문에 커서 있을 때도 "정의 위"로 보려면 targetRange 우선
			local range = loc.range or loc.targetRange or loc.targetSelectionRange
			if uri == cur_uri and range and position_in_range(pos, range) then
				show_refs()
				return
			end
		end

		vim.lsp.buf.definition()
	end)
end

local function lsp_references_telescope()
	local ok, tb = pcall(require, "telescope.builtin")
	if ok then
		tb.lsp_references({ include_declaration = true })
	else
		vim.lsp.buf.references({ includeDeclaration = true })
	end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(_, bufnr)
	local opts = { noremap = true, silent = true }
	local buf_set_keymap = vim.api.nvim_buf_set_keymap

	buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap(bufnr, "n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	vim.keymap.set("n", "gd", smart_gd, { buffer = bufnr, silent = true, desc = "정의 이동 / 정의 위치면 레퍼런스" })
	vim.keymap.set("n", "gr", lsp_references_telescope, { buffer = bufnr, silent = true, desc = "LSP references" })
	buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
	buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
	buf_set_keymap(bufnr, "n", "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
	buf_set_keymap(bufnr, "n", "<leader>dc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
	buf_set_keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
	buf_set_keymap(bufnr, "n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts)
	buf_set_keymap(bufnr, "n", "gp", "<cmd>Lspsaga peek_definition<CR>", opts)
	-- def+ref 한번에 보고 싶을 때
	buf_set_keymap(bufnr, "n", "<leader>gf", "<cmd>Lspsaga finder def+ref<CR>", opts)
end

for _, name in ipairs({ "pyright", "ts_ls", "gopls" }) do
	vim.lsp.config(name, {
		capabilities = capabilities,
		on_attach = on_attach,
	})
	vim.lsp.enable(name)
end
