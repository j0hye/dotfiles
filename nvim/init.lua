vim.loader.enable()

require("opts").start()

local lazy_path = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
local lazy_url = "https://github.com/folke/lazy.nvim"

if not vim.uv.fs_stat(lazy_path) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazy_url,
        lazy_path,
    }
end

vim.lsp.handlers["textDocument/signatureHelp"] = function(_, result, ctx, config)
    config = config or {}
    config.border = "rounded"

    return vim.lsp.buf.handlers.signature_help(_, result, ctx, config)
end

vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
    config = config or {}
    config.border = "rounded"

    return vim.lsp.buf.handlers.hover(_, result, ctx, config)
end

vim.opt.rtp:prepend(lazy_path)

require "plugins"
