local M = {}

function M.options()
    return {
        auto_install = true,
        ensure_installed = {
            "nix",
            "lua",
            "vim",
            "vimdoc",
            "regex",
            "bash",
            "json",
            "toml",
            "markdown",
            "markdown_inline",
        },
        highlight = {
            enable = true,
            use_languagetree = true,
        },
        indent = { enable = true },
    }
end

return M
