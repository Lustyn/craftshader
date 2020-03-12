local fastsplit = {}

function fastsplit.slice(t, a, b)
    return {unpack(t, a, b)}
end

function fastsplit.split(t, i)
    return {unpack(t, 1, i)}, {unpack(t, i + 1)}
end

function fastsplit.copy(t)
    return {unpack(t)}
end

return fastsplit