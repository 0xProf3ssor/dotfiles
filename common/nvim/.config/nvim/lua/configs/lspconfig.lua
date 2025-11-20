require("nvchad.configs.lspconfig").defaults()

local servers = { "lua_ls", "html", "cssls", "pyright", "ts_ls" }
vim.lsp.enable(servers)

-- to configure lsps further read :h vim.lsp.config

