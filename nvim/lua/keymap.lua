local M = {}

function M.general()
    -- Escape
    vim.keymap.set("i", "jj", "<esc>")
    vim.keymap.set({ "n", "x", "i" }, "<Esc>", "<cmd>noh<CR><Esc>")

    -- Command mode remap
    vim.keymap.set({ "n", "v" }, "ö", ":")
    vim.keymap.set({ "n", "v" }, "qö", "q:")

    -- Start/end of line
    vim.keymap.set({ "n", "x", "o" }, "H", "^", { desc = "First char of line" })
    vim.keymap.set({ "n", "x", "o" }, "L", "$", { desc = "Last char of line" })

    -- Window
    vim.keymap.set("n", "<C-h>", "<C-w>h")
    vim.keymap.set("n", "<C-j>", "<C-w>j")
    vim.keymap.set("n", "<C-k>", "<C-w>k")
    vim.keymap.set("n", "<C-l>", "<C-w>l")

    -- Buffer
    vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>")
    vim.keymap.set("n", "<s-Tab>", "<cmd>bprev<CR>")

    -- Resize
    vim.keymap.set("n", "<A-k>", ":resize +2<CR>")
    vim.keymap.set("n", "<A-j>", ":resize -2<CR>")
    vim.keymap.set("n", "<A-h>", ":vertical resize +2<CR>")
    vim.keymap.set("n", "<A-l>", ":vertical resize -2<CR>")

    -- Center after move
    vim.keymap.set("n", "<C-d>", "<C-d>zz")
    vim.keymap.set("n", "<C-u>", "<C-u>zz")
    vim.keymap.set("n", "<C-f>", "<C-f>zz")
    vim.keymap.set("n", "<C-b>", "<C-b>zz")

    -- Remove s bind
    vim.keymap.set("n", "s", "<Nop>")

    -- Remove nightly lsp binds
    vim.keymap.del("n", "grr")
    vim.keymap.del("n", "gra")
    vim.keymap.del("n", "grn")
    vim.keymap.del("n", "gri")
end

function M.wk()
    require("which-key").add {
        mode = { "n", "v" },
        { "<leader>b", group = "Buffers" },
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "Diagnostics" },
        { "<leader>g", group = "Git" },
        { "<leader>gh", group = "Hunks" },
        { "<leader>gt", group = "Telescopes" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Telescopes" },
        { "<leader>u", group = "UI" },
        -- Localleader
        { "<localleader>", group = "," },
    }
end

function M.toggleterm()
    -- Open toggleterm
    vim.keymap.set(
        { "n", "i", "v" },
        "<C-t>",
        ":ToggleTerm size=40 dir=%:p:h direction=vertical name=Terminal<CR>",
        { desc = "Toggleterm" }
    )
    -- Terminal keymap
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { desc = "Terminal escape" })
    vim.keymap.set("t", "jj", [[<C-\><C-n>]], { desc = "Terminal escape" })
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Terminal move to left window" })
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "Terminal move to down window" })
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Terminal move to up window" })
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Terminal move to right window" })
    vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], { desc = "Terminal window commands" })
end

