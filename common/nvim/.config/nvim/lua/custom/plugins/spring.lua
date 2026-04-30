return {
  "JavaHello/spring-boot.nvim",
  ft = { "java", "yaml", "jproperties" },
  dependencies = {
    "mfussenegger/nvim-jdtls",
    "ibhagwan/fzf-lua",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local spring_boot = require("spring_boot")
    spring_boot.init_lsp_commands()

    -- Keybindings for Spring Boot features
    vim.keymap.set("n", "<leader>Jb", function()
      require("fzf-lua").lsp_live_workspace_symbols({ query = "@SpringBootApplication" })
    end, { desc = "Search Spring Boot Apps" })

    vim.keymap.set("n", "<leader>Je", function()
      require("fzf-lua").lsp_live_workspace_symbols({ query = "@RestController" })
    end, { desc = "Search REST Endpoints" })

    vim.keymap.set("n", "<leader>Jp", function()
      require("fzf-lua").lsp_live_workspace_symbols({ query = "@Bean" })
    end, { desc = "Search Spring Beans" })
  end,
}
