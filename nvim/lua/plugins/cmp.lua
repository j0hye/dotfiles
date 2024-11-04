local M = {}

function M.blink()
    -- HACK: FIX TAB AND S-TAB BIND IN SNIPPET
    -- https://github.com/neovim/neovim/issues/30198#issuecomment-2326075321
    if vim.fn.has "nvim-0.11" == 1 then
        -- Ensure that forced and not configurable `<Tab>` and `<S-Tab>`
        -- buffer-local mappings don't override already present ones
        local expand_orig = vim.snippet.expand
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.snippet.expand = function(...)
            vim.keymap.set({ "i", "s" }, "<Tab>", "<Plug>(Tabout)", { silent = true })
            vim.keymap.set({ "i", "s" }, "<S-Tab>", "<Plug>(TaboutBack)", { silent = true })
            local tab_map = vim.fn.maparg("<Tab>", "i", false, true)
            local stab_map = vim.fn.maparg("<S-Tab>", "i", false, true)
            local tab_map_s = vim.fn.maparg("<Tab>", "s", false, true)
            local stab_map_s = vim.fn.maparg("<S-Tab>", "s", false, true)
            expand_orig(...)
            vim.schedule(function()
                tab_map.buffer, stab_map.buffer = 1, 1
                tab_map_s.buffer, stab_map_s.buffer = 1, 1
                -- Override temporarily forced buffer-local mappings
                vim.fn.mapset("i", false, tab_map)
                vim.fn.mapset("i", false, stab_map)
                vim.fn.mapset("s", false, tab_map_s)
                vim.fn.mapset("s", false, stab_map_s)
            end)
        end
    end

    return {
        keymap = {
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-e>"] = { "hide" },
            ["<C-y>"] = { "select_and_accept" },

            ["<C-p>"] = { "select_prev" },
            ["<C-n>"] = { "select_next" },

            ["<C-b>"] = { "scroll_documentation_up" },
            ["<C-f>"] = { "scroll_documentation_down" },

            ["<C-l>"] = { "snippet_forward" },
            ["<C-h>"] = { "snippet_backward" },
        },
        highlight = {
            use_nvim_cmp_as_default = true,
        },
        nerd_font_variant = "normal",
        windows = {
            autocomplete = {
                border = "single",
                draw = "reversed",
            },
            documentation = {
                border = "single",
            },
            signature_help = {
                border = "single",
            },
            ghost_text = {
                enabled = false,
            },
        },
        sources = {
            completion = {
                enable_providers = { "lsp", "path", "snippets", "buffer", "lazydev" },
            },
            providers = {
                lsp = {
                    fallback_for = { "lazydev" },
                },
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                },
            },
        },
    }
end

function M.tabout()
    return {
        tabkey = "<Tab>",
        backwards_tabkey = "<S-Tab>",
        act_as_tab = false,
        act_as_shift_tab = false,
        default_tab = "<C-t>",
        default_shift_tab = "<C-d>",
        enable_backwards = true,
        completion = false,
        tabouts = {
            { open = "'", close = "'" },
            { open = '"', close = '"' },
            { open = "`", close = "`" },
            { open = "(", close = ")" },
            { open = "[", close = "]" },
            { open = "{", close = "}" },
            { open = "<", close = ">" },
        },
        ignore_beginning = true,
        exclude = {},
    }
end

function M.care()
    return {
        ui = {
            menu = {
                border = "single",
                format_entry = require("care.presets").Default, --Atom/Default
            },
            docs_view = {
                border = "single",
            },
            ghost_text = {
                enabled = false,
                position = "inline", -- inline/overlay
            },
        },
        snippet_expansion = function(body)
            require("luasnip").lsp_expand(body)
        end,
    }
end

function M.careeee()
    return {
        "max397574/care.nvim",
        dependencies = {
            "max397574/care-cmp",
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp",
                config = function()
                    return {}
                end,
            },
        },
        event = { "VimEnter", "VeryLazy", "BufReadPost", "BufNewFile" },
        keys = require("keymap").care,
        opts = require("plugins.cmp").care,
    }
end

return M
