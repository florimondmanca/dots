local class = require('utils.class')
local P = require('params')
local Dot = require('sprites.dot')
local Arrow = require('ui.arrow')
local Rectangle = require('sprites.rectangle')
local Pool = require('sprites.pool')

local Puzzle = class()

function Puzzle.new(nX, nY)
    local puzzle = {}
    nX = nX or 0
    nY = nY or 0
    local moving = false
    -- compute geometry
    local geom = {}
    geom.a = P.puzzleA  -- space between dots
    geom.left = (love.graphics.getWidth() - (nX - 1) * geom.a)/2
    geom.right = love.graphics.getWidth() - geom.left
    geom.top = (love.graphics.getHeight() - (nY - 1) * geom.a)/2
    geom.bottom = love.graphics.getHeight() - geom.top
    geom.width = geom.right - geom.left
    geom.height = geom.bottom - geom.top

    -- utility geometry methods
    local dotX = function(i) return geom.left + (i-1) * P.puzzleA end
    local dotY = function(j) return geom.top + (j-1) * P.puzzleA end
    local dotPos = function(i, j) return dotX(i), dotY(j) end

    -- create dots
    local dots = Pool()
    for i = 1, nX do for j = 1, nY do
        dots:add(Dot(i, j, dotPos(i, j)))
    end end

    function puzzle:findDot(i, j)
        return dots:find(function(dot) return dot.i == i and dot.j == j end)
    end
    -- create arrow controllers
    local arrows = Pool()
    for i = 1, nX do
        arrows:add(Arrow(dotX(i), geom.top - geom.a, i, 1, 'top'))
        arrows:add(Arrow(dotX(i), geom.bottom + geom.a, i, nY, 'bottom'))
    end
    for j = 1, nY do
        arrows:add(Arrow(geom.left - geom.a, dotY(j), 1, j, 'left'))
        arrows:add(Arrow(geom.right + geom.a, dotY(j), nX, j, 'right'))
    end
    local shapes = Pool()

    function puzzle:setShapes(fixed, mobile)
        shapes:add(fixed, 'fixed')
        shapes:add(mobile, 'mobile')
    end

    -- define methods

    function puzzle:update(dt)
        dots:update(dt)
        arrows:update(dt)
        if moving then
            local anyMoving = false
            for _, dot in ipairs(dots) do
                if dot:isMoving() then anyMoving = true end
            end
            if not anyMoving then moving = false end
        end
    end

    function puzzle:draw()
        love.graphics.setLineJoin('bevel')
        dots:draw()
        arrows:draw()
        shapes:draw()
        -- enclosing rectangle
        love.graphics.setColor(P.puzzleLineColor)
        love.graphics.setLineWidth(P.puzzleLineWidth)
        love.graphics.rectangle('line',
            geom.left - geom.a/2, -- x
            geom.top - geom.a/2, -- y
            geom.width + geom.a, -- width
            geom.height + geom.a -- height
        )
    end

    -- react to events

    local axisDir = {
        right={'h', 1}, left={'h', -1}, top={'v', -1}, bottom={'v', 1}
    }
    function puzzle:move(arrow)
        if not moving then moving = true else return end
        local axis, direction = unpack(axisDir[arrow.side])
        local anim = {}
        for _, dot in ipairs(dots) do
            local insert = false
            if axis == 'h' and dot.j == arrow.j then
                dot.i = 1 + (dot.i + direction - 1) % nX
                insert = true
            elseif axis == 'v' and dot.i == arrow.i then
                dot.j = 1 + (dot.j + direction - 1) % nY
                insert = true
            end
            if insert then table.insert(anim, dot) end
        end
        for _, dot in ipairs(anim) do
            dot:startAnim(dotX(dot.i), dotY(dot.j))
        end
    end

    function puzzle:isFinished()
        return shapes.mobile:sameAs(shapes.fixed)
    end

    function puzzle:mousemoved(x, y, _, _)
        for _, arrow in ipairs(arrows) do
            arrow:hover(x, y)
        end
    end

    function puzzle:mousepressed(_, _, button)
        if button == 1 then
            for _, arrow in ipairs(arrows) do
                if arrow.hovering then
                    puzzle:move(arrow)
                end
            end
        end
    end

    return puzzle
end

function Puzzle.fromlevel(levelname)
    local data = require('levels.' .. levelname)
    -- create a generic puzzle
    local puzzle = Puzzle(data.nX, data.nY)
    -- insert the mobile and fixed shapes specific to the level
    local mobileDots = {}
    for _, dotCoords in ipairs(data.mobile) do
        local i, j = unpack(dotCoords)
        table.insert(mobileDots, puzzle:findDot(i, j))
    end
    local fixedDots = {}
    for _, dotCoords in ipairs(data.fixed) do
        local i, j = unpack(dotCoords)
        table.insert(fixedDots, puzzle:findDot(i, j))
    end
    local mobile = Rectangle('mobile', unpack(mobileDots))
    local fixed = Rectangle('fixed', unpack(fixedDots))
    puzzle:setShapes(fixed, mobile)

    return puzzle
end

return Puzzle
