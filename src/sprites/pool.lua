local function Pool()
    local pool = {}
    function pool:add(object, key)
        table.insert(pool, object)
        if key then pool[key] = object end
    end
    function pool:update(dt)
        for _, object in ipairs(pool) do
            object:update(dt)
        end
    end
    function pool:draw()
        for _, object in ipairs(pool) do
            object:draw()
        end
    end
    function pool:find(callback)
        for _, object in ipairs(pool) do
            if callback(object) then return object end
        end
        return nil
    end
    return pool
end

return Pool
