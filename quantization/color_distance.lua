local distance = {}

function distance.color_distance(distance_func)
    return function(pos, color, buf, palette)
        local dist
        local best
        for i = 1, 16 do
            local new_color = palette[i]
            local new_dist = distance_func(color, new_color)
            if dist == nil or new_dist < dist then
                dist = new_dist
                best = i
            end
        end
    
        return best
    end
end

distance.rgb = distance.color_distance(function(color, new_color)
    return math.abs(color:distance(new_color))
end)

distance.rgb2 = distance.color_distance(function(color, new_color)
    local dr = new_color.x - color.x
    local dg = new_color.y - color.y
    local db = new_color.z - color.z
    if color.x > 0.5 then
        return math.sqrt(2 * dr + 4 * dg + 3 * db)
    else
        return math.sqrt(3 * dr + 4 * dg + 2 * db)
    end
end)

distance.rgb3 = distance.color_distance(function(color, new_color)
    local dr = new_color.x - color.x
    local dg = new_color.y - color.y
    local db = new_color.z - color.z

    return math.sqrt(3 * dr + 4 * dg + 2 * db)
end)

return distance