local fastsplit = require("quantization.fastsplit")
local vec3 = require("math.vec3")

local median_split = {}

local function largest_dimension(data)
    local bounds = {x={},y={},z={}}
    for i = 1, #data do
        for _, dim in pairs({"x", "y", "z"}) do
            local lower = bounds[dim].lower
            local upper = bounds[dim].upper
            local value = data[i][dim]
            if lower == nil or value < lower then
                bounds[dim].lower = value
            end
            if upper == nil or value > upper then
                bounds[dim].upper = value
            end
        end
    end

    local largest_range
    local largest_dim
    for _, dim in pairs({"x", "y", "z"}) do
        local lower = bounds[dim].lower
        local upper = bounds[dim].upper
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
    local count = #box.data
            
    for i = 1, count do
        local color = box.data[i]
        if average == nil then
            average = color
        else
            average = average + color
        end
    end

    average = average / count

    return average
end

local function split_median(box)
    local i = math.floor(#box.data / 2)
    local b1, b2 = fastsplit.split(box.data, i)
    return boundbox(b1), boundbox(b2)
end

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

    local b1, b2 = fastsplit.split(box.data, besti)
    if #b1 == 0 and #b2 > 0 then
        return boundbox(b2), boundbox(b2)
    elseif #b2 == 0 and #b1 > 0 then
        return boundbox(b1), boundbox(b1)
    elseif #b2 == 0 and #b1 == 0 then
    else
        return boundbox(b1), boundbox(b2)
    end
end

local function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

local median_split = {}

function median_split.median_split(image, color_count)
    local color_count = color_count or 16
    local boxes = {}
    table.insert(boxes, boundbox(fastsplit.copy(image.data)))

    for n = 1, color_count - 1 do
        local box = table.remove(boxes, 1)
        local sort_dim = box.dim
        table.sort(box.data, function(a, b) return a[sort_dim] < b[sort_dim] end)
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

function median_split.mean_split(image, color_count)
    local color_count = color_count or 16
    local boxes = {}
    table.insert(boxes, boundbox(fastsplit.copy(image.data)))

    for n = 1, color_count - 1 do
        table.sort(boxes, function(a, b) return #a > #b end)
        local box = table.remove(boxes, 1)
        local sort_dim = box.dim
        table.sort(box.data, function(a, b) return a[sort_dim] < b[sort_dim] end)
        local t1, t2 = split_mean(box)
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