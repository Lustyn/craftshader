local utils = {}

function utils.map(func, array)
    local new_array = {}
    for _, v in pairs(array) do
      table.insert(new_array, func(v))
    end
    return new_array
end

return utils