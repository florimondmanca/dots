local class = require('utils.class')

local Button = class()

function Button.new(text, x, y, width, height, onClick)
    local self = setmetatable({}, Button)
    self.text = text
    self.x, self.y = x, y
    self.width = width
    self.height = height
    self.onClick = onClick
    self.hovering = false
    return self
end

function Button:setOnClick(callback)
    self.onClick = callback
end

function Button:isHovering(x, y)
    return (x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height)
end

function Button:mousemoved(x, y)
    self.hovering = self:isHovering(x, y)
end

function Button:mousepressed(x, y, button)
    if button == 1 and self.onClick then
        self.onClick(x, y)
    end
end
