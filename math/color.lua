local vec3 = require("math.vec3")

local color = {}

function color.mmd(rgb)
    local r, g, b = rgb:unpack()
    local min = math.min(r, g, b)
    local max = math.max(r, g, b)
    local delta = max - min
    return min, max, delta
end

function color.hue2rgb(hue)
    local r = math.abs(hue * 6 - 3) - 1
    local g = 2 - math.abs(hue * 6 - 2)
    local b = 2 - math.abs(hue * 6 - 4)
    return vec3(r, g, b):clamp(0, 1) 
end

function color.rgb2hue(rgb)
    local min, max, delta = color.mmd(rgb)

    if delta == 0 then return 0 end

    if r == max then
        h = (g - b) / delta 
    elseif g == max then
        h = 2 + (b - r) / delta
    else
        h = 4 + (r - g) / delta
    end
    
    if h < 0 then h = h + 1 end

    return h
end

function color.hsv2rgb(hsv)
    local rgb = color.hue2rgb(hsv.x)
    return ((rgb - 1) * hsv.y + 1) * hsv.z
end

function color.rgb2hsv(rgb)
    error("Not implemented")
end

function color.hsl2rgb(hsl)
    local rgb = hue2rgb(hsl.x)
    local c = (1 - math.abs(2 * hsl.z - 1)) * hsl.y
    return (rgb - 0.5) * c + hsl.z
end

function color.rgb2hsl(rgb)
    local h, s, l = color.rgb2hue(rgb)
    local min, max, delta = color.mmd(rgb)
    l = max
    if max ~= 0 then
        s = delta / max
    else
        s = 0
        return vec3(h, s, l)
    end

    return vec3(h, s, l)
end

function color.rgb8(r, g, b)
    return vec3(r/255, g/255, b/255)
end

return color