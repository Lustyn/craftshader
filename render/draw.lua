local fastsplit = require("quantization.fastsplit")
local palette = require("quantization.palette")
local utils = require("utils")

local draw = {}

local PALETTE_CHARS = {"0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"}
local function TO_PALETTE_CHARS(i) return PALETTE_CHARS[i] end

function draw.slice_image(image)
    local slices = {}
    for i = 1, image.size.y do
        local start = 1 + image.size.x * (i - 1)
        local finish = start + image.size.x - 1
        slices[i] = fastsplit.slice(image.data, start, finish)
    end
    return slices
end

function draw.concat_hex(slices)
    return utils.map(function(slice)
        return table.concat(utils.map(TO_PALETTE_CHARS, slice))
    end, slices)
end

function draw.draw_image(image, x, y)
    draw.set_palette(image.palette)
    local x = x or 1
    local y = y or 1
    local lines = draw.concat_hex(draw.slice_image(image))
    local blank = (" "):rep(image.size.x)
    for i = 1, #lines do
        term.setCursorPos(x, y + i - 1)
        term.blit(blank, blank, lines[i])
    end
end

function draw.set_palette(palette)
    for i, v in pairs(palette) do
        term.setPaletteColour(math.pow(2, i - 1), v.x, v.y, v.z)
    end
end

function draw.default_palette()
    draw.set_palette(palette.default())
end

return draw