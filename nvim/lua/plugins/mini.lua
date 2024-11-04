local M = {}

M.modules = {
    "comment",
    "jump",
    "starter",
    "pairs",
    "ai",
    "surround",
    "files",
    "hipatterns",
    "bufremove",
    "indentscope",
    "move",
}

M.surround = {}

M.pairs = {
    mappings = {
        ["<"] = { action = "closeopen", pair = "<>", neigh_pattern = "[^\\].", register = { cr = false } },
    },
}

M.files = {
    use_as_default_explorer = true,
    windows = {
        max_number = math.huge,
        preview = false,
        width_focus = 30,
        width_nofocus = 20,
        width_preview = 25,
    },
}

local hipatterns = require "mini.hipatterns"
M.hipatterns = {
    highlighters = {
        hex_color = hipatterns.gen_highlighter.hex_color(),
    },
}

M.bufremove = {
    silent = true,
}

M.comment = {}

M.move = {
    mappings = {
        left = "<S-A-h>",
        right = "<S-A-l>",
        down = "<S-A-j>",
        up = "<S-A-k>",
        line_left = "<S-A-h>",
        line_right = "<S-A-l>",
        line_down = "<S-A-j>",
        line_up = "<S-A-k>",
    },
}

M.indentscope = {
    symbol = "┋",
}

M.ai = {}

local starter = require "mini.starter"
local version_info = vim.fn.system("nvim --version"):match "^[^\n]+"
M.starter = {
    evaluate_single = false,
    header = table.concat({
        " __________",
        "< Neovim!!!>",
        " ----------",
        "        \\   ^__^",
        "         \\  (oo)\\_______",
        "            (__)\\       )\\/\\",
        "                ||----w |",
        "                ||     ||",
    }, "\n"),
    footer = os.date() .. "\n" .. version_info,

    items = {
        {
            name = "Projects  ",
            action = ":Telescope projects",
            section = "Actions ",
        },
        {
            name = "Bookmarked files 󰃀",
            action = ":TodoTelescope",
            section = "Actions ",
        },
        { name = "Open blank file 󰯉", action = ":enew", section = "Actions " },
        { name = "Find files ", action = ":Telescope find_files", section = "Actions " },
        { name = "Recent files ", action = ":Telescope oldfiles", section = "Actions " },
        { name = "Lazy 󰒲", action = ":Lazy", section = "Actions " },
        { name = "Quit 󱍢", action = ":q!", section = "Actions " },
    },
    content_hooks = {
        starter.gen_hook.aligning("center", "center"),
    },
}

return M
