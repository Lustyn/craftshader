local color = require("math.color")
local vec3 = require("math.vec3")

return function(pos, c, buf)
    local npos = (pos - 1) / (buf.size - 1)
    return color.hsv2rgb(vec3(npos.x, npos.y, 1))
end