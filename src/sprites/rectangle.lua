local P = require('params')
local class = require('utils.class')

local Rectangle = class('Rectangle')


function Rectangle:initialize(dot1, dot2, dot3, dot4)
    self.anchors = {dot1, dot2, dot3, dot4}
    self.color = P.rectangleColor
end

function Rectangle:draw()
    local points = {}
    for _, dot in ipairs(self.anchors) do
        table.insert(points, dot.x)
        table.insert(points, dot.y)
    end
    -- close rectangle
    table.insert(points, self.anchors[1].x)
    table.insert(points, self.anchors[1].y)
    love.graphics.setColor(self.color)
    love.graphics.setLineWidth(P.rectangleLineWidth)
    love.graphics.line(points)
end

function Rectangle:__eq(other)
    local eq = true
    for i = 1, 4 do
        local a = self.anchors[i]
        local exists = false
        for j = 1, 4 do
            local oa = other.anchors[j]
            if a.i == oa.i and a.j == oa.j then exists = true end
        end
        if not exists then eq = false end
    end
    return eq
end

function Rectangle:__tostring()
    local coords = {}
    for _, dot in ipairs(self.anchors) do
        table.insert(coords, '(' .. dot.i .. ', ' .. dot.j .. ')')
    end
    return 'Rect<' .. table.concat(coords, ', ') .. '>'
end


function Rectangle.fixed(dot1, dot2, dot3, dot4)
    local rectangle = Rectangle:new(dot1, dot2, dot3, dot4)
    local color = {rectangle.color[1] - 50, rectangle.color[2] - 50, rectangle.color[3], rectangle.color[4]}
    rectangle.color = color
    -- replace the anchors by fixed tables
    local fixedAnchors = {}
    for _, dot in ipairs(rectangle.anchors) do
        table.insert(fixedAnchors, {x=dot.x, y=dot.y, i=dot.i, j=dot.j})
    end
    rectangle.anchors = fixedAnchors
    return rectangle
end


return Rectangle
