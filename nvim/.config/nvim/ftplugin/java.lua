-- JDTLS configuration for Java/Spring Boot development
local jdtls = require("jdtls")

-- Root directory detection (Maven/Gradle/Git)
local root_markers = { "pom.xml", "mvnw", "gradlew", "settings.gradle", ".git" }
local root_dir = vim.fs.root(0, root_markers)

if not root_dir then
  vim.notify("No Java project root found", vim.log.levels.WARN)
  return
end

-- Mason package paths
local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
local jdtls_path = mason_path .. "/jdtls"
local java_test_path = mason_path .. "/java-test"
local java_debug_path = mason_path .. "/java-debug-adapter"
local spring_boot_path = mason_path .. "/spring-boot-tools/extension/language-server"

-- Collect extension bundles
local bundles = {}
vim.list_extend(bundles, vim.fn.glob(java_test_path .. "/*.jar", true, true))
vim.list_extend(bundles, vim.fn.glob(java_debug_path .. "/*.jar", true, true))
vim.list_extend(bundles, vim.fn.glob(spring_boot_path .. "/**/*.jar", true, true))

-- JDTLS configuration
local config = {
  name = "jdtls",
  cmd = { "jdtls" }, -- Assumes jdtls is in $PATH (installed via Mason)
  root_dir = root_dir,
  init_options = {
    bundles = bundles,
    -- Spring Boot LS integration
    spring_boot_ls = {
      enabled = true,
      path = spring_boot_path,
    },
  },
  settings = {
    java = {
      format = {
        enabled = true,
        comments = { enabled = false },
        tabSize = 4,
      },
      configuration = {
        runtimes = {
          {
          name = "JavaSE-26",
             path = os.getenv("JAVA_HOME") or "/usr/lib/jvm/default",
            default = true,
          },
        },
      },
    },
  },
  cmd_env = {
    JDTLS_JVM_ARGS = table.concat({
      "-Djava.import.generatesMetadataFilesAtProjectRoot=false", -- Prevent .settings/.project generation
      "-Xmx8G", -- Increase memory for large microservices
    }, " "),
  },
}

-- Start or attach JDTLS
jdtls.start_or_attach(config)
