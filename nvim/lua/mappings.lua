local wk = require "which-key"
local M = {}

M.general = function()
    -- Insert
    wk.register({
        ["jk"] = { "<ESC>", "Escape" },

        ["<A-;>"] = { "<Esc>miA;<Esc>`ii", "Insert semi at eol" },
        ["<A-,>"] = { "<Esc>miA,<Esc>`ii", "Insert comma at eol" },

        ["<C-b>"] = { "<ESC>^i", "Beginning of line" },
        ["<C-e>"] = { "<End>", "End of line" },
        ["<C-f>"] = { "[s1z=<C-o>", "Undo spelling correction" },
        ["<C-m>"] = { "<C-g>u<Esc>[s1z=`]a<C-g>u", "Jump and replace last mispelled" },

        ["<C-h>"] = { "<Left>", "Move left" },
        ["<C-l>"] = { "<Right>", "Move right" },
        ["<C-j>"] = { "<Down>", "Move down" },
        ["<C-k>"] = { "<Up>", "Move up" },
    }, { mode = "i" })
    -- Normal
    wk.register({
        ["<leader>"] = {
            F = {
                name = "File",
                n = { "<cmd>enew<CR>", "New File" },
            },
            b = {
                name = "Buffer",
                c = { "<cmd>q<CR>", "Quit / Close split" },
            },
            h = { "<cmd> split <CR>", "Horizontal Split" },
            s = { "<cmd>luafile $MYVIMRC<CR>", "Source init file" },
            T = {
                name = "Tab",
                N = { "<cmd> tabnew<CR>", "New tab" },
                n = { "<cmd> tabnext<CR>", "Next tab" },
                p = { "<cmd> tabprevious<CR>", "Previous tab" },
            },
            v = { "<cmd> vsplit <CR>", "Vertical Split" },
        },

        ["<A-;>"] = { "<Esc>miA;<Esc>`ii<Esc>", "Insert semi at eol" },
        ["<A-,>"] = { "<Esc>miA,<Esc>`ii<Esc>", "Insert comma at eol" },

        ["<C-U>"] = { "<C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y>" },
        ["<C-D>"] = { "<C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E>" },

        ["<C-h>"] = { "<C-w>h", "Window left" },
        ["<C-l>"] = { "<C-w>l", "Window right" },
        ["<C-j>"] = { "<C-w>j", "Window down" },
        ["<C-k>"] = { "<C-w>k", "Window up" },

        ["<C-c>"] = { "<cmd>%y+<CR>", "Copy whole file" },
        ["<C-s>"] = { "<cmd> w <CR>", "Save file" },

        ["<Left>"] = { "<cmd>horizontal resize -10 <CR>", "Resize Left" },
        ["<Right>"] = { "<cmd>horizontal resize +10 <CR>", "Resize Right" },
        ["<Up>"] = { "<cmd>  vertical resize +10 <CR>", "Resize Up" },
        ["<Down>"] = { "<cmd>  vertical resize -10 <CR>", "Resize Down" },
    }, { mode = "n" })

    -- Terminal
    wk.register({
        ["<C-h>"] = { "<C-w>h", "Window left" },
        ["<C-l>"] = { "<C-w>l", "Window right" },
        ["<C-j>"] = { "<C-w>j", "Window down" },
        ["<C-k>"] = { "<C-w>k", "Window up" },
        ["jk"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "Escape terminal mode" },
    }, { mode = "t" })

    -- Visual / Select
    wk.register({
        ["<"] = { "<gv", "Indent line" },
        [">"] = { ">gv", "Indent line" },
    }, { mode = "v" })

    -- Visual
    wk.register({
        ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', "Dont copy replaced text", opts = { silent = true } },
    }, { mode = "x" })
end