function M.git()
    vim.keymap.set("n", "<leader>gn", ":Neogit<CR>", { desc = "Open Neogit" })

    -- Hunk navigation
    vim.keymap.set("n", "<localleader>h", function()
        if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
        else
            require("gitsigns").nav_hunk "next"
        end
    end, { desc = "Jump to next hunk" })

    vim.keymap.set("n", "<localleader>H", function()
        if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
        else
            require("gitsigns").nav_hunk "prev"
        end
    end, { desc = "Jump to previous hunk" })

    -- Actions
    vim.keymap.set("n", "<leader>ghs", require("gitsigns").stage_hunk, { desc = "Stage hunk" })
    vim.keymap.set("n", "<leader>ghr", require("gitsigns").reset_hunk, { desc = "Reset hunk" })

    vim.keymap.set("v", "<leader>ghs", function()
        require("gitsigns").stage_hunk { vim.fn.line ".", vim.fn.line "v" }
    end, { desc = "Stage hunk" })

    vim.keymap.set("v", "<leader>ghr", function()
        require("gitsigns").reset_hunk { vim.fn.line ".", vim.fn.line "v" }
    end, { desc = "Reset hunk" })

    vim.keymap.set("n", "<leader>ghS", require("gitsigns").stage_buffer, { desc = "Stage buffer" })
    vim.keymap.set("n", "<leader>ghu", require("gitsigns").undo_stage_hunk, { desc = "Undo stage hunk" })
    vim.keymap.set("n", "<leader>ghR", require("gitsigns").reset_buffer, { desc = "Reset buffer" })
    vim.keymap.set("n", "<leader>ghp", require("gitsigns").preview_hunk, { desc = "Preview hunk" })

    vim.keymap.set("n", "<leader>ghb", function()
        require("gitsigns").blame_line { full = true }
    end, { desc = "Show blame" })

    vim.keymap.set("n", "<leader>gb", require("gitsigns").toggle_current_line_blame, { desc = "Toggle line blame" })
    vim.keymap.set("n", "<leader>ghd", require("gitsigns").diffthis, { desc = "Show diff" })

    vim.keymap.set("n", "<leader>ghD", function()
        require("gitsigns").diffthis "~"
    end, { desc = "Show diff ~" })

    vim.keymap.set("n", "<leader>gd", require("gitsigns").toggle_deleted, { desc = "Toggle deleted" })

    -- Git telescopes
    vim.keymap.set("n", "<leader>gtc", ":Telescope git_commits<CR>", { desc = "Commits" })
    vim.keymap.set("n", "<leader>gtb", ":Telescope git_branches<CR>", { desc = "Branches" })
    vim.keymap.set("n", "<leader>gtB", ":Telescope git_bcommits<CR>", { desc = "Bcommits" })
    vim.keymap.set("n", "<leader>gtf", ":Telescope git_files<CR>", { desc = "Files" })
    vim.keymap.set("n", "<leader>gts", ":Telescope git_stash<CR>", { desc = "Stash" })
    vim.keymap.set("n", "<leader>gs", ":Telescope git_status<CR>", { desc = "Git status" })
end

function M.grug()
    vim.keymap.set({ "n", "v" }, "<leader>r", function()
        local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
        require("grug-far").open {
            transient = true,
            prefills = {
                filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
        }
    end, { desc = "Search and replace" })
end

function M.trouble()
    vim.keymap.set("n", "<leader>dt", ":Trouble<CR>", { desc = "Trouble telescopes" })
    vim.keymap.set("n", "<leader>dd", ":Trouble diagnostics toggle<CR>", { desc = "Workspace diagnostics" })
    vim.keymap.set("n", "<leader>db", ":Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics" })
    vim.keymap.set("n", "<leader>ds", ":Trouble symbols toggle focus=false<CR>", { desc = "Document symbols" })
    vim.keymap.set(
        "n",
        "<leader>dr",
        ":Trouble lsp toggle focus=false win.position=right<CR>",
        { desc = "Show LSP ref / def / ..." }
    )
    vim.keymap.set("n", "<leader>dl", ":Trouble loclist toggle<CR>", { desc = "Toggle loclist" })
    vim.keymap.set("n", "<leader>dq", ":Trouble qflist toggle<CR>", { desc = "Toggle qflist" })
end

function M.mini()
    vim.keymap.set({ "n" }, "<leader>e", function()
        local _ = require("mini.files").close() or require("mini.files").open()
    end, { desc = "Toggle minifiles" })

    vim.keymap.set({ "n" }, "<leader>bd", function()
        require("mini.bufremove").delete()
    end, { desc = "Remove current buffer" })
end

