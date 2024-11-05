local opt = vim.opt
local g = vim.g
local opts = {}

function opts.start()
    g.mapleader = " "
    g.maplocalleader = ","
    g.editorconfig = true
    vim.o.background = "dark"
    opt.laststatus = 3
    opt.clipboard = "unnamed,unnamedplus"
    opt.termguicolors = true
    opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    opt.shortmess:append "aIF"
    opt.cursorline = true
    opt.cursorlineopt = "number"
    opt.ruler = true
    opt.number = true
    opt.relativenumber = true
    opt.breakindent = true
    opt.linebreak = true
    opt.swapfile = false
    opt.undofile = true
    opt.cmdheight = 0
    opt.mouse = "a"
    opt.signcolumn = "yes"
    opt.lazyredraw = false

    -- Statusline
    local statusline = ""
    opt.statusline = "%#Normal#" .. statusline .. "%="
end

function opts.after()
    opt.completeopt = { "menuone", "noselect", "noinsert" }
    opt.wildmenu = true
    opt.pumheight = 15
    opt.ignorecase = true
    opt.smartcase = true
    opt.timeout = true
    opt.timeoutlen = 500
    opt.updatetime = 100
    opt.confirm = false
    opt.equalalways = false
    opt.splitbelow = true
    opt.splitright = true
    opt.scrolloff = 8

    -- Indenting
    opt.shiftwidth = 4
    opt.smartindent = true
    opt.tabstop = 4
    opt.expandtab = true
    opt.softtabstop = 4
    opt.sidescrolloff = 4

    -- Disable providers
    g.loaded_node_provider = 0
    g.loaded_python3_provider = 0
    g.loaded_perl_provider = 0
    g.loaded_ruby_provider = 0

    -- Folding options
    opt.foldcolumn = "0"
    opt.foldlevel = 99
    opt.foldlevelstart = 99
    opt.foldenable = true

    -- Increamental searching
    opt.incsearch = true
    opt.hlsearch = true

    -- Disable text wrap
    opt.wrap = false
end

--- Load shada after ui-enter
local shada = vim.o.shada
vim.o.shada = ""
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        vim.o.shada = shada
        pcall(vim.cmd.rshada, { bang = true })
    end,
})

vim.diagnostic.config {
    virtual_text = {
        prefix = "",
        suffix = "",
        format = function(diagnostic)
            return "󰍡 " .. diagnostic.message .. " "
        end,
    },
    underline = {
        severity = { min = vim.diagnostic.severity.WARN },
    },
    signs = {
        text = {
            [vim.diagnostic.severity.HINT] = "󱐮",
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.INFO] = "◉",
            [vim.diagnostic.severity.WARN] = "",
        },
    },
    float = {
        border = "single",
    },
}
return opts
