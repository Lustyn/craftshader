local fastsplit = require("quantization.fastsplit")

local median_split = {}

local function largest_dimension(data)
    local bounds = {x={},y={},z={}}
    for i = 1, #data do
        for _, dim in pairs({"x", "y", "z"}) do
            local lower = bounds[dim][1]
            local upper = bounds[dim][2]
            local value = data[i][dim]
            if lower == nil or value < lower then
                bounds[dim][1] = value
            end
            if upper == nil or value > upper then
                bounds[dim][2] = value
            end
        end
    end

    local largest_range
    local largest_dim
    for _, dim in pairs({"x", "y", "z"}) do
        local lower = bounds[dim][1]
        local upper = bounds[dim][2]
        local size = upper - lower
        
        if largest_range == nil or size > largest_range then
            largest_range = size
            largest_dim = dim
        end 
    end

    return largest_dim, largest_range, bounds
end

local function boundbox(data)
    local dim, range, bounds = largest_dimension(data)
    return {
        dim = dim,
        range = range,
        data = data
    }
end

local function average_color(box)
    local average
            
    for i = 1, #box.data do
        if average == nil then
            average = box.data[i]
        else
            average = (average + box.data[i]) / 2
        end
    end

    return average
end

local function split_median(box)
    local b1, b2 = fastsplit.split(box.data, math.floor(#box.data / 2))
    return boundbox(b1), boundbox(b2)
end

--[[
local function split_mean(box)
    local mean = 0
    for _, v in pairs(box.data) do
        mean = mean + v[box.dim]
    end
    mean = mean / #box.data

    local best = math.huge
    local besti
    for k, v in pairs(box.data) do
        local range = math.abs(v[box.dim] - mean)
        if range < best then
            best = range
            besti = k
        end
    end

    local b1, b2 = split_table(box.data, besti)
    if #b1 == 0 and #b2 > 0 then
        return boundbox(b2), boundbox(b2)
    elseif #b2 == 0 and #b1 > 0 then
        return boundbox(b1), boundbox(b1)
    elseif #b2 == 0 and #b1 == 0 then
    else
        return boundbox(b1), boundbox(b2)
    end
end
]]--

local function median_split(image, color_count)
    local color_count = color_count or 16
    local boxes = {}
    table.insert(boxes, boundbox(fastsplit.copy(image.data)))

    for n = 1, color_count - 1 do
        table.sort(boxes, function(a, b) return a.range > a.range end)
        local box = table.remove(boxes)
        local sort_dim = box.dim
        table.sort(box, function(a, b) return a[sort_dim] < a[sort_dim] end)
        local t1, t2 = split_median(box)
        table.insert(boxes, t1)
        table.insert(boxes, t2)
    end

    local colors = {}

    for _, box in pairs(boxes) do
        table.insert(colors, average_color(box))
    end
    
    return colors
end

return median_split