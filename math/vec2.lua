local umath = require("math.umath")
local vec2 = {}
vec2.__index = vec2

function vec2.is(obj)
    return getmetatable(obj) == vec2
end

function vec2.new(x, y)
    return setmetatable({
        x = x or 0,
        y = y or 0
    }, vec2)
end

--[[
    if type(this) == "number" and vec2.is(that) then
        return vec2.new(this SIGN that.x, this SIGN that.y)
    elseif type(that) == "number" and vec2.is(this) then
        return vec2.new(this.x SIGN that, this.y SIGN that)
    else
        return vec2.new(this.x SIGN that.x, this.y SIGN that.y)
    end
]]

function vec2.__add(this, that)
    if type(this) == "number" and vec2.is(that) then
        return vec2.new(this + that.x, this + that.y)
    elseif type(that) == "number" and vec2.is(this) then
        return vec2.new(this.x + that, this.y + that)
    else
        return vec2.new(this.x + that.x, this.y + that.y)
    end
end

function vec2.__sub(this, that)
    if type(this) == "number" and vec2.is(that) then
        return vec2.new(this - that.x, this - that.y)
    elseif type(that) == "number" and vec2.is(this) then
        return vec2.new(this.x - that, this.y - that)
    else
        return vec2.new(this.x - that.x, this.y - that.y)
    end
end

function vec2.__mul(this, that)
    if type(this) == "number" and vec2.is(that) then
        return vec2.new(this * that.x, this * that.y)
    elseif type(that) == "number" and vec2.is(this) then
        return vec2.new(this.x * that, this.y * that)
    else
        return vec2.new(this.x * that.x, this.y * that.y)
    end
end

function vec2.__div(this, that)
    if type(this) == "number" and vec2.is(that) then
        return vec2.new(this / that.x, this / that.y)
    elseif type(that) == "number" and vec2.is(this) then
        return vec2.new(this.x / that, this.y / that)
    else
        return vec2.new(this.x / that.x, this.y / that.y)
    end
end

function vec2.__mod(this, that)
    if type(this) == "number" and vec2.is(that) then
        return vec2.new(this % that.x, this % that.y)
    elseif type(that) == "number" and vec2.is(this) then
        return vec2.new(this.x % that, this.y % that)
    else
        return vec2.new(this.x % that.x, this.y % that.y)
    end
end

function vec2.__eq(this, that)
    return this.x == that.x and this.y == that.y
end

function vec2.clamp(this, min, max)
    return vec2.new(umath.clamp(this.x, min, max), umath.clamp(this.y, min, max))
end

function vec2.abs(this)
    return vec2.new(math.abs(this.x), math.abs(this.y))
end

function vec2.lerp(this, that, alpha)
    return vec2.new(umath.lerp(this.x, that.x, alpha), umath.lerp(this.y, that.y, alpha))
end

function vec2.length(this)
    return math.sqrt(this.x^2 + this.y^2)
end

function vec2.distance(this, that)
    return math.sqrt((that.x - this.x)^2 + (that.y - this.y)^2)
end

function vec2.unpack(this)
    return this.x, this.y
end

function vec2.clone(this)
    return vec2.new(this.x, this.y)
end


return setmetatable(vec2, {__call = function(_, ...) return vec2.new(...) end})