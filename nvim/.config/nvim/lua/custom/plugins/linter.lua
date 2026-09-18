return {
  {
    "mfussenegger/nvim-lint",
    lazy = false,
    config = function()
      local lint = require("lint")

      -- Define linters for each filetype
      lint.linters_by_ft = {
        python = { "flake8" },          -- Python linting
        javascript = { "eslint_d" },      -- JS linting
        typescript = { "eslint_d" },      -- TS linting
      }

      -- Auto lint on save and file read
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        callback = function()
          lint.try_lint()
        end,
      })

      -- Optional: trigger lint manually
      vim.keymap.set("n", "<leader>l", function()
        lint.try_lint()
      end, { desc = "Run Linter" })
    end,
  },
}
