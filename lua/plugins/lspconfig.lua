-- LSP configuration
local lspconfig = require'lspconfig'

local on_attach = function(client, bufnr)
  local buf_set_keymap = vim.api.nvim_buf_set_keymap
  local opts = { noremap=true, silent=true }
  local keymap = vim.api.nvim_buf_set_keymap

  -- Go to definition
  -- buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- Other useful keymaps can be added here, keymap.set("n", "gr", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
  buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
  -- keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
  buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
  buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts) -- show references
  buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
  buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
  buf_set_keymap(bufnr, "n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
  buf_set_keymap(bufnr, "n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
  buf_set_keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
  buf_set_keymap(bufnr, "n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side
  buf_set_keymap(bufnr, 'n', 'gd', '<cmd>Lspsaga finder def+ref<CR>', opts) -- 정의 및 참조 찾기
  buf_set_keymap(bufnr, 'n', 'gp', '<cmd>Lspsaga peek_definition<CR>', opts) -- 정의 미리보기 및 창에서 수정
end

-- LSP server configurations
lspconfig.pyright.setup{
  on_attach = on_attach,
}

lspconfig.ts_ls.setup{
  on_attach = on_attach,
}

lspconfig.gopls.setup{
  on_attach = on_attach,
}

