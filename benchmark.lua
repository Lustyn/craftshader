local vec2 = require("math.vec2")
local vec3 = require("math.vec3")
local framebuffer = require("render.framebuffer")
local draw = require("render.draw")
local colorwheel_shader = require("shaders.colorwheel")
local median_split = require("quantization.median_split")
local color_distance = require("quantization.color_distance")

local tw, th = term.getSize()
local term_area = tw * th
local term_size = vec2(tw, th)
local shade_start = os.epoch("utc")
local buf = framebuffer.new(term_size)
buf:shade(colorwheel_shader)
local shade_end = os.epoch("utc")
local quant_start = os.epoch("utc")
local image = buf:quantize(median_split, color_distance.rgb)
local quant_end = os.epoch("utc")
local draw_start = os.epoch("utc")
print("what?")
term.clear()
print("?????")
term.setCursorPos(1,1)
print("wtf??")
draw.draw_image(image)
local draw_end = os.epoch("utc")
draw.default_palette()
term.clear()
term.setCursorPos(1,1)
local shade_time = shade_end - shade_start
local quant_time = quant_end - quant_start
local draw_time = draw_end - draw_start
local total_time = shade_time + quant_time + draw_time
print("shade time: " .. shade_time .. " ms")
print("shade p/s: " .. ((term_area * 1000) / (shade_time * 1000)) * 1000)
print("quant time: " .. quant_time .. " ms")
local quantps = ((term_area * 1000) / (quant_time * 1000)) * 1000
    print(quant_time)
    print(term_area)
print("quant p/s: " .. quantps)
print("draw time: " .. draw_time .. " ms")
print("draw p/s: " ..  ((term_area * 1000) / (draw_time * 1000)) * 1000)
print("total: " .. total_time .. " ms")
print("fps: " .. 1000 / total_time)