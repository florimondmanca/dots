local P = require('params')
local class = require('utils.class')

local Rectangle = class()


function Rectangle.new(mode, dot1, dot2, dot3, dot4)
    assert(mode == 'fixed' or mode == 'mobile', 'Unknown mode: ' .. mode)
    local rectangle = {}
    local anchors = {dot1, dot2, dot3, dot4}
    local color = P.rectangleColor
    if mode == 'fixed' then
        color = {color[1] - 50, color[2] - 50, color[3], color[4]}
        local fixedAnchors = {}
        for _, dot in ipairs(anchors) do
            table.insert(fixedAnchors, {x=dot.x, y=dot.y, i=dot.i, j=dot.j})
        end
        anchors = fixedAnchors
    end

    function rectangle:anchors()
        return anchors
    end

    function rectangle:draw()
        local points = {}
        for _, dot in ipairs(anchors) do
            table.insert(points, dot.x)
            table.insert(points, dot.y)
        end
        -- close rectangle
        table.insert(points, anchors[1].x)
        table.insert(points, anchors[1].y)
        love.graphics.setColor(color)
        love.graphics.setLineWidth(P.rectangleLineWidth)
        love.graphics.line(points)
    end

    function rectangle:sameAs(other)
        local eq = true
        local otherAnchors = other:anchors()
        for i = 1, 4 do
            local a = anchors[i]
            local exists = false
            for j = 1, 4 do
                local oa = otherAnchors[j]
                if a.i == oa.i and a.j == oa.j then exists = true end
            end
            if not exists then eq = false end
        end
        return eq
    end

    -- setmetatable(rectangle, {__tostring = function(self)
    --     local coords = {}
    --     for _, dot in ipairs(anchors) do
    --         table.insert(coords, '(' .. dot.i .. ', ' .. dot.j .. ')')
    --     end
    --     return 'Rect<' .. table.concat(coords, ', ') .. '>'
    -- end})

    return rectangle
end

return Rectangle
