local vec2 = require("math.vec2")
local vec3 = require("math.vec3")
local framebuffer = require("render.framebuffer")
local draw = require("render.draw")
local uv_shader = require("shaders.uv")
local median_split = require("quantization.median_split")
local color_distance = require("quantization.color_distance")

-- Get the term's size
local tw, th = term.getSize()
-- Create the size as a vec2 rect
local term_size = vec2(tw, th)
-- Create a new framebuffer
local buf = framebuffer.new(term_size)
-- Shade the framebuffer with RGB(U, V, 1)
buf:shade(uv_shader)
-- Save the framebuffer to a ppm file (good for testing shader accuracy without dealing with quantization artifacts)
local f = fs.open("test.ppm", "w")
f.write(buf:to_p3())
f.close()
-- Quantize the buffer (this returns an image with a 1d array of indexed colors and a palette)
local image = buf:quantize(median_split, color_distance.rgb)
-- Draw this image to the screen
draw.draw_image(image)
os.pullEvent("terminate")
draw.default_palette()