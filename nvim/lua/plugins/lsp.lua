local M = {}

local servers = {
    clangd = {},
    lua_ls = {
        filetypes = { "lua" },
        settings = {
            Lua = {
                workspace = {
                    preloadFilesize = 5000,
                    checkThirdParty = false,
                },
                runtime = {
                    version = "LuaJIT",
                },
                completion = {
                    callSnippet = "Replace",
                },
                diagnostics = {
                    workspaceRate = 100,
                    globals = { "vim" },
                    disable = { "missing-fields" },
                },
                hint = {
                    enable = true,
                },
                codeLens = {
                    enable = true,
                },
                signatureHelp = {
                    enable = true,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    nixd = {
        filetypes = { "nix" },
        cmd = { "nixd" },
        settings = {
            nixpkgs = {
                expr = { 'import (builtins.getFlake "/home/johye/.config/nix-config").inputs.nixpkgs { }' },
            },
            options = {
                nixos = {
                    expr = 'import (builtins.getFlake "/home/johye/.config/nix-config").nixosConfigurations.WSL.options',
                },
                home_manager = {
                    expr = 'import (builtins.getFlake "/home/johye/.config/nix-config").homeConfigurations.johye.options',
                },
            },
        },
    },
}

function M.config()
    local lspconfig = require "lspconfig"

    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities.textDocument.completion.completionItem.snippetSupport = true
    -- Blink capabilities instead

    local on_attach = require("keymap").on_attach

    for server, config in pairs(servers) do
        config.on_attach = on_attach
        config.capabilities = vim.tbl_deep_extend(
            "force",
            {},
            require("blink.cmp").get_lsp_capabilities(config.capabilites),
            config.capabilities or {}
        )
        lspconfig[server].setup(config)
    end
end

function M.conform()
    return {
        formatters_by_ft = {
            lua = { "stylua" },
            nix = { "alejandra" },
        },
        format_on_save = {
            -- These options will be passed to conform.format()
            timeout_ms = 500,
            lsp_format = "fallback",
        },
    }
end

function M.lazydev()
    return {
        library = {
            { path = "luvit-meta/library", words = { "vim%.uv" } },
        },
        integrations = {
            lspconfig = true,
            cmp = true,
        },
    }
end

function M.mason_config()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    require("mason").setup {
        ui = {
            border = "single",
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        },
    }

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
        -- "stylua",
    })

    require("mason-tool-installer").setup { ensure_installed = ensure_installed }

    require("mason-lspconfig").setup {
        handlers = {
            function(server_name)
                local server = servers[server_name] or {}
                server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                require("lspconfig")[server_name].setup(server)
            end,
        },
    }
end

return M
