local M = {}

function M.options()
    local hls = require "rose-pine.plugins.toggleterm"
    return {
        highlights = hls,
    }
end

return M
