local vec2 = require("math.vec2")
local framebuffer = require("render.framebuffer")
local shaders = {
    uv = require("shaders.uv"),
    hsv = require("shaders.hsv"),
    colorwheel = require("shaders.colorwheel")
}
local median_split = require("quantization.median_split")
local quantizers = {
    median_split = median_split.median_split,
    mean_split = median_split.mean_split
}
local color_distance = require("quantization.color_distance")

local function filename(shader)
    return "images/" .. shader .. ".ppm"
end

local function write_buffer_to_file(name, buffer)
    local path = filename(name)
    local f = fs.open(path, "w")
    f.write(buffer:to_p3())
    f.close()
    print("Wrote " .. name .. " to " .. path)
end

local size = vec2(128, 128)

for shader_name, shader_func in pairs(shaders) do
    local buf = framebuffer.new(size)
    buf:shade(shader_func)

    write_buffer_to_file(shader_name, buf)

    for quant_name, quant_func in pairs(quantizers) do
        local image = buf:quantize(quant_func, color_distance.rgb)
        local qbuf = framebuffer.new(size)
    
        for i = 1, #image.data do
            qbuf.data[i] = image.palette[image.data[i]]
        end

        write_buffer_to_file(shader_name .. "-" .. quant_name, qbuf)
    end
end