M.plugins = {
    aerial = function()
        -- Normal
        wk.register {
            ["<leader>"] = {
                a = {
                    name = "Aerial",
                    a = {
                        "<cmd> AerialToggle <CR>",
                        "Toggle",
                    },
                    b = {
                        "<cmd> AerialPrev<CR>",
                        "Backwards",
                    },
                    n = {
                        "<cmd> AerialNext<CR>",
                        "Next",
                    },
                    s = {
                        "<cmd> AerialNavToggle<CR>",
                        "Toggle nav",
                    },
                },
            },
            { mode = "n" },
        }
    end,

    autosave = function()
        wk.register({
            ["<leader>A"] = {
                function()
                    require("auto-save").toggle()
                end,
                "Toggle Autosave",
            },
        }, { mode = "n" })
    end,

    blankline = function() end,

    bufferline = function()
        local buf = require "bufferline"
        -- Normal
        wk.register({
            ["<leader>b"] = {
                g = {
                    function()
                        buf.pick()
                    end,
                    "Go to picked",
                },
                x = {
                    function()
                        buf.close_with_pick()
                    end,
                    "Close picked",
                },
            },

            ["[b"] = {
                function()
                    buf.cycle(-1)
                end,
                "Cycle prev buffer",
            },
            ["]b"] = {
                function()
                    buf.cycle(1)
                end,
                "Cycle next buffer",
            },
        }, { mode = "n" })
    end,

    comment = function()
        local comment = require "Comment.api"
        wk.register({
            ["<space><space>"] = {
                function()
                    comment.toggle.linewise.current()
                end,
                "Comment line",
            },
        }, { mode = "n" })
        wk.register({
            ["<space><space>"] = {
                function()
                    comment.toggle.linewise.current()
                end,
                "Comment selected",
            },
        }, { mode = "v" })
    end,

    dap = function()
        local d = require "dap"
        -- Normal
        wk.register({
            ["<leader>d"] = {
                name = "Dap",
                b = {
                    function()
                        d.toggle_breakpoint()
                    end,
                    "Toggle breakpoint",
                },
                c = {
                    function()
                        d.continue()
                    end,
                    "Continue",
                },
                i = {
                    function()
                        d.step_into()
                    end,
                    "Step into",
                },
                l = {
                    function()
                        d.set_breakpoint(nil, nil, vim.fn.input "Log point message: ")
                    end,
                    "Log breakpoint",
                },
                n = {
                    function()
                        d.set_breakpoint()
                    end,
                    "Set breakpoint",
                },
                o = {
                    function()
                        d.step_over()
                    end,
                    "Step over",
                },
                p = {
                    function()
                        d.run_last()
                    end,
                    "Run last",
                },
                r = {
                    function()
                        d.repl.open()
                    end,
                    "Open repl",
                },
                u = {
                    function()
                        d.step_out()
                    end,
                    "Step out",
                },

                -- Dap UI
                h = {
                    function()
                        require("dap.ui.widgets").hover()
                    end,
                    "UI hover",
                },
                j = {
                    function()
                        require("dap.ui.widgets").preview()
                    end,
                    "UI preview",
                },
                f = {
                    function()
                        local widgets = require "dap.ui.widgets"
                        widgets.centered_float(widgets.frames)
                    end,
                    "UI frames",
                },
                s = {
                    function()
                        local widgets = require "dap.ui.widgets"
                        widgets.centered_float(widgets.scopes)
                    end,
                    "UI scopes",
                },
            },
        }, { mode = "n" })

        -- Visual
        wk.register({
            ["<leader>d"] = {
                name = "Dap",
                ["l"] = {
                    function()
                        d.hover()
                    end,
                    "UI hover",
                },
                ["p"] = {
                    function()
                        d.preview()
                    end,
                    "UI preview",
                },
            },
        }, { mode = "v" })
    end,

    gitsigns = function(bufnr)
        local g = require "gitsigns"
        wk.register({
            ["]c"] = {
                function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        g.next_hunk()
                    end)
                    return "<Ignore>"
                end,
                "Jump to next hunk",
            },
            ["[c"] = {
                function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        g.prev_hunk()
                    end)
                    return "<Ignore>"
                end,
                "Jump to prev hunk",
            },
        }, { mode = "n", expr = true, buffer = bufnr })

        wk.register({
            ["<leader>g"] = {
                name = "Git",
                r = {
                    function()
                        g.reset_hunk()
                    end,
                    "Reset hunk",
                },
                p = {
                    function()
                        g.preview_hunk()
                    end,
                    "Preview hunk",
                },
                t = {
                    function()
                        g.toggle_deleted()
                    end,
                    "Toggle deleted",
                },
            },
        }, { mode = "n", buffer = bufnr })
    end,

    jupynium = function()
        wk.register({
            ["<leader>j"] = {
                name = "Jupynium",
                S = {
                    function()
                        vim.cmd "JupyniumStopSync"
                    end,
                    "Stop sync",
                },
                j = {
                    function()
                        local serv = vim.v.servername
                        vim.cmd(
                            '!jupynium --firefox_profiles_ini_path "/home/mitchell/.mozilla/firefox/profiles.ini" --firefox_profile_name "jupynium" --nvim_listen_addr '
                            .. serv
                            .. " &"
                        )
                    end,
                    "Start server",
                },
                s = {
                    function()
                        vim.cmd "JupyniumStartSync"
                    end,
                    "Start sync",
                },
            },

            ["<A-e>"] = {
                function()
                    vim.cmd "JupyniumScrollDown"
                end,
                "Scroll down",
            },

            ["<A-y>"] = {
                function()
                    vim.cmd "JupyniumScrollUp"
                end,
                "Scroll up",
            },
        }, { mode = "n" })
    end,

    lspconfig = function(bufnr)
        local lbuf = vim.lsp.buf
        local ldiag = vim.diagnostic
        wk.register({
            K = {
                function()
                    lbuf.hover()
                end,
                "LSP hover",
            },

            g = {
                D = {
                    function()
                        lbuf.declaration()
                    end,
                    "LSP declaration",
                },
                d = {
                    function()
                        lbuf.definition()
                    end,
                    "LSP definition",
                },

                i = {
                    function()
                        lbuf.implementation()
                    end,
                    "LSP implementation",
                },

                r = {
                    function()
                        lbuf.references()
                    end,
                    "LSP references",
                },
            },

            ["]d"] = {
                function()
                    ldiag.goto_next { float = { border = "rounded" } }
                end,
                "Next diagnostic",
            },
            ["[d"] = {
                function()
                    ldiag.goto_prev { float = { border = "rounded" } }
                end,
                "Prev diagnostic",
            },

            ["<leader>l"] = {
                name = "LSP",
                D = {
                    function()
                        lbuf.type_definition()
                    end,
                    "LSP definition type",
                },
                f = {
                    function()
                        lbuf.format { async = true }
                    end,
                    "Format",
                },
                r = {
                    function()
                        lbuf.rename()
                    end,
                    "LSP rename",
                },
                s = {
                    function()
                        lbuf.signature_help()
                    end,
                    "Signature help",
                },
                c = {
                    function()
                        lbuf.code_action()
                    end,
                    "Code action",
                },
                d = {
                    function()
                        ldiag.open_float { border = "rounded" }
                    end,
                    "Floating diagnostic",
                },
                q = {
                    function()
                        ldiag.setloclist()
                    end,
                    "Diagnostic setloclist",
                },
                ["wa"] = {
                    function()
                        lbuf.add_workspace_folder()
                    end,
                    "Add workspace folder",
                },
                ["wr"] = {
                    function()
                        lbuf.remove_workspace_folder()
                    end,
                    "Remove workspace folder",
                },
                ["wl"] = {
                    function()
                        print(vim.inspect(lbuf.list_workspace_folders()))
                    end,
                    "List workspace folders",
                },
            },
        }, { mode = "n", buffer = bufnr })

        wk.register({
            ["<leader>l"] = {
                name = "LSP",
                c = {
                    function()
                        lbuf.code_action()
                    end,
                    "LSP code action",
                },
            },
        }, { mode = "v", buffer = bufnr })
    end,

    nvimtree = function()
        wk.register({
            ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
        }, { mode = "n" })
    end,

    telescope = function()
        local d = require("telescope").extensions.dap
        wk.register({
            ["<leader>f"] = {
                name = "Telescope",
                A = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find all" },
                a = { "<cmd> Telescope aerial <CR>", "Buffers" },
                b = { "<cmd> Telescope buffers <CR>", "Buffers" },
                c = { "<cmd> Telescope git_commits <CR>", "Git commits" },
                f = { "<cmd> Telescope find_files <CR>", "Files" },
                h = { "<cmd> Telescope help_tags <CR>", "Help page" },
                g = { "<cmd> Telescope git_status <CR>", "Git status" },
                m = { "<cmd> Telescope marks <CR>", "Bookmarks" },
                o = { "<cmd> Telescope oldfiles <CR>", "Old files" },
                s = { "<cmd> Telescope aerial<CR>", "Symbols" },
                w = { "<cmd> Telescope live_grep <CR>", "Live grep" },
                z = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Current buffer" },

                -- Extensions
                d = {
                    name = "Dap",
                    c = {
                        function()
                            d.commands()
                        end,
                        "Commands",
                    },
                    f = {
                        function()
                            d.frames()
                        end,
                        "Frames",
                    },
                    v = {
                        function()
                            d.variables()
                        end,
                        "Variables",
                    },
                },
            },
        }, { mode = "n" })
    end,

    todo = function()
        local t = require "todo-comments"
        wk.register({
            ["]t"] = {
                function()
                    t.jump_next()
                end,
                "Next todo comment",
            },
            ["[t"] = {
                function()
                    t.jump_prev()
                end,
                "Previous todo comment",
            },
        }, { mode = "n" })
    end,

    toggleterm = function()
        wk.register({
            ["<A-h>"] = { "<cmd> ToggleTerm<CR>", "Toggle Terminal" },
        }, { mode = { "n", "t" } })
    end,

    trouble = function()
        local t = require "trouble"
        wk.register({
            ["<leader>t"] = {
                name = "Trouble",
                L = {
                    function()
                        t.last { skip_groups = true, jump = true }
                    end,
                    "Trouble last",
                },
                d = {
                    function()
                        t.toggle "document_diagnostics"
                    end,
                    "Trouble document diagnostics",
                },
                f = {
                    function()
                        t.first { skip_groups = true, jump = true }
                    end,
                    "Trouble first",
                },
                l = {
                    function()
                        t.toggle "loclist"
                    end,
                    "Trouble loclist",
                },
                n = {
                    function()
                        t.next { skip_groups = true, jump = true }
                    end,
                    "Trouble next",
                },
                p = {
                    function()
                        t.previous { skip_groups = true, jump = true }
                    end,
                    "Trouble prev",
                },
                q = {
                    function()
                        t.toggle "quickfix"
                    end,
                    "Trouble quickfix",
                },
                r = {
                    function()
                        t.toggle "loclist"
                    end,
                    "Trouble LSP references",
                },
                t = {
                    function()
                        t.toggle()
                    end,
                    "Toggle trouble",
                },
                w = {
                    function()
                        t.toggle "workspace_diagnostics"
                    end,
                    "Trouble workspace diagnostics",
                },
            },
        }, { mode = "n" })
    end,

    ufo = function()
        local u = require "ufo"
        local uf = require("plugins.configs.ufo")
    local bufnr = vim.api.nvim_get_current_buf()
        wk.register({
            L = {
                function()
                    u.peekFoldedLinesUnderCursor()
                end,
                "Peek folded lines under the cursor",
            },
            z = {
                M = {
                    function ()
                        u.closeAllFolds()
    u.setFoldVirtTextHandler(bufnr, uf.handler)
                    end,
                    "Close all Folds",
                },
                m = {
                    function ()
                        u.closeFoldsWith()
    u.setFoldVirtTextHandler(bufnr, uf.handler)
                    end,
                    "Close folds with",
                },
                R = {
                    function ()
                        u.openAllFolds()
                    end,
                    "Open all Folds",
                },
                r = {
                    function ()
                        u.openFoldsExceptKinds()
    u.setFoldVirtTextHandler(bufnr, uf.handler)
                    end,
                    "Open folds except kinds",
                },
            },
            ["]f"] = {
                function ()
                    uf.goNextClosedAndPeek()
                end,
                "Prev fold and peek",
            },
            ["[f"] = {
                function ()
                    uf.goPreviousClosedAndPeek()
                end,
                "Prev fold and peek",
            },
        }, { mode = "n" })
    end,

    undo = function()
        local u = require "undotree"
        wk.register({
            ["<leader>u"] = {
                function()
                    u.toggle()
                end,
                "Undo tree",
            },
        }, { mode = "n" })
    end,

    whichkey = function()
        wk.register({
            ["<leader>w"] = {
                name = "Which Key",
                K = {
                    function()
                        vim.cmd "WhichKey"
                    end,
                    "Which-key all keymaps",
                },
                k = {
                    function()
                        local input = vim.fn.input "WhichKey: "
                        vim.cmd("WhichKey " .. input)
                    end,
                    "Which-key query lookup",
                },
            },
        }, { mode = "n" })
    end,

    whitespace = function()
        local w = require "whitespace-nvim"
        wk.register({
            ["<leader><Space>"] = {
                function()
                    w.trim()
                end,
                "Remove Trailing White Space",
            },
        }, { mode = "n" })
    end,
}

return M
