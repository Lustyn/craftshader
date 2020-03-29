local vec2 = require("math.vec2")
local vec3 = require("math.vec3")

local framebuffer = {}

function framebuffer.new(size)
    local self = {}

    self.size = size
    self.data = {}

    return setmetatable(self, {__index = framebuffer})
end

function framebuffer:pos_to_index(pos)
    return math.floor(pos.x) + self.size.x * (math.floor(pos.y) - 1)
end

function framebuffer:set_pixel(self, pos, color)
    self.data[self:pos_to_index(pos)] = color
end

function framebuffer:get_pixel(pos)
    return self.data[self:pos_to_index(pos)]
end

function framebuffer:foreach(func, ...)
    for y = 1, self.size.y do
        for x = 1, self.size.x do
            local pos = vec2(x, y)
            func(pos, self:get_pixel(pos), self, ...)
        end
    end
end

function framebuffer:shade(func, ...)
    self:foreach(function(pos, ...)
        self.data[self:pos_to_index(pos)] = func(pos, ...)
    end, ...)
end

function framebuffer:map(func, ...)
    local results = {}
    self:foreach(function(...)
        results[#results + 1] = func(...)
    end, ...)
    return results
end

function framebuffer:quantize(palette_func, pixel_func)
    local palette = palette_func(self)
    return {
        palette = palette,
        data = self:map(pixel_func, palette),
        size = self.size
    }
end

function framebuffer:clear(color)
    self:shade(function() return color end)
end

function framebuffer:to_p3()
    local output = {}

    table.insert(output, "P3\n")
    table.insert(output, self.size.x .. " " .. self.size.y .. "\n")
    table.insert(output, "255\n")

    self:foreach(function(pos, c)
        table.insert(output, math.floor(c.x * 255) .. " " .. math.floor(c.y * 255) .. " " .. math.floor(c.z * 255) .. "\n")
    end)
    
    return table.concat(output)
end

return framebuffer