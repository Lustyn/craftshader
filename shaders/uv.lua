local vec3 = require("math.vec3")

return function(pos, color, buf)
    local npos = (pos - 1) / (buf.size - 1)
    return vec3(npos.x, npos.y, 1)
end