# Spring Boot Neovim Setup Plan (nvim-jdtls Approach)

## Overview
This plan configures Neovim (v0.12.2) for Spring Boot microservices development using `nvim-jdtls` for full manual control, plus Spring Boot LS integration via `spring-boot.nvim`.

## Prerequisites
- Neovim ≥0.9 (you have v0.12.2 ✅)
- JDK ≥17 (required for JDTLS)
- GNU Stow (already in your dotfiles workflow)
- Mason.nvim (already present in your NvChad setup)

## Phase 1: Plugin Installation
Add these plugins via `lazy.nvim` (your existing plugin manager):

| Plugin | Purpose | Config Location |
|--------|---------|----------------|
| `mfussenegger/nvim-jdtls` | Core Java LSP engine | `common/nvim/.config/nvim/lua/custom/plugins/java.lua` |
| `JavaHello/spring-boot.nvim` | Spring Boot LS (STS4) integration | `common/nvim/.config/nvim/lua/custom/plugins/spring.lua` |
| `mfussenegger/nvim-dap` | Debug Adapter Protocol | `common/nvim/.config/nvim/lua/custom/plugins/dap.lua` |
| `jkeresman01/spring-initializr.nvim` | Project scaffolding from start.spring.io | `common/nvim/.config/nvim/lua/custom/plugins/spring-init.lua` |
| `MunifTanjim/nui.nvim` | UI components for plugins | (dependency) |
| `ibhagwan/fzf-lua` | Workspace symbol picker (optional, for Spring bean search) | Existing or new |

## Phase 2: Mason Package Installation
Install these language server packages via `:MasonInstall` or Mason config:

| Package | Purpose |
|---------|---------|
| `jdtls` | Eclipse Java Language Server |
| `java-test` | JUnit test runner extension |
| `java-debug-adapter` | Java debugger extension |
| `spring-boot-tools` | Spring Boot Language Server (STS4) |

Add to your existing Mason config (e.g., update `lua/plugins/init.lua`):
```lua
{
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "jdtls",
      "java-test",
      "java-debug-adapter",
      "spring-boot-tools",
    },
  },
}
```

## Phase 3: Configuration Files
List of files to create/update in your NvChad config (`common/nvim/.config/nvim/`):

| File Path | Action | Purpose |
|-----------|--------|---------|
| `lua/ftplugin/java.lua` | **Create** | Per-filetype JDTLS config with custom JVM args |
| `lua/custom/plugins/java.lua` | **Create** | nvim-jdtls plugin spec |
| `lua/custom/plugins/spring.lua` | **Create** | spring-boot.nvim config + keybindings |
| `lua/custom/plugins/spring-init.lua` | **Create** | spring-initializr.nvim project scaffolding |
| `lua/custom/plugins/dap.lua` | **Create** | nvim-dap Java debug configs |
| `lua/configs/conform.lua` | **Update** | Add `google-java-format` for Java |
| `lua/plugins/init.lua` | **Update** | Add `java` + `kotlin` treesitter parsers |
| `lua/options.lua` | **Update** | Java tab settings (4 spaces) |
| `lazy-lock.json` | **Update** | Lock new plugin versions |

## Phase 4: Detailed JDTLS Config (`ftplugin/java.lua`)
This file runs every time a `.java` file is opened. Customize to avoid Eclipse metadata files and increase memory:

```lua
-- common/nvim/.config/nvim/lua/ftplugin/java.lua
local jdtls = require("jdtls")

-- Root directory detection (Maven/Gradle/Git)
local root_markers = { "pom.xml", "mvnw", "gradlew", "settings.gradle", ".git" }
local root_dir = vim.fs.root(0, root_markers)

-- JDTLS configuration
local config = {
  name = "jdtls",
  cmd = { "jdtls" }, -- Assumes jdtls is in $PATH (installed via Mason)
  root_dir = root_dir,
  
  -- Custom JVM arguments
  cmd_env = {
    JDTLS_JVM_ARGS = table.concat({
      "-Djava.import.generatesMetadataFilesAtProjectRoot=false", -- Prevent .settings/.project generation
      "-Xmx8G", -- Increase memory for large microservices
    }, " "),
  },

  settings = {
    java = {
      format = {
        enabled = true,
        comments = { enabled = false }, -- Keep your own comment formatting
        tabSize = 4,
      },
    },
  },

  -- Bundles for extensions (Spring Boot, Test, Debug)
  init_options = {
    bundles = {
      vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-test/*.jar", true),
      vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/*.jar", true),
      vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/spring-boot-tools/extension/language-server/*.jar", true),
    },
  },
}

-- Start or attach JDTLS
jdtls.start_or_attach(config)
```

## Phase 5: Spring Boot LS Integration (`lua/custom/plugins/spring.lua`)
Configure `spring-boot.nvim` to work with nvim-jdtls:

