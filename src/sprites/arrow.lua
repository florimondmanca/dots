local class = require('utils.class')
local P = require('params')
local Button = require('ui.button')

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
    for _, point in ipairs{{0, 0}, {3*P.arrowSize/4, 0}, {0, 2*P.arrowSize}} do
        local xp, yp = rot(point[1], point[2], x, y)
        table.insert(xlist, xp)
        table.insert(ylist, yp)
        table.insert(points, xp)
        table.insert(points, yp)
    end
    return xlist, ylist, points
end

--

local Arrow = class('Arrow', Button)

function Arrow:initialize(i, j, side, geom, onClick)
    self.i = i or 1
    self.j = j or 1
    self.side = side or 'top'
    local x, y = geom:dotPos(i, j)
    local xlist, ylist, points = getPoints(x, y, self.side)
    Button.initialize(self,
        math.min(unpack(xlist)), math.max(unpack(ylist)),
        math.max(unpack(xlist)) - x, math.max(unpack(ylist)) - y, onClick
    )
    self.points = points
    return self
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

function Arrow.top(i, j, geom, dots)
    local arrow = Arrow:new(i, j, 'top', geom)
    local onClick = function()
        for _, dot in ipairs(dots) do
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
    local arrow = Arrow:new(i, j, 'bottom', geom)
    local onClick = function()
        for _, dot in ipairs(dots) do
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
    local arrow = Arrow:new(i, j, 'right', geom)
    local onClick = function()
        for _, dot in ipairs(dots) do
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
    local arrow = Arrow:new(i, j, 'left', geom)
    local onClick = function()
        for _, dot in ipairs(dots) do
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
