local color = require("math.color")

return function(pos, color, buf)
    local npos = (pos - 1) / (buf.size - 1)
    return color.hsv2rgb(npos.x, npos.y, 1)
end