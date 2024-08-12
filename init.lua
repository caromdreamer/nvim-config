require("core.options")
require("core.keymaps")
require("core.colorscheme")
require("plugins.plugin-setup")
require("plugins.lspconfig")
-- Colorscheme
vim.api.nvim_exec([[ autocmd BufWritePre *.go :lua require('go.format').goimport() ]], false)
