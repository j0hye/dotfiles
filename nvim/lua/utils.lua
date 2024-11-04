local M = {}

-- LSP inspect
function M.inspect_lsp_client()
    vim.ui.input({ prompt = "Enter LSP Client name: " }, function(client_name)
        if client_name then
            local client = vim.lsp.get_clients { name = client_name }

            if #client == 0 then
                vim.notify("No active LSP clients found with this name: " .. client_name, vim.log.levels.WARN)
                return
            end

            -- Create a temporary buffer to show the configuration
            local buf = vim.api.nvim_create_buf(false, true)
            local win = vim.api.nvim_open_win(buf, true, {
                relative = "editor",
                width = math.floor(vim.o.columns * 0.75),
                height = math.floor(vim.o.lines * 0.90),
                col = math.floor(vim.o.columns * 0.125),
                row = math.floor(vim.o.lines * 0.05),
                style = "minimal",
                border = "single",
                title = " " .. (client_name:gsub("^%l", string.upper)) .. ": LSP Configuration ",
                title_pos = "center",
            })

            local lines = {}
            for i, this_client in ipairs(client) do
                if i > 1 then
                    table.insert(lines, string.rep("-", 80))
                end
                table.insert(lines, "Client: " .. this_client.name)
                table.insert(lines, "ID: " .. this_client.id)
                table.insert(lines, "")
                table.insert(lines, "Configuration:")

                local config_lines = vim.split(vim.inspect(this_client.config), "\n")
                vim.list_extend(lines, config_lines)
            end

            -- Set the lines in the buffer
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

            -- Set buffer options
            vim.bo[buf].modifiable = false
            vim.bo[buf].filetype = "lua"
            vim.bo[buf].bh = "delete"

            vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
        end
    end)
end

-- Autocommands
function M.autocmds()
    local autocmd = vim.api.nvim_create_autocmd

    local function augroup(name, clear)
        return vim.api.nvim_create_augroup(name, { clear = clear })
    end

    -- Disable qflist and use trouble
    autocmd("BufRead", {
        callback = function(ev)
            if vim.bo[ev.buf].buftype == "quickfix" then
                vim.schedule(function()
                    vim.cmd [[cclose]]
                    vim.cmd [[Trouble qflist open]]
                end)
            end
        end,
    })

    -- Disable indentscope in terminal
    vim.b.miniindentscope_disable = true
    autocmd("TermOpen", {
        desc = "Disable 'mini.indentscope' in terminal buffer",
        callback = function(data)
            vim.b[data.buf].miniindentscope_disable = true
        end,
    })

    -- Lsp attach autos
    autocmd("LspAttach", {
        group = augroup("lsp-attach", false),
        callback = function(event)
            local client = vim.lsp.get_client_by_id(event.data.client_id)

            -- Codelens auto refresh
            if client and client.server_capabilities.codeLensProvider then
                autocmd({ "InsertLeave", "BufEnter" }, {
                    group = augroup "cl-refresh",
                    callback = function()
                        vim.lsp.codelens.refresh { bufnr = event.buf }
                    end,
                    buffer = event.buf,
                })
                vim.lsp.codelens.refresh { bufnr = event.buf }
            end

            -- Cursor word highlight
            if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                autocmd({ "CursorHold", "CursorHoldI" }, {
                    buffer = event.buf,
                    group = augroup("cursor-hl", false),
                    callback = vim.lsp.buf.document_highlight,
                })

                autocmd({ "CursorMoved", "CursorMovedI" }, {
                    buffer = event.buf,
                    group = augroup("cursor-hl", false),
                    callback = vim.lsp.buf.clear_references,
                })

                autocmd("LspDetach", {
                    group = augroup "cursor-hl-detach",
                    callback = function(ev)
                        vim.lsp.buf.clear_references()
                        vim.api.nvim_clear_autocmds { group = "cursor-hl", buffer = ev.buf }
                    end,
                })
            end
        end,
    })

    -- Highlight on yank
    autocmd("TextYankPost", {
        group = augroup "highlight_yank",
        callback = function()
            vim.highlight.on_yank()
        end,
    })

    -- Resize splits if window got resized
    autocmd({ "VimResized" }, {
        group = augroup "resize_splits",
        callback = function()
            local current_tab = vim.fn.tabpagenr()
            vim.cmd "tabdo wincmd ="
            vim.cmd("tabnext " .. current_tab)
        end,
    })

    -- Make it easier to close man-files when opened inline
    autocmd("FileType", {
        group = augroup "man_unlisted",
        pattern = { "man" },
        callback = function(event)
            vim.bo[event.buf].buflisted = false
        end,
    })

    -- Wrap and check for spell in text filetypes
    autocmd("FileType", {
        group = augroup "wrap_spell",
        pattern = { "gitcommit", "markdown" },
        callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.spell = true
        end,
    })

    -- Fix conceallevel for json files
    autocmd({ "FileType" }, {
        group = augroup "json_conceal",
        pattern = { "json", "jsonc", "json5" },
        callback = function()
            vim.opt_local.conceallevel = 0
        end,
    })

    -- Do not set undofile for files in /tmp
    autocmd("BufWritePre", {
        pattern = "/tmp/*",
        group = augroup "tmpdir",
        callback = function()
            vim.cmd.setlocal "noundofile"
        end,
    })

    -- Disable spell checking in terminal buffers
    autocmd("TermOpen", {
        group = augroup "nospell",
        callback = function()
            vim.wo[0].spell = false
        end,
    })
end

return M
