---@diagnostic disable: deprecated
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

vim.opt.rtp:prepend(lazy_path)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

require "plugins"
