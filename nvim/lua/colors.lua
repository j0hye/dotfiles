local M = {}
local g = vim.g
local opt = vim.opt

function M.options()
    if vim.g.neovide then
        opt.winblend = 25
        opt.pumblend = 25
        g.neovide_transparency = 0.95
        g.neovide_padding_top = 0
        g.neovide_padding_bottom = 0
        g.neovide_padding_right = 0
        g.neovide_padding_left = 0
        g.neovide_floating_blur_amount_x = 2.0
        g.neovide_floating_blur_amount_y = 2.0
        g.neovide_refresh_rate = 240
        g.neovide_cursor_antialiasing = true
        g.neovide_cursor_animate_in_insert_mode = true
        g.neovide_cursor_animate_command_line = true
    end

    local use_cs = "rose-pine"

    local setups = {
        ["rose-pine"] = {
            styles = {
                transparency = true,
            },
            highlight_groups = {
                -- BufferCurrent = { bg = "Normal" },
                -- BufferCurrentSign = { bg = "Normal", fg = "Normal" },
                -- BufferCurrentSignRight = { bg = "Normal", fg = "Normal" },
                BufferDefaultCurrentSign = { fg = "NONE", gui = "NONE" },
                BufferDefaultVisibleSign = { fg = "NONE", gui = "NONE" },
                BufferDefaultInactiveSign = { fg = "NONE", gui = "NONE" },
                BufferDefaultCurrentSignRight = { fg = "NONE", gui = "NONE" },
                BufferDefaultVisibleSignRight = { fg = "NONE", gui = "NONE" },
                BufferDefaultInactiveSignRight = { fg = "NONE", gui = "NONE" },
                BufferDefaultAlternateSignRight = { fg = "NONE", gui = "NONE" },
            },
        },
        kanagawa = {
            transparent = true,
        },
    }

    local setups_neovide = {
        ["rose-pine"] = {
            styles = {
                transparency = false,
            },
        },
        kanagawa = {
            transparent = true,
        },
    }
    if setups[use_cs] or setups_neovide[use_cs] then
        if vim.g.neovide then
            require(use_cs).setup(setups_neovide[use_cs] or {})
        else
            require(use_cs).setup(setups[use_cs] or {})
        end
    else
        vim.notify("No colorscheme setup found", vim.log.levels.WARN)
    end
    vim.cmd.colorscheme(use_cs)
end

return M
