local cmp = require "cmp"
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  sources = cmp.config.sources {
    { name = "vsnip" },
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "cmdline" },
    { name = "zsh" },
    { name = "calc" },
  },
}
