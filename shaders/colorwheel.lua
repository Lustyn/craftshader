local vec2 = require("math.vec2")
local vec3 = require("math.vec3")
local color = require("math.color")

return function(pos, c, buf)
    local npos = (pos - 1) / (buf.size - 1)
    local to_center = vec2(0.5, 0.5) - npos
    local angle = math.atan2(to_center.y, to_center.x)
    local radius = to_center:length() * 2

    return color.hsv2rgb(vec3(angle / (2 * math.pi) + 1, radius, 1))
end