local Pool = require('utils.pool')

local containers = {}

local LinearLayout = Pool:subclass('LinearLayout')
local VERTICAL = 0
local HORIZONTAL = 1

function LinearLayout:initialize()
    LinearLayout.super.initialize(self)
    self.orientation = VERTICAL
end

function LinearLayout:add(...)
    local last = self.objects[#self.objects]
    for _, object in ipairs({...}) do
        LinearLayout.super.add(self, object)
        local dx, dy = 0, 0
        if last then  -- add padding
            dx, dy = self:getDisp(last)
            dx = dx + self:getPadX()
            dy = dy + self:getPadY()
        end
        object.x = object.x + dx
        object.y = object.y + dy
    end
end

function LinearLayout:setOrientation(orientation)
    if orientation == 'vertical' then self.orientation = VERTICAL
    elseif orientation == 'horizontal' then self.orientation = HORIZONTAL
    else error('Unknown orientation: ' .. orientation) end
end

function LinearLayout:setPadding(pad)
    self.pad = pad
end

function LinearLayout:getPadX()
    return self.orientation == HORIZONTAL and self.pad or 0
end

function LinearLayout:getPadY()
    return self.orientation == VERTICAL and self.pad or 0
end

function LinearLayout:getDisp(object)
    if self.orientation == HORIZONTAL then return object:getWidth(), 0
    else return 0, object:getHeight() end
end

containers.LinearLayout = LinearLayout

return containers
