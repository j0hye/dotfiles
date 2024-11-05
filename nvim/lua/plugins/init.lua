local function mini_setup()
    local mini = require "plugins.mini"
    for _, module in ipairs(mini.modules) do
        require("mini." .. module).setup(mini[module] or {})
    end
end

local plugins = {
    { -- Colorscheme
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        init = function()
            require("rose-pine").setup {
                styles = {
                    transparency = true,
                },
            }
            vim.cmd.colorscheme "rose-pine"
        end,
    },
    { -- Mini plugins
        "echasnovski/mini.nvim",
        event = "VimEnter",
        keys = require("keymap").mini,
        config = mini_setup,
    },
    { -- Projects
        "ahmedkhalf/project.nvim",
        dependencies = "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        config = function()
            require("project_nvim").setup {}
        end,
    },
    { -- Toggleterm
        "akinsho/toggleterm.nvim",
        keys = require("keymap").toggleterm,
        event = "VeryLazy",
        opts = require("plugins.toggleterm").options,
    },
    { -- Git
        "NeogitOrg/neogit",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "lewis6991/gitsigns.nvim", opts = require("plugins.git").gitsigns },
            { "sindrets/diffview.nvim", opts = require("plugins.git").diffview },
        },
        event = "VeryLazy",
        keys = require("keymap").git,
        opts = require("plugins.git").neogit,
    },
    { -- Noice
        "folke/noice.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            { "smjonas/inc-rename.nvim", opts = {} },
        },
        event = "VeryLazy",
        opts = require("plugins.ui").noice,
    },
    { -- Which-key
        "folke/which-key.nvim",
        event = "VeryLazy",
        keys = require("keymap").wk,
        opts = require("plugins.wk").options,
    },
    { -- Telescope
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        version = "0.1.*",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "nvim-tree/nvim-web-devicons" },
            { "folke/todo-comments.nvim", opts = {} },
        },
        keys = require("keymap").telescope,
        opts = require("plugins.telescope").options,
    },
    { -- Trouble
        "folke/trouble.nvim",
        cmd = "Trouble",
        event = "VeryLazy",
        keys = require("keymap").trouble,
        opts = {},
    },
    { -- Completion
        "Saghen/blink.cmp",
        dependencies = {
            -- { "Saghen/blink.compat", opts = { impersonate_nvim_cmp = true } },
            "rafamadriz/friendly-snippets",
        },
        -- lazy = false,
        -- version = "v0.*.*",
        event = "VeryLazy",
        build = "nix run .#build-plugin",
        opts = require("plugins.cmp").blink,
    },
    { -- Tabout
        "abecodes/tabout.nvim",
        dependencies = {
            "Saghen/blink.cmp",
        },
        event = "InsertCharPre",
        opts = require("plugins.cmp").tabout,
    },
    { -- Buffers
        "romgrk/barbar.nvim",
        dependencies = {
            "lewis6991/gitsigns.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        event = { "VeryLazy" },
        keys = require("keymap").barbar,
        opts = {},
    },
    { -- Statusline
        "nvim-lualine/lualine.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = require("plugins.lualine").options,
    },
    { -- Treesitter
        "nvim-treesitter/nvim-treesitter",
        version = false,
        lazy = vim.fn.argc(-1) == 0,
        main = "nvim-treesitter.configs",
        build = ":TSUpdate",
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
        event = { "BufReadPost", "BufNewFile" },
        opts = require("plugins.treesitter").options,
    },
    { -- Guess-indent
        "NMAC427/guess-indent.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
    },
    { -- Search and replace
        "MagicDuck/grug-far.nvim",
        cmd = "GrugFar",
        event = { "BufReadPost", "BufNewFile" },
        keys = require("keymap").grug,
        opts = {},
    },
    { -- LSP and Mason setup
        "neovim/nvim-lspconfig",
        dependencies = {
            -- { "williamboman/mason.nvim", config = true },
            -- { "williamboman/mason-lspconfig.nvim" },
            -- { "WhoIsSethDaniel/mason-tool-installer.nvim" },
            "Saghen/blink.cmp",
            {
                "folke/lazydev.nvim",
                ft = "lua",
                dependencies = { "Bilal2453/luvit-meta", lazy = true },
                opts = require("plugins.lsp").lazydev,
            },
        },
        event = { "BufReadPost", "BufNewFile" },
        config = require("plugins.lsp").config,
    },
    { -- Conform
        "stevearc/conform.nvim",
        event = "LspAttach",
        opts = require("plugins.lsp").conform,
    },
    { -- Options, mappings and autos
        name = "Options",
        event = "VeryLazy",
        dir = vim.fn.stdpath "config",
        config = function()
            require("opts").after()
            require("utils").autocmds()
            require("keymap").general()
        end,
    },
}
require("lazy").setup(plugins, require("plugins.lazy").options())
