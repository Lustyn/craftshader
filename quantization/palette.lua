local color = require("math.color")

local DEFAULT_PALETTE = {
    color.rgb8(240, 240, 240),
    color.rgb8(242, 178, 51),
    color.rgb8(229, 127, 216),
    color.rgb8(153, 178, 242),
    color.rgb8(222, 222, 108),
    color.rgb8(127, 204, 25),
    color.rgb8(242, 178, 204),
    color.rgb8(76, 76, 76),
    color.rgb8(153, 153, 153),
    color.rgb8(76, 153, 178),
    color.rgb8(178, 102, 229),
    color.rgb8(51, 102, 204),
    color.rgb8(127, 102, 76),
    color.rgb8(87, 166, 78),
    color.rgb8(204, 76, 76),
    color.rgb8(17, 17, 17)
}

local palette = {}

function palette.default()
    return DEFAULT_PALETTE
end

return palette