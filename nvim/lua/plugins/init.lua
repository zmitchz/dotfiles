local plugins = {
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<space>", "<c>", '"', "'", "`", "c", "v", "g", "[", "]" },
    init = function()
      require("mappings").plugins.whichkey()
    end,
    config = function(_, opts)
      require("which-key").setup(opts)
    end,
  },

  { "nvim-lua/plenary.nvim" },

  {
    "folke/neodev.nvim",
    opts = function()
      return require "plugins.configs.neodev"
    end,
    config = function(_, opts)
      require("neodev").setup(opts)
    end,
  },

  { "nvim-tree/nvim-web-devicons" },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufEnter",
    dependencies = "hiphish/rainbow-delimiters.nvim",
    build = ":TSUpdate",
    init = function()
      require("plugins.configs.indent-blankline").init()
      require("mappings").plugins.blankline()
    end,
    opts = function()
      return require("plugins.configs.indent-blankline").opts
    end,
    config = function(_, opts)
      require("ibl").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = function()
          return require "plugins.configs.dap-virt-text"
        end,
        config = function(_, opts)
          require("nvim-dap-virtual-text").setup(opts)
        end,
      },
      "LiadOz/nvim-dap-repl-highlights",
    },
    init = function()
      require("core.utils").lazy_load "nvim-treesitter"
    end,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "plugins.configs.treesitter"
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    ft = { "gitcommit", "diff" },
    keys = { "<leader>g>" },
    init = function()
      require("mappings").plugins.gitsigns()
      vim.api.nvim_create_autocmd({ "BufRead" }, {
        group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
        callback = function()
          vim.fn.system("git -C " .. '"' .. vim.fn.expand "%:p:h" .. '"' .. " rev-parse")
          if vim.v.shell_error == 0 then
            vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
            vim.schedule(function()
              require("lazy").load { plugins = { "gitsigns.nvim" } }
            end)
          end
        end,
      })
    end,
    opts = function()
      return require "plugins.configs.gitsigns"
    end,
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "plugins.configs.mason"
    end,
    config = function(_, opts)
      require("mason").setup(opts)

      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end, {})

      vim.g.mason_binaries_list = opts.ensure_installed
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "mfussenegger/nvim-lint",
        config = function()
          require "plugins.configs.nvim-lint"
        end,
      },
      {
        "stevearc/aerial.nvim",
        cmd = { "AerialToggle", "AerialNext", "AerialPrev", "AerialNavToggle" },
        keys = { "<leader>a" },
        init = function()
          require("mappings").plugins.aerial()
        end,
        config = function()
          require("aerial").setup()
        end,
      },
    },
    init = function()
      require("core.utils").lazy_load "nvim-lspconfig"
    end,
    config = function()
      require "plugins.configs.lsp.lspconfig"
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    disable_filetype = { "prompt", "TelescopePrompt" },
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        build = "make install_jsregexp",
        init = function()
          require("plugins.configs.luasnip").init()
        end,
        opts = function()
          return require("plugins.configs.luasnip").opts
        end,
        config = function(_, opts)
          require("luasnip").setup(opts)
        end,
      },
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "rcarriga/cmp-dap",
      },
    },
    opts = function()
      return require "plugins.configs.cmp"
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = function()
      return require "plugins.configs.conform"
    end,
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    init = function()
      require("mappings").plugins.comment()
    end,
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "LiadOz/nvim-dap-repl-highlights",
    },
    init = function()
      require("mappings").plugins.dap()
    end,
    config = function()
      require "plugins.configs.dap"
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    init = function()
      require("mappings").plugins.dapui()
    end,
    opts = function()
      return require "plugins.configs.dap-ui"
    end,
    config = function(_, opts)
      require("dapui").setup(opts)
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("mappings").plugins.nvimtree()
    end,
    opts = function()
      return require "plugins.configs.nvimtree"
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope-dap.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },

    cmd = "Telescope",
    init = function()
      require("mappings").plugins.telescope()
    end,
    opts = function()
      return require "plugins.configs.telescope"
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  {
    "gelguy/wilder.nvim",
    event = "CmdLineEnter",
    dependencies = {
      "sharkdp/fd",
      { "nixprime/cpsm", dependencies = "ctrlpvim/ctrlp.vim" },
      "roxma/nvim-yarp",
      "romgrk/fzy-lua-native",
      "nvim-tree/nvim-web-devicons",
    },
    init = function()
      require("wilder").setup { modes = { ":", "/", "?" } }
      dofile "/home/mitchell/.config/nvim/lua/plugins/configs/wilder.lua"
    end,
  },

  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      require("mappings").plugins.todo()
    end,
  },

  {
    "ggandor/leap.nvim",
    init = function()
      require("leap").add_default_mappings()
    end,
  },

  {
    "kiyoon/jupynium.nvim",
    ft = { "ipynb", "ipython" },
    build = "pipx install .",
    init = function()
      require("mappings").plugins.jupynium()
    end,
    opts = function()
      return require "plugins.configs.jupynium"
    end,
    config = function(_, opts)
      require("jupynium").setup(opts)
    end,
  },

  {
    "lervag/vimtex",
    ft = { "tex", "latex" },
    init = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_view_general_viewer = "zathura"
      vim.g.vimtex_view_general_options = [[--unique file:@pdf\#src:@line@tex]]
      vim.g.vimtex_compiler_method = "latexmk"
    end,
  },

  {
    "pocco81/auto-save.nvim",
    init = function()
      require("mappings").plugins.autosave()
    end,
  },

  {
    "rcarriga/nvim-notify",
    lazy = false,
    init = function()
      require("plugins.configs.notify").init()
    end,
    opts = function()
      return require("plugins.configs.notify").opts
    end,
    config = function(_, opts)
      require("notify").setup(opts)
    end,
  },

  {
    "hiphish/rainbow-delimiters.nvim",
    event = "BufEnter",
    opts = function()
      return require "plugins.configs.rainbow-delimiters"
    end,
    config = function(_, opts)
      require("rainbow-delimiters.setup").setup(opts)
    end,
  },

  { "Bekaboo/deadcolumn.nvim", ft = { "tex", "python", "rust", "c", "lua", "yaml", "text" } },

  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>u" },
    },
    init = function()
      require("mappings").plugins.undo()
    end,
    config = true,
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      require("mappings").plugins.trouble()
    end,
    opts = function()
      return require "plugins.configs.trouble"
    end,
    config = function(_, opts)
      require("trouble").setup(opts)
    end,
  },

  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = "kevinhwang91/promise-async",
    init = function()
      require("mappings").plugins.ufo()
      require("plugins.configs.ufo").init()
    end,
    opts = function()
      return require("plugins.configs.ufo").opts
    end,
    config = function()
      require("ufo").setup(opts)
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    ft = { "javascript", "typescript", "typescriptreact", "jsx", "tsx" },
    config = function()
      require("nvim-treesitter.configs").setup {
        autotag = { enable = true },
      }
    end,
  },

  {
    "andymass/vim-matchup",
    lazy = false,
    config = function()
      require("nvim-treesitter.configs").setup {
        matchup = { enable = true },
      }
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      require("nightfox").setup { options = { transparent = true } }
      vim.cmd "colorscheme carbonfox"
    end,
  },

  {
    "stevearc/dressing.nvim",
    event = "VimEnter",
    opts = function()
      return require "plugins.configs.dressing"
    end,
    config = function(_, opts)
      require("dressing").setup(opts)
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VimEnter",
    init = function()
      require("mappings").plugins.toggleterm()
    end,
    opts = function()
      return require "plugins.configs.toggleterm"
    end,
    config = function(_, opts)
      require("toggleterm").setup(opts)
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      return require "plugins.configs.lualine"
    end,
    config = function(_, opts)
      require("lualine").setup(opts)
    end,
  },

  {
    "akinsho/bufferline.nvim",
    lazy = false,
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    init = function()
      require("mappings").plugins.bufferline()
    end,
    opts = function()
      return require "plugins.configs.bufferline"
    end,
    config = function(_, opts)
      require("bufferline").setup(opts)
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "BufEnter",
    opts = function()
      return require "plugins.configs.colorizer"
    end,
    config = function(_, opts)
      require("colorizer").setup(opts)
    end,
  },

  {
    "echasnovski/mini.animate",
    version = "*",
    event = "BufEnter",
    opts = {},
    config = function(_, opts)
      require("mini.animate").setup(opts)
    end,
  },
}

local config = require "plugins.configs.lazy_nvim"
require("lazy").setup(plugins, config)
