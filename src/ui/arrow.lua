local class = require('utils.class')
local P = require('params')
-- local Button = require('ui.button')

-- Utility functions

local rotations = {}
for k, v in pairs{right=0, bottom=1, left=2, top=3} do
    local angle = v * math.pi/2
    local c, s = math.cos(angle), math.sin(angle)
    rotations[k] = function(x, y, dx, dy)
        dx = dx or 0
        dy = dy or 0
        return dx + c*x - s*y, dy + s*x + c*y
    end
end

--

local Arrow = class()

function Arrow.new(x, y, i, j, side)
    local self = setmetatable({}, Arrow)
    self.side = side or 'top'
    local rot = rotations[self.side]
    local b = P.arrowSize
    local x1, y1 = rot(-b/4, b, x, y)
    local x2, y2 = rot(b/2, 0, x, y)
    local x3, y3 = rot(-b/4, -b, x, y)
    self.i, self.j = i, j
    self.x = math.min(x1, x2, x3)
    self.y = math.min(y1, y2, y3)
    self.width = math.max(x1, x2, x3) - self.x
    self.height = math.max(y1, y2, y3) - self.y
    self.points = {x1, y1, x2, y2, x3, y3}
    self.clicked = false
    self.hovering = false
    return self
end

function Arrow:hover(x, y)
    self.hovering = self:isHovering(x, y)
end

function Arrow:update(_) end

function Arrow:draw()
    local c = P.puzzleLineColor
    if self.clicked or self.hovering then
        c = {c[1] - 20, c[2] - 20, c[3] - 20, c[4]}
    end
    love.graphics.setColor(c)
    love.graphics.setLineWidth(P.arrowLineWidth)
    love.graphics.line(self.points)
end

function Arrow:isHovering(x, y)
    return (x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height)
end

function Arrow:isHorizontal()
    return self.side == 'left' or self.side == 'right'
end

function Arrow:isVertical()
    return self.side == 'top' or self.side == 'bottom'
end

return Arrow
