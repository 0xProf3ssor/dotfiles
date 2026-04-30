return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
  },
  event = "BufRead *.java",
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    -- Java debug adapter configuration
    dap.adapters.java = function(callback)
      local clients = vim.lsp.get_active_clients({ name = "jdtls" })
      if #clients == 0 then
        vim.notify("JDTLS not running - open a Java file first", vim.log.levels.ERROR)
        return
      end
      callback({ type = "server", host = "127.0.0.1", port = 5005 })
    end

    -- Debug configurations for Spring Boot
    dap.configurations.java = {
      {
        type = "java",
        request = "launch",
        name = "Launch Spring Boot App",
        mainClass = "",
        projectName = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
      },
      {
        type = "java",
        request = "launch",
        name = "Debug JUnit Test",
        mainClass = "${file}",
      },
    }

    -- Keybindings
    vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug Continue" })
    vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
    vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
    vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end,
}
