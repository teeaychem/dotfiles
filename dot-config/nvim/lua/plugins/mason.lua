local M = {"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup();
			-- have a fixed column for the diagnostics to appear in
			-- this removes the jitter when warnings/errors flow in
			vim.wo.signcolumn = "yes"
			vim.lsp.inlay_hint.enable(false)

			local function on_attach(client, bufnr)
				local keymap = vim.keymap
				local keymap_opts = { buffer = bufnr, silent = true }

				keymap.set("n", "<leader>h", vim.lsp.buf.hover, keymap_opts)
				keymap.set("n", "<leader>h", vim.lsp.buf.hover, keymap_opts)
				keymap.set("n", "<a-CR>", vim.lsp.buf.code_action, keymap_opts)

				-- Code navigation and shortcuts
				keymap.set("n", "<leader>m", vim.diagnostic.open_float, keymap_opts)
				keymap.set("n", "<leader>M", function() vim.cmd.RustLsp('renderDiagnostic') end, keymap_opts)
				keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
				keymap.set("n", "gD", vim.lsp.buf.implementation, keymap_opts)
				keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, keymap_opts)
				keymap.set("n", "<leader>gr", ":Telescope lsp_references<cr>", keymap_opts)
				keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_opts)
				keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, keymap_opts)
				keymap.set("n", "<a-p>", vim.lsp.buf.signature_help, keymap_opts)
				keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, keymap_opts)
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, keymap_opts)
				keymap.set("n", "<leader>t", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, keymap_opts)

				-- Goto previous/next diagnostic warning/error
				keymap.set("n", "]d", vim.diagnostic.goto_next, keymap_opts)
				keymap.set("n", "[d", vim.diagnostic.goto_prev, keymap_opts)
			end

			require("mason-lspconfig").setup_handlers({
				-- The first entry (without a key) will be the default handler
				-- and will be called for each installed server that doesn't have a dedicated handler.
				function(server_name)
					require("lspconfig")[server_name].setup({ on_attach = on_attach })
				end,

				["rust_analyzer"] = function()
					require('lspconfig').rust_analyzer.setup {
						on_attach = on_attach,
						root_dir = function(filename, bufnr) return vim.loop.cwd() end,
						cmd_env = { CARGO_TARGET_DIR = "target/rust-analyzer-check" },

						settings = {
							["rust-analyzer"] = {
							-- check = {
								-- command = "clippy",
								-- -- extraArgs = { "--all", "--", "-W", "clippy::all" },
								-- },

								-- rust-analyzer.server.extraEnv
								-- neovim doesn"t have custom client-side code to honor this setting, it doesn't actually work
								-- https://github.com/neovim/nvim-lspconfig/issues/1735
								-- it's in init.vim as a real env variable
								-- server = {
									-- extraEnv = {
										-- CARGO_TARGET_DIR = "target/rust-analyzer-check"
									-- }
								-- },

								imports = {
									granularity = { enforce = true },
								},

								rustfmt = {
									enableRangeFormatting = true,
									rangeFormatting = {
										enable = true,
									},
								},

								inlayHints = {
									bindingModeHints = { enable = true },
									closureReturnTypeHints = { enable = true },
									lifetimeElisionHints = { useParameterNames = true, enable = "skip_trivial" },
									closingBraceHints = { minLines = 0 },
									parameterHints = { enable = false },
									maxLength = 999,
								},
							},
						},
					}
				end,

				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						on_attach = on_attach,
						settings = {
							Lua = {
								diagnostics = {
									-- Get the language server to recognize the `vim` global
									globals = { "vim" },
								},
							},
						},
					})
				end,

			})
		end,
	}

return { M }
