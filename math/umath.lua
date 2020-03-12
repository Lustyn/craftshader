local umath = {}

function umath.clamp(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    else
        return value
    end
end

function umath.lerp(x, y, a)
    return x * (1 - a) + y * a
end

return umath