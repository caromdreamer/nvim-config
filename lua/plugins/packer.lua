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
autocmd BufWritePost packer.lua source <afile> | PackerSync
augroup end]])

local status, packer = pcall(require, "packer")
if not status then
	return
end

return require("packer").startup(function(use)
	use("github/copilot.vim")
	use("wbthomason/packer.nvim")
	use("neovim/nvim-lspconfig")
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
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
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
	use({
		"nvim-telescope/telescope.nvim",
		config = function()
			require("telescope").setup({})
		end,
	})
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				enable_git_status = true,
				enable_diagnostics = true,
				open_files_do_not_replace_types = { "terminal", "qf" },
				window = {
					position = "left",
					width = 32,
				},
				filesystem = {
					follow_current_file = {
						enabled = true,
						leave_dirs_open = false,
					},
					filtered_items = {
						visible = true,
						hide_dotfiles = false,
						hide_gitignored = false,
					},
				},
				git_status = {
					window = {
						position = "right",
						width = 36,
					},
				},
				source_selector = {
					winbar = true,
					statusline = false,
				},
			})
		end,
	})
	use({
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 400
			local wk = require("which-key")
			wk.setup({ preset = "classic" })
			wk.add({
				{ "<leader>f", group = "찾기" },
				{ "<leader>g", group = "git" },
				{ "<leader>a", group = "자동화" },
				{ "<leader>n", group = "neo-tree" },
				{ "<leader>t", group = "터미널·탭" },
				{ "<leader>fe", group = "Neovim 설정" },
			})
		end,
	})
	use({
		"pocco81/auto-save.nvim",
		config = function()
			local autosave = require("auto-save")
			local conf = require("auto-save.config")
			autosave.off()
			autosave.setup({
				trigger_events = { "InsertLeave", "TextChanged", "BufWinLeave" },
				debounce_delay = 800,
				condition = function(buf)
					local fn = vim.fn
					if fn.getbufvar(buf, "&modifiable") ~= 1 then
						return false
					end
					if fn.getbufvar(buf, "&buftype") ~= "" then
						return false
					end
					if fn.getbufvar(buf, "&buflisted") ~= 1 then
						return false
					end
					if vim.api.nvim_buf_get_name(buf) == "" then
						return false
					end
					return true
				end,
				execution_message = {
					message = function()
						return ""
					end,
					dim = 0,
					cleaning_interval = 0,
				},
			})
			if conf.opts.enabled then
				autosave.on()
			end
		end,
	})
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
	use({
		"hoob3rt/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = { theme = "auto" },
			})
		end,
	})
	use({
		"ray-x/go.nvim",
		-- Neovim 0.11: master(c8a356b~)는 vim.lsp.codelens.enable(0.12 전용) 호출 → InsertLeave 에러. 고정 해제는 NVIM 0.12+ 또는 upstream 수정 후.
		commit = "7ea962b826ebfce6f0f55c7b4d64c85c658cabe9",
		config = function()
			vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').gofumpt() ]], false)
			-- lsp_codelens=false만으로는 부족: 레포의 .gonvim/init.lua가 merge되며 true로 덮일 수 있음 → 그때도 끄려면 아래 둘 중 하나
			-- (1) disable_per_project_cfg=true  (2) .gonvim/init.lua에서 lsp_codelens 제거·false
			require("go").setup({
				lsp_codelens = false,
				disable_per_project_cfg = true,
			})
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup()
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
	-- 버퍼·일반.nvim 동작으로 스테이징·디프·커밋(Magit 느낌). 외부 TUI Lazygit와 병행 가능.
	use({
		"NeogitOrg/neogit",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("neogit").setup({
				integrations = {
					diffview = true,
					telescope = true,
				},
			})
		end,
	})
	use("folke/tokyonight.nvim")
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("ellisonleao/gruvbox.nvim")
	use({
		"numToStr/Comment.nvim",
		config = function()
			local setup, comment = pcall(require, "Comment")
			if not setup then
				return
			end
			comment.setup()
		end,
	})

	use({ "jlanzarotta/bufexplorer", config = function() end })
	use({
		"nvimdev/lspsaga.nvim",
		after = "nvim-lspconfig",
		config = function()
			require("lspsaga").setup({})
		end,
	})
	if packer_bootstrap then
		require("packer").sync()
	end
end)
