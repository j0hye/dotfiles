local M = {}

function M.options()
    return {
        concurrency = vim.uv.available_parallelism() * 2,
        git = {
            timeout = 480,
        },
        defaults = {
            lazy = true,
        },
        performance = {
            cache = {
                enabled = true,
            },
            reset_packpath = false,
            rtp = {
                reset = false,
                disabled_plugins = {
                    "osc52",
                    "parser",
                    "gzip",
                    "netrwPlugin",
                    "health",
                    "man",
                    "matchit",
                    "rplugin",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "zipPlugin",
                    "shadafile",
                    "spellfile",
                    "editorconfig",
                },
            },
        },
        ui = {
            border = "single",
            -- border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
            title = "lazy.nvim",
        },
    }
end

return M
