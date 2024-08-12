local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugin-setup.lua source <afile> | PackerSync
augroup end]])

local status, packer = pcall(require, "packer")
if not status then
	return
end

return require("packer").startup(function(use)
	use("github/copilot.vim")
	use("wbthomason/packer.nvim")
	use("neovim/nvim-lspconfig")
	-- use("hrsh7th/nvim-cmp")
	use({
		"hrsh7th/nvim-cmp",
		config = function() 
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-p>"] = cmp.mapping.select_prev_item(), -- previous suggestion
					["<C-n>"] = cmp.mapping.select_next_item(), -- next suggestion
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				},
			})
		end,
	})
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("saadparwaiz1/cmp_luasnip")
	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets")
	use({"nvim-telescope/telescope.nvim", config = function()
		require("telescope").setup({})
	end})
	use("nvim-lua/plenary.nvim")
	use({"hoob3rt/lualine.nvim", config = function()
		-- Lualine
		require("lualine").setup({
			options = { theme = "gruvbox" },
		})
	end})
	use({'ray-x/go.nvim', config = function() 
		vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').gofumpt() ]], false)
		require('go').setup()
	end})

	use("nvim-treesitter/nvim-treesitter")
	use({"lewis6991/gitsigns.nvim", config = function()
		require("gitsigns").setup()
	end})
	use("ellisonleao/gruvbox.nvim")
	use("preservim/nerdtree")
	-- use("numToStr/Comment.nvim")
	use({"numToStr/Comment.nvim", config = function() 
		local setup, comment = pcall(require, "Comment")
		if not setup then 
			return
		end
		comment.setup()
	end})

	use({ "jlanzarotta/bufexplorer", config = function() end })
	use ({
		'nvimdev/lspsaga.nvim',
		after = 'nvim-lspconfig',
		config = function()
			require('lspsaga').setup({})
		end,
	})
	-- use { 'hsnks100/lspsaga.nvim', branch = 'main'}
	if packer_bootstrap then
		require("packer").sync()
	end
end)
