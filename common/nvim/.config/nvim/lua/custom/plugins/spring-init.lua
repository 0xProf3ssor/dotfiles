return {
  "jkeresman01/spring-initializr.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cmd = { "SpringInitializr", "SpringGenerateProject" },
  config = function()
    require("spring-initializr").setup()

    -- Keybindings
    vim.keymap.set("n", "<leader>si", "<CMD>SpringInitializr<CR>", { desc = "Spring Initializr TUI" })
    vim.keymap.set("n", "<leader>sg", "<CMD>SpringGenerateProject<CR>", { desc = "Generate Spring Boot Project" })
  end,
}
