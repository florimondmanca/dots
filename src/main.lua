local P = require('params')
local Puzzle = require('puzzle')
local B = require('ui.button')
local C = require('ui.containers')
math.randomseed(os.time())

local puzzle
local buttons = C.LinearLayout()
buttons:setOrientation('horizontal')
buttons:setPadding(10)
local level = 1

function love.load()
	love.graphics.setBackgroundColor(P.backgroundColor)
    puzzle = Puzzle.fromlevel(level)
    -- load buttons
    local x, y = 30, love.graphics.getHeight() - 60
    local foo = B.TextButton('Menu', x, y)
    foo:setOnClick(function() print('Foo! Foo! Foo! ...') end)
    foo:setPadding(5)
    local quit = B.TextButton('Quit', x, y)
    quit:setOnClick(function() love.event.quit() end)
    quit:setPadding(5)
    buttons:add(foo)
    buttons:add(quit)
    for b in buttons:iter() do
        b:setBackgroundColor('none')
        b:addBorder(2)
    end
end

function love.update(dt)
    puzzle:update(dt)
    if puzzle:isFinished() then
        level = level + 1
        puzzle = Puzzle.fromlevel(level)
    end
    buttons:update(dt)
end

function love.draw()
    puzzle:draw()
    buttons:draw()
end

function love.keypressed(key, _, _)
    if key == 'escape' then love.event.quit() end
end

function love.mousemoved(x, y, dx, dy)
    puzzle:mousemoved(x, y, dx, dy)
    for button in buttons:iter() do
        button:mousemoved(x, y)
    end
end

function love.mousepressed(x, y, button, _)
    puzzle:mousepressed(x, y, button)
    for b in buttons:iter() do
        b:mousepressed(x, y, button)
    end
end
