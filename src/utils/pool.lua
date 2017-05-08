local Base = require('utils.base')


local Pool = Base:subclass('Pool')

function Pool:initialize()
    self.objects = {}
end

function Pool:add(...)
    local arg = {...}
    for _, object in ipairs(arg) do
        table.insert(self.objects, object)
    end
end

function Pool:addkey(object, key)
    table.insert(self.objects, object)
    self.objects[key] = object
end

function Pool:update(dt)
    for _, object in ipairs(self.objects) do
        object:update(dt)
    end
end

function Pool:draw()
    for _, object in ipairs(self.objects) do
        object:draw()
    end
end

function Pool:find(callback)
    for _, object in ipairs(self.objects) do
        if callback(object) then return object end
    end
    return nil
end

function Pool:get(k)
    return self.objects[k]
end

function Pool:iter()
    local i = 0
    return function()
        if i == #self.objects then return nil end
        i = i + 1
        return self.objects[i]
    end
end

function Pool:mousemoved(x, y)
    for _, object in ipairs(self.objects) do
        object:mousemoved(x, y)
    end
end

function Pool:mousepressed(x, y, button)
    for _, object in ipairs(self.objects) do
        object:mousepressed(x, y, button)
    end
end


return Pool
