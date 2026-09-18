require("nvchad.configs.lspconfig").defaults()

local servers = { "lua_ls", "html", "cssls", "pyright", "ts_ls" }
vim.lsp.enable(servers)

-- JDTLS is handled by nvim-jdtls via ftplugin/java.lua
-- Do NOT add "jdtls" to this list

-- to configure lsps further read :h vim.lsp.config

