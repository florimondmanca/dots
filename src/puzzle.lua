local class = require('utils.class')
local P = require('params')
local Dot = require('sprites.dot')
local Arrow = require('sprites.arrow')
local Rectangle = require('sprites.rectangle')
local Pool = require('sprites.pool')


local Geom = class('Geom')

function Geom:initialize(nX, nY)
    self.nX = nX or 0
    self.nY = nY or 0
    self.a = P.puzzleA
    self.left = (love.graphics.getWidth() - (self.nX - 1) * self.a)/2
    self.right = love.graphics.getWidth() - self.left
    self.top = (love.graphics.getHeight() - (self.nY - 1) * self.a)/2
    self.bottom = love.graphics.getHeight() - self.top
    self.width = self.right - self.left
    self.height = self.bottom - self.top
end

function Geom:dotX(i) return self.left + (i-1) * self.a end
function Geom:dotY(j) return self.top + (j-1) * self.a end
function Geom:dotPos(i, j) return self:dotX(i), self:dotY(j) end


local Puzzle = class('Puzzle')

function Puzzle:initialize(nX, nY)
    self.moving = false
    self.geom = Geom:new(nX, nY)

    -- create dots
    self.dots = Pool:new()
    for i = 1, self.geom.nX do for j = 1, self.geom.nY do
        self.dots:add(Dot:new(i, j, self.geom:dotPos(i, j)))
    end end

    -- create arrow controllers
    self.arrows = Pool:new()
    for i = 1, nX do
        self.arrows:add(Arrow.top(i, 1, self.geom, self.dots))
        self.arrows:add(Arrow.bottom(i, nY, self.geom, self.dots))
    end
    for j = 1, nY do
        self.arrows:add(Arrow.right(nX, j, self.geom, self.dots))
        self.arrows:add(Arrow.left(1, j, self.geom, self.dots))
    end

    -- create shapes
    self.shapes = Pool:new()
end


function Puzzle:findDot(i, j)
    return self.dots:find(function(dot) return dot.i == i and dot.j == j end)
end


function Puzzle:update(dt)
    self.dots:update(dt)
    -- self.arrows:update(dt)
    if self.moving then
        local anyMoving = false
        for dot in self.dots:iter() do
            if dot:isMoving() then anyMoving = true end
        end
        if not anyMoving then self.moving = false end
    end
end


function Puzzle:draw()
    love.graphics.setLineJoin('bevel')
    self.dots:draw()
    self.arrows:draw()
    self.shapes:draw()
    -- enclosing rectangle
    love.graphics.setColor(P.puzzleLineColor)
    love.graphics.setLineWidth(P.puzzleLineWidth)
    love.graphics.rectangle('line',
        self.geom.left - self.geom.a/2, -- x
        self.geom.top - self.geom.a/2, -- y
        self.geom.width + self.geom.a, -- width
        self.geom.height + self.geom.a -- height
    )
end


function Puzzle:isFinished()
    return self.shapes:get('mobile') == self.shapes:get('fixed')
end


function Puzzle:mousemoved(x, y, _, _)
    for arrow in self.arrows:iter() do
        arrow:mousemoved(x, y)
    end
end

function Puzzle:mousepressed(x, y, button)
    if button == 1 then
        for arrow in self.arrows:iter() do
            arrow:mousepressed(x, y, button)
        end
    end
end


function Puzzle.fromlevel(levelname)
    local data = require('levels.' .. levelname)
    -- create a generic puzzle
    local puzzle = Puzzle:new(data.nX, data.nY)
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
    local mobile = Rectangle:new(unpack(mobileDots))
    local fixed = Rectangle.fixed(unpack(fixedDots))
    puzzle.shapes:add(fixed, 'fixed')
    puzzle.shapes:add(mobile, 'mobile')

    return puzzle
end

return Puzzle
