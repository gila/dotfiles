local lsp = require("lspconfig")

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)

	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

	vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)

	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<leader>wl",
		"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
		opts
	)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = { "gopls", "rnix", "ansiblels" }

for _, l in ipairs(servers) do
	lsp[l].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end
local opts = {
	tools = { 
		autoSetHints = true,
		executor = require("rust-tools/executors").termopen,
		inlay_hints = {

			only_current_line = false,
			only_current_line_autocmd = "CursorHold",
			show_parameter_hints = true,
			show_variable_name = true,
			parameter_hints_prefix = "<- ",
			other_hints_prefix = "=> ",
			max_len_align = false,
			max_len_align_padding = 1,
			right_align = false,
			right_align_padding = 7,
			highlight = "Comment",
		},

		hover_actions = {
			border = {
				{ "╭", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "╮", "FloatBorder" },
				{ "│", "FloatBorder" },
				{ "╯", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "╰", "FloatBorder" },
				{ "│", "FloatBorder" },
			},
			auto_focus = true,
		},
	},

	server = {
		standalone = true,
		on_attach = on_attach,
		settings = {
			workspace = {
				symbol = { search = { scope = "workspace_and_dependencies" } },
			},
			assist = {
				importMergeBehavior = "full",
				importPrefix = "by_self",
				importEnforceGranularity = true,
				importGroup = true,
			},
			callInfo = { full = true },
			cargo = { loadOutDirsFromCheck = true, autoreload = true },
			checkOnSave = { enable = true, command = "clippy" },
			overActions = { linksInHover = true },
			procMacro = { enable = true },
			experimental = { procAttrMacros = true },
		},
	},
}

require("rust-tools").setup(opts)

vim.diagnostic.config({
	virtual_text = false,
})

vim.lsp.diagnostic.float = {
	focusable = true,
	style = "minimal",
	border = "rounded",
}

vim.api.nvim_set_keymap("n", "<leader>fm", "<cmd>lua vim.lsp.buf.format()<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>ft", "<cmd>lua require('whitespace-nvim').trim<CR>", {})
