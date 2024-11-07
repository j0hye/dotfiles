local M = {}

function M.bufferline()
    return {
        options = {
            style_preset = 2,
            themable = true,
            indicator = {
                style = "none",
            },
            separator_style = { "", "" },
        },
    }
end

function M.noice()
    return {
        cmdline = {
            enabled = true,
            view = "cmdline",
            format = {
                input = { view = "cmdline" },
            },
            opts = {
                position = {
                    row = -1,
                },
            },
        },
        messages = {
            enabled = true,
            view = "mini",
        },
        notify = {
            enabled = true,
            view = "mini",
        },
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
            },
            hover = {
                enabled = false,
            },
            signature = {
                enabled = false,
            },
        },
        views = {
            mini = {
                timeout = 5000,
                win_options = {
                    winblend = vim.o.winblend,
                },
            },
        },
    }
end

return M
