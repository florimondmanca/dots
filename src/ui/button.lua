local class = require('utils.class')

local Button = class('Button')

function Button:initialize(x, y, width, height, onClick, options)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 0
    self.height = height or 0
    self.onClick = onClick or function() end
    self.hovering = false
    options = options or {}
    self.color = options.color or {0, 0, 0, 255}
    return self
end

function Button:draw() end

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
    if button == 1 and self.onClick and self.hovering then
        self.onClick(x, y)
    end
end

return Button
