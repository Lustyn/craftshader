local umath = require("math.umath")
local vec3 = {}
vec3.__index = vec3

function vec3.is(obj)
    return getmetatable(obj) == vec3
end

function vec3.new(x, y, z)
    return setmetatable({
        x = x or 0,
        y = y or 0,
        z = z or 0
    }, vec3)
end

function vec3.__tostring(this)
    return "(" .. this.x .. ", " .. this.y .. ", " .. this.z ..")"
end

--[[
    if type(this) == "number" and vec3.is(that) then
        return vec3.new(this SIGN that.x, this SIGN that.y, this SIGN that.z)
    elseif type(that) == "number" and vec3.is(this) then
        return vec3.new(this.x SIGN that, this.y SIGN that, this.z SIGN that)
    else
        return vec3.new(this.x SIGN that.x, this.y SIGN that.y, this SIGN that.z)
    end
]]

function vec3.__add(this, that)
    if type(this) == "number" and vec3.is(that) then
        return vec3.new(this + that.x, this + that.y, this + that.z)
    elseif type(that) == "number" and vec3.is(this) then
        return vec3.new(this.x + that, this.y + that, this.z + that)
    else
        return vec3.new(this.x + that.x, this.y + that.y, this.z + that.z)
    end
end

function vec3.__sub(this, that)
    if type(this) == "number" and vec3.is(that) then
        return vec3.new(this - that.x, this - that.y, this - that.z)
    elseif type(that) == "number" and vec3.is(this) then
        return vec3.new(this.x - that, this.y - that, this.z - that)
    else
        return vec3.new(this.x - that.x, this.y - that.y, this.z - that.z)
    end
end

function vec3.__mul(this, that)
    if type(this) == "number" and vec3.is(that) then
        return vec3.new(this * that.x, this * that.y, this * that.z)
    elseif type(that) == "number" and vec3.is(this) then
        return vec3.new(this.x * that, this.y * that, this.z * that)
    else
        return vec3.new(this.x * that.x, this.y * that.y, this.z * that.z)
    end
end

function vec3.__div(this, that)
    if type(this) == "number" and vec3.is(that) then
        return vec3.new(this / that.x, this / that.y, this / that.z)
    elseif type(that) == "number" and vec3.is(this) then
        return vec3.new(this.x / that, this.y / that, this.z / that)
    else
        return vec3.new(this.x / that.x, this.y / that.y, this.z / that.z)
    end
end

function vec3.__mod(this, that)
    if type(this) == "number" then
        return vec3.new(this % that.x, this % that.y, this % that.z)
    elseif type(that) == "number" then
        return vec3.new(this.x % that, this.y % that, this.z % that)
    else
        return vec3.new(this.x % that.x, this.y % that.y, this.z % that.z)
    end
end

function vec3.__eq(this, that)
    return this.x == that.x and this.y == that.y and this.z == that.z
end

function vec3.clamp(this, min, max)
    return vec3.new(umath.clamp(this.x, min, max), umath.clamp(this.y, min, max), umath.clamp(this.z, min, max))
end

function vec3.abs(this)
    return vec3.new(math.abs(this.x), math.abs(this.y), math.abs(this.z))
end

function vec3.lerp(this, that, alpha)
    return vec3.new(umath.lerp(this.x, that.x, alpha), umath.lerp(this.y, that.y, alpha), umath.lerp(this.z, that.z, alpha))
end

function vec3.length(this)
    return math.sqrt(this.x^2 + this.y^2 + this.z^2)
end

function vec3.distance(this, that)
    local x = (that.x - this.x)^2
    local y = (that.y - this.y)^2
    local z = (that.z - this.z)^2
    return math.sqrt(x + y + z)
end

function vec3.unpack(this)
    return this.x, this.y, this.z
end

function vec3.clone(this)
    return vec3.new(this.x, this.y, this.z)
end

return setmetatable(vec3, {__call = function(_, ...) return vec3.new(...) end})