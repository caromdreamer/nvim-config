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
	use({
		"akinsho/toggleterm.nvim",
		tag = "*",
		config = function()
			require("toggleterm").setup({
				size = function(term)
					if term.direction == "horizontal" then
						return 12
					end
					if term.direction == "vertical" then
						return math.floor(vim.o.columns * 0.38)
					end
					return 20
				end,
				start_in_insert = true,
				shade_terminals = true,
				float_opts = { border = "curved", winblend = 0 },
			})
		end,
	})
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

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	})
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gs = require("gitsigns")
					vim.keymap.set("n", "]h", gs.next_hunk, { buffer = bufnr, desc = "다음 hunk" })
					vim.keymap.set("n", "[h", gs.prev_hunk, { buffer = bufnr, desc = "이전 hunk" })
					vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "hunk 미리보기" })
				end,
			})
		end,
	})
	use({
		"sindrets/diffview.nvim",
		after = "plenary.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("diffview").setup({})
		end,
	})
	-- git add -i / amend 등: 터미널 raw 보다 Lazygit TUI가 많이 쓰임 (brew install lazygit 필요)
	use({
		"kdheepak/lazygit.nvim",
		after = "plenary.nvim",
		requires = "nvim-lua/plenary.nvim",
	})
	use({
		"ellisonleao/gruvbox.nvim",
		config = function()
			-- 플러그인 설치·rtp 반영 후에만 적용 (설치 전 colorscheme 에러 방지)
			if not pcall(vim.cmd, "colorscheme gruvbox") then
				vim.notify("gruvbox 테마 적용 실패 — :PackerSync 후 재시작", vim.log.levels.WARN)
			end
		end,
	})
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
