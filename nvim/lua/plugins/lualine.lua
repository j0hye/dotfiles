local M = {}

function M.options()
    vim.opt.showcmdloc = "statusline"

    local function macro_status()
        if vim.fn.reg_recording() ~= "" then
            return "  @" .. vim.fn.reg_recording()
        else
            return ""
        end
    end

    local function buffer_lsp()
        local clients = vim.lsp.get_clients { bufnr = 0 }

        if next(clients) == nil then
            return ""
        end

        local c = {}
        for _, client in pairs(clients) do
            table.insert(c, client.name)
        end

        return "  " .. table.concat(c, " | ")
    end

    return {
        options = {
            theme = "auto",
        },
        sections = {
            lualine_x = {
                "%S",
                macro_status,
                buffer_lsp,
                "filetype",
            },
        },
    }
end

return M
