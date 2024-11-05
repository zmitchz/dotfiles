local jdtls_setup = require "jdtls.setup"
local home = os.getenv "HOME"
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = jdtls_setup.find_root(root_markers)
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/.cache/jdtls/workspace" .. project_name
local plugin_dir = "/usr/share/idea/plugins/"
local javaFX_dir = plugin_dir .. "javaFX/lib/"

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    "java", -- or '/path/to/java17_or_newer/bin/java'

    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",

    "-jar",
    vim.fn.expand "/home/mitchell/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar",

    "-configuration",
    vim.fn.expand "/home/mitchell/.local/share/nvim/mason/packages/jdtls/config_linux/",
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    "-data",
    workspace_dir,
  },

  root_dir = root_dir,

  settings = {
    java = {
      project = {
        referencedLibraries = {
          javaFX_dir .. "javaFX.jar",
          javaFX_dir .. "javaFX-jps.jar",
          javaFX_dir .. "javaFX-common.jar",
        },
      },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      configuration = {
        runtimes = {
          {
            name = "JavaSE-1.8",
            path = "/usr/lib/jvm/java-8-openjdk/",
          },
          {
            name = "JavaSE-11",
            path = "/usr/lib/jvm/java-11-openjdk/",
          },
          {
            name = "JavaSE-17",
            path = "/usr/lib/jvm/java-17-openjdk",
          },
          {
            name = "JavaSE-22",
            path = "/usr/lib/jvm/java-22-openjdk",
          },
        },
      },
    },

    init_options = {
      bundles = {},
    },
    capabilities = capabilities,
  },
}

local function jdtls_start(event)
  require("jdtls").start_or_attach(config)
end

vim.api.nvim_create_autocmd("FileType", {
  group = java_cmds,
  pattern = { "java" },
  desc = "Setup jdtls",
  callback = jdtls_start,
})

return config