```lua
-- common/nvim/.config/nvim/lua/custom/plugins/spring.lua
return {
  "JavaHello/spring-boot.nvim",
  ft = { "java", "yaml", "jproperties" },
  dependencies = {
    "mfussenegger/nvim-jdtls",
    "ibhagwan/fzf-lua", -- Optional: for Spring bean search
  },
  config = function()
    local spring_boot = require("spring_boot")
    
    -- Initialize LSP commands for Spring Boot
    spring_boot.init_lsp_commands()
    
    -- Keybindings for Spring Boot features
    vim.keymap.set("n", "<leader>Jb", function()
      require("fzf-lua").lsp_live_workspace_symbols({ query = "@SpringBootApplication" })
    end, { desc = "Search Spring Boot Apps" })
    
    vim.keymap.set("n", "<leader>Je", function()
      require("fzf-lua").lsp_live_workspace_symbols({ query = "@RestController" })
    end, { desc = "Search REST Endpoints" })
  end,
}
```

## Phase 6: Debug Configuration (`lua/custom/plugins/dap.lua`)
Set up `nvim-dap` for Java debugging:

```lua
-- common/nvim/.config/nvim/lua/custom/plugins/dap.lua
local dap = require("dap")

-- Java debug adapter configuration
dap.adapters.java = function(callback)
  -- Start JDTLS debug session and get port
  require("jdtls").start_or_attach({})
  local port = require("jdtls").get_classpath_and_module_paths().debug_port
  callback({ type = "server", host = "127.0.0.1", port = port })
end

-- Debug configurations for Spring Boot
dap.configurations.java = {
  {
    type = "java",
    request = "launch",
    name = "Launch Spring Boot App",
    mainClass = function()
      -- Auto-detect main class with @SpringBootApplication
      local clients = vim.lsp.get_active_clients({ name = "jdtls" })
      if #clients == 0 then return "" end
      local symbols = clients[1].request_sync("workspace/symbol", { query = "@SpringBootApplication" })
      if symbols and symbols.result and #symbols.result > 0 then
        return symbols.result[1].name
      end
      return ""
    end,
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
```

## Phase 7: Code Formatting Update (`lua/configs/conform.lua`)
Add `google-java-format` for Java files:

```lua
-- Update existing conform.lua
local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    java = { "google-java-format" }, -- Add this line
  },
  -- ... rest of existing config
}
```

## Phase 8: Treesitter Update (`lua/plugins/init.lua`)
Add Java and Kotlin parsers for syntax highlighting:

```lua
-- Update existing plugins/init.lua
{
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vimdoc",
      "html",
      "css",
      "javascript",
      "typescript",
      "python",
      "java", -- Add this
      "kotlin", -- Add this for Spring Boot Kotlin projects
    },
  },
},
```

## Phase 9: Java Tab Settings (`lua/options.lua`)
Add Java-specific tab configuration:

```lua
-- Add to existing options.lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})
```

## Phase 11: Spring Project Scaffolding (`lua/custom/plugins/spring-init.lua`)
Use `spring-initializr.nvim` to create new Spring Boot projects from start.spring.io:

```lua
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
```

### Usage
| Keybinding | Command | Purpose |
|------------|---------|---------|
| `<leader>si` | `:SpringInitializr` | Open TUI for project configuration |
| `<leader>sg` | `:SpringGenerateProject` | Quick scaffold with defaults |

### Manual Alternative (No Plugin)
```bash
curl https://start.spring.io/starter.zip \
  -d type=maven \
  -d language=java \
  -d bootVersion=3.2.5 \
  -d baseDir=my-service \
  -d groupId=com.example \
  -d artifactId=my-service \
  -d name=my-service \
  -d packageName=com.example.myservice \
  -d javaVersion=17 \
  -d dependencies=web,data-jpa \
  -o my-service.zip && unzip my-service.zip
```

## Phase 12: Verification Steps
1. Restart Neovim: `nvim`
2. Install Mason packages: `:MasonInstall jdtls java-test java-debug-adapter vscode-spring-boot google-java-format`
3. Open a Spring Boot project root (with `pom.xml` or `build.gradle`)
4. Open a `.java` file with `@SpringBootApplication` - JDTLS should start automatically
5. Check LSP status: `:LspInfo` (should show `jdtls` active)
6. Test Spring Boot features: `:FzfLua lsp_live_workspace_symbols` and search for `@RestController`
7. Test debugging: Open a main class, press `<F5>` to launch
8. Test scaffolding: Press `<leader>si` to open Spring Initializr TUI

| Issue | Solution |
|-------|-----------|
| JDTLS not starting | Check `:messages` for errors, ensure JDK 17+ is installed |
| Spring Boot features not working | Verify `vscode-spring-boot` is installed via Mason, check bundles in `ftplugin/java.lua` |
| Metadata files generated | Ensure `-Djava.import.generatesMetadataFilesAtProjectRoot=false` is set in JDTLS args |
| Debug not working | Check `java-debug-adapter` is installed, verify DAP config in `dap.lua` |
| Spring Initializr not found | Run `:Lazy sync` to install dependencies (`plenary`, `nui`, `telescope`) |