function M.on_attach(client, bufnr)
    if client == nil then
        vim.notify("No client attached to buffer " .. bufnr, vim.log.levels.ERROR)
        return
    end

    -- LSP inspect client
    vim.keymap.set("n", "<leader>ui", function()
        require("autos").inspect_lsp_client()
    end, { desc = "Inspect LSP configuration", buffer = bufnr })

    -- On attach keymap
    vim.keymap.set("n", "gd", ":Trouble lsp_definitions<CR>", { desc = "Goto definition", buffer = bufnr })
    vim.keymap.set("n", "gD", ":Trouble lsp_declarations<CR>", { desc = "Goto declaration", buffer = bufnr })
    vim.keymap.set("n", "gr", ":Trouble lsp_references<CR>", { desc = "Goto references", buffer = bufnr })
    vim.keymap.set("n", "gi", ":Trouble lsp_implementations<CR>", { desc = "Goto implementation", buffer = bufnr })
    vim.keymap.set("n", "gt", ":Trouble lsp_type_definitions<CR>", { desc = "Type definition", buffer = bufnr })
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename", buffer = bufnr })
    vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action", buffer = bufnr })
    vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { desc = "Run Codelens", buffer = bufnr })

    vim.keymap.set({ "n", "i", "s" }, "<C-s>", function()
        vim.lsp.buf.signature_help()
    end, { desc = "Signature help", buffer = bufnr })

    -- Format with Conform and LSP fallback
    vim.keymap.set("n", "<leader>f", function()
        require("conform").format()
    end, { desc = "Format buffer", buffer = bufnr })

    -- Show line diagnostics
    vim.keymap.set("n", "<leader>cd", function()
        local _, winid = vim.diagnostic.open_float(nil, { scope = "line" })
        if not winid then
            vim.notify("No diagnostic found", vim.log.levels.INFO)
            return
        end
        vim.api.nvim_win_set_config(winid or 0, { focusable = true })
    end, { desc = "Show line diagnostics", buffer = bufnr })

    -- Toggle inlay hints
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        vim.keymap.set("n", "<leader>h", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
        end, { desc = "Toggle inlay hints", buffer = bufnr })
    end
end

function M.telescope()
    -- See `:help telescope.builtin`
    vim.keymap.set("n", "<leader>sd", ":Telescope diagnostics<CR>", { desc = "Search diagnostics" })
    vim.keymap.set("n", "<leader>sh", ":Telescope help_tags<CR>", { desc = "Search help" })
    vim.keymap.set("n", "<leader>sk", ":Telescope keymaps<CR>", { desc = "Search keymaps" })
    vim.keymap.set("n", "<leader>ss", ":Telescope builtin<CR>", { desc = "Search select telescope" })
    vim.keymap.set("n", "<leader>sw", ":Telescope grep_string<CR>", { desc = "Search current word" })
    vim.keymap.set("n", "<leader>sg", ":Telescope live_grep<CR>", { desc = "Search by grep" })
    vim.keymap.set("n", "<leader>sr", ":Telescope resume<CR>", { desc = "Search resume" })
    vim.keymap.set("n", "<leader>.", ":Telescope oldfiles<CR>", { desc = "Search recent files" })
    vim.keymap.set("n", "<leader>,", ":Telescope find_files<CR>", { desc = "Search files" })

    vim.keymap.set("n", "<leader><leader>", function()
        require("telescope.builtin").buffers(require("telescope.themes").get_dropdown { previewer = false })
    end, { desc = "Find existing buffers" })

    vim.keymap.set("n", "<leader>/", function()
        require("telescope.builtin").current_buffer_fuzzy_find(
            require("telescope.themes").get_dropdown { previewer = false }
        )
    end, { desc = "Fuzzy search current buffer" })

    vim.keymap.set("n", "<leader>ö", function()
        require("telescope.builtin").command_history(require("telescope.themes").get_dropdown { previewer = false })
    end, { desc = "Command history" })

    vim.keymap.set("n", "<leader>s/", function()
        require("telescope.builtin").live_grep {
            grep_open_files = true,
            prompt_title = "Live Grep in Open Files",
        }
    end, { desc = "Search in open files" })

    vim.keymap.set("n", "<leader>sn", function()
        require("telescope.builtin").find_files { cwd = vim.fn.expand "~/dotfiles/nvim" }
    end, { desc = "Search neovim files" })

    -- Extra pickers
    vim.keymap.set("n", "<leader>tc", "<cmd>Telescope colorscheme<CR>", { desc = "Colorschemes" })
    vim.keymap.set("n", "<leader>tm", ":Telescope marks<CR>", { desc = "Marks" })
    vim.keymap.set("n", "<leader>tr", ":Telescope registers<CR>", { desc = "Registers" })
    vim.keymap.set("n", "<leader>tt", ":TodoTelescope<CR>", { desc = "Todos and tags" })
    vim.keymap.set("n", "<leader>tn", ":Telescope noice<CR>", { desc = "Noice" })
    vim.keymap.set("n", "<leader>tp", ":Telescope projects<CR>", { desc = "projects" })
end

return M
