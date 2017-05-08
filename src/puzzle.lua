local class = require('utils.class')
local P = require('params')
local Dot = require('sprites.dot')
local Arrow = require('sprites.arrow')
local Rectangle = require('sprites.rectangle')
local Pool = require('utils.pool')
local GameState = require('utils.state')
local C = require('ui.containers')
local B = require('ui.button')


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


local Puzzle = GameState:subclass('Puzzle')

function Puzzle:initialize(nX, nY)
    self.moving = false
    self.geom = Geom:new(nX, nY)
    self.dots = Pool:new()
    self.arrows = Pool:new()
    self.shapes = Pool:new()
    self.buttons = C.LinearLayout()
    self.buttons:setOrientation('horizontal')
    self.buttons:setPadding(10)
end


function Puzzle:load()
    love.graphics.setBackgroundColor(P.backgroundColor)
    -- create buttons
    local x, y = 30, love.graphics.getHeight() - 60
    local foo = B.TextButton('Menu', x, y)
    foo:setOnClick(function() print('Foo! Foo! Foo! ...') end)
    foo:setPadding(5)
    local quit = B.TextButton('Quit', x, y)
    quit:setOnClick(function() love.event.quit() end)
    quit:setPadding(5)
    self.buttons:add(foo)
    self.buttons:add(quit)
    for b in self.buttons:iter() do
        b:setBackgroundColor('none')
        b:addBorder(2)
    end
    -- create dots
    for i = 1, self.geom.nX do for j = 1, self.geom.nY do
        self.dots:add(Dot:new(i, j, self.geom:dotPos(i, j)))
    end end
    -- create arrow buttons
    for i = 1, self.geom.nX do
        self.arrows:add(Arrow.top(i, 1, self.geom, self.dots))
        self.arrows:add(Arrow.bottom(i, self.geom.nY, self.geom, self.dots))
    end
    for j = 1, self.geom.nY do
        self.arrows:add(Arrow.right(self.geom.nX, j, self.geom, self.dots))
        self.arrows:add(Arrow.left(1, j, self.geom, self.dots))
    end
    -- create shapes
    self.shapes = Pool:new()
end


function Puzzle:update(dt)
    self.dots:update(dt)
    self.buttons:update(dt)
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
    self.buttons:draw()
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


function Puzzle:mousemoved(x, y, _, _)
    for arrow in self.arrows:iter() do
        arrow:mousemoved(x, y)
    end
    for button in self.buttons:iter() do
        button:mousemoved(x, y)
    end
end


function Puzzle:mousepressed(x, y, button)
    if button == 1 then
        for arrow in self.arrows:iter() do
            arrow:mousepressed(x, y, button)
        end
        for b in self.buttons:iter() do
            b:mousepressed(x, y, button)
        end
    end
end


-- utility functions

function Puzzle:findDot(i, j)
    return self.dots:find(function(dot) return dot.i == i and dot.j == j end)
end

function Puzzle:isFinished()
    return self.shapes:get('mobile') == self.shapes:get('fixed')
end


-- to load a puzzle from a level file

function Puzzle.fromlevel(levelname)
    local data = require('levels.' .. levelname)
    -- create a generic puzzle
    local puzzle = Puzzle:new(data.nX, data.nY)
    -- insert the mobile and fixed shapes specific to the level
    local function getRect(kind)
        local dots = {}
        for _, dotCoords in ipairs(data[kind]) do
            local i, j = unpack(dotCoords)
            local dot = puzzle:findDot(i, j)
            table.insert(dots, dot)
        end
        return unpack(dots)
    end
    function puzzle:load()
        Puzzle.load(self)
        self.shapes:add(Rectangle.fixed(getRect('fixed')), 'fixed')
        self.shapes:add(Rectangle:new(getRect('mobile')), 'mobile')
    end

    return puzzle
end

return Puzzle
