require("nvim-tree").setup({})
require("onedark").setup({
    style = "dark",
})

require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
        use_langauge_tree = true,
    },
    indent = {
        enable = true,
    },
    rainbow = {
        enable = true,
        extended_mode = true,
    },
})

local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.nixpkgs_fmt,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.yamlfix,
        null_ls.builtins.formatting.gofumpt,
    },
})

require("bufferline").setup({
    options = {
        offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
        buffer_close_icon = "X",
        modified_icon = "",
        close_icon = "X",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 14,
        max_prefix_length = 13,
        tab_size = 20,
        show_tab_indicators = true,
        enforce_regular_tabs = false,
        view = "multiwindow",
        show_buffer_close_icons = true,
        separator_style = "thin",
        diagnostic = "nvim_lsp",
    },
})

require("whitespace-nvim").setup({
    highlight = "DiffDelete",
    ignored_filetypes = { "TelescopePrompt", "Trouble", "help" },
    ignore_terminal = true,
})

local map = vim.api.nvim_set_keymap
-- move between tabs
map("n", "<TAB>", [[<Cmd>BufferLineCycleNext<CR>]], { silent = true })
map("n", "<S-TAB>", [[<Cmd>BufferLineCyclePrev<CR>]], { silent = true })
