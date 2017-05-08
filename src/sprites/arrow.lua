local P = require('params')
local buttons = require('ui.button')

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

local function getPoints(x, y, side)
    local rot = rotations[side]
    local xlist = {}
    local ylist = {}
    local points = {}
    local b = P.arrowSize
    for _, point in ipairs{{-b/4, b}, {b/2, 0}, {-b/4, -b}} do
        local xp, yp = rot(point[1], point[2], x, y)
        table.insert(xlist, xp)
        table.insert(ylist, yp)
        table.insert(points, xp)
        table.insert(points, yp)
    end
    return xlist, ylist, points
end

--

local Arrow = buttons.Button:subclass('Arrow')

function Arrow:initialize(i, j, side, geom, onClick)
    self.i = i or 1
    self.j = j or 1
    self.side = side or 'top'
    local x, y = geom:dotPos(i, j)
    local xlist, ylist, points = getPoints(x, y, self.side)
    x, y = math.min(unpack(xlist)), math.min(unpack(ylist))
    local width = math.max(unpack(xlist)) - x
    local height = math.max(unpack(ylist)) - y
    Arrow.super.initialize(self, x, y, width, height, onClick)
    self:setBackgroundColor(P.puzzleLineColor)
    self.points = points
    return self
end

function Arrow:getColor()
    local c = self.color
    if self.hovering then
        c = {
            c[1] + (c[1] < 128 and 50 or -50),
            c[2] + (c[2] < 128 and 50 or -50),
            c[3] + (c[3] < 128 and 50 or -50),
            c[4]
        }
    end
    return c
end

function Arrow:draw()
    if not self.visible then return end
    love.graphics.setColor(self:getColor())
    love.graphics.setLineWidth(P.arrowLineWidth)
    love.graphics.line(self.points)
end

function Arrow.top(i, j, geom, dots)
    local arrow = Arrow:new(i, j - 1, 'top', geom)
    local onClick = function()
        for dot in dots:iter() do
            if dot.i == arrow.i then
                dot.j = 1 + (dot.j - 1 - 1) % geom.nY
                dot:startAnim(geom:dotPos(dot.i, dot.j))
            end
        end
    end
    arrow:setOnClick(onClick)
    return arrow
end

function Arrow.bottom(i, j, geom, dots)
    local arrow = Arrow:new(i, j + 1, 'bottom', geom)
    local onClick = function()
        for dot in dots:iter() do
            if dot.i == arrow.i then
                dot.j = 1 + (dot.j + 1 - 1) % geom.nY
                dot:startAnim(geom:dotPos(dot.i, dot.j))
            end
        end
    end
    arrow:setOnClick(onClick)
    return arrow
end


function Arrow.right(i, j, geom, dots)
    local arrow = Arrow:new(i + 1, j, 'right', geom)
    local onClick = function()
        for dot in dots:iter() do
            if dot.j == arrow.j then
                dot.i = 1 + (dot.i + 1 - 1) % geom.nX
                dot:startAnim(geom:dotPos(dot.i, dot.j))
            end
        end
    end
    arrow:setOnClick(onClick)
    return arrow
end

function Arrow.left(i, j, geom, dots)
    local arrow = Arrow:new(i - 1, j, 'left', geom)
    local onClick = function()
        for dot in dots:iter() do
            if dot.j == arrow.j then
                dot.i = 1 + (dot.i - 1 - 1) % geom.nX
                dot:startAnim(geom:dotPos(dot.i, dot.j))
            end
        end
    end
    arrow:setOnClick(onClick)
    return arrow
end


return Arrow
