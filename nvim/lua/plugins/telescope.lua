local M = {}

function M.options()
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
    pcall(require("telescope").load_extension, "noice")
    pcall(require("telescope").load_extension, "projects")

    return {
        defaults = { winblend = vim.o.winblend },
        extensions = {
            ["ui-select"] = {
                require("telescope.themes").get_dropdown(),
            },
        },
    }
end

return M
