local function class(supercls)
    local cls = {}
    cls.__index = cls
    setmetatable(cls, {__call = function(_, ...)
        local newinst = {}
        setmetatable(newinst, {__index=cls})
        return newinst.new(...)
    end,})
    if supercls then
        setmetatable(cls, {__index=supercls})
    end
    return cls
end

return class
