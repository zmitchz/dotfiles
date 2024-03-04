local dap = require "dap"
local mason_registry = require "mason-registry"
local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
local codelldb_path = codelldb_root .. "adapter/codelldb"
local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"

vim.fn.sign_define(
  "DapBreakpoint",
  { text = "●", texthl = "", linehl = "debugBreakpoint", numhl = "debugBreakpoint" }
)
vim.fn.sign_define(
  "DapBreakpointCondition",
  { text = "◆", texthl = "", linehl = "debugBreakpoint", numhl = "debugBreakpoint" }
)
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "", linehl = "debugPC", numhl = "debugPC" })

------- Adapters ---------
dap.adapters = {
  python = {
    type = "executable",
    command = "python",
    args = { "-m", "debugpy.adapter" },
    options = {
      source_filetype = "python",
    },
  },

  codelldb = {
    type = "server",
    port = "${port}",
    host = "127.0.0.1",
    executable = {
      command = codelldb_path,
      args = { "--liblldb", liblldb_path, "--port", "${port}" },
    },
  },
}

------- Configs ---------
local lldb = {
  type = "codelldb",
  request = "launch",
  program = function()
    -- Compile and return exec name
    local filetype = vim.bo.filetype
    local filename = vim.fn.expand "%"
    local basename = vim.fn.expand "%:t:r"
    local makefile = os.execute "(ls | grep -i makefile)"
    if makefile == "makefile" or makefile == "Makefile" then
      os.execute "make debug"
    else
      if filetype == "c" then
        os.execute(string.format("gcc -g -o %s %s", basename, filename))
      else
        os.execute(string.format("g++ -g -o %s %s", basename, filename))
      end
    end
    return basename
  end,
  args = function()
    local argv = {}
    arg = vim.fn.input(string.format "argv: ")
    for a in string.gmatch(arg, "%S+") do
      table.insert(argv, a)
    end
    vim.cmd 'echo ""'
    return argv
  end,
  cwd = "${workspaceFolder}",
  -- Uncomment if you want to stop at main
  -- stopAtEntry = true,
  MIMode = "gdb",
  miDebuggerPath = "/usr/bin/gdb",
  setupCommands = {
    {
      text = "-enable-pretty-printing",
      description = "enable pretty printing",
      ignoreFailures = false,
    },
  },
}

dap.configurations = {
  python = {
    {
      type = "python",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      pythonPath = "/usr/bin/python",
    },
  },

  cpp = { lldb },
  c = { lldb },
  rust = {
    {
      type = "codelldb",
      request = "launch",
      -- This is where cargo outputs the executable
      program = function()
        os.execute "cargo build &> /dev/null"
        return "target/debug/${workspaceFolderBasename}"
      end,
      args = function()
        local argv = {}
        arg = vim.fn.input(string.format "argv: ")
        for a in string.gmatch(arg, "%S+") do
          table.insert(argv, a)
        end
        return argv
      end,
      cwd = "${workspaceFolder}",
      MIMode = "gdb",
      miDebuggerPath = "/usr/bin/gdb",
      setupCommands = {
        {
          text = "-enable-pretty-printing",
          description = "enable pretty printing",
          ignoreFailures = false,
        },
      },
      initCommands = function()
        -- Find out where to look for the pretty printer Python module
        local rustc_sysroot = vim.fn.trim(vim.fn.system "rustc --print sysroot")

        local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
        local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

        local commands = {}
        local file = io.open(commands_file, "r")
        if file then
          for line in file:lines() do
            table.insert(commands, line)
          end
          file:close()
        end
        table.insert(commands, 1, script_import)

        return commands
      end,
    },
  },
}
