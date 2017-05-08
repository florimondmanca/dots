local P = require('params')
local Puzzle = require('puzzle')
local Pool = require('sprites.pool')
local B = require('ui.button')
math.randomseed(os.time())

local puzzle
local buttons = Pool()
local level = 1

function love.load()
	love.graphics.setBackgroundColor(P.backgroundColor)
    puzzle = Puzzle.fromlevel(level)
    local b = B.TextButton('Quit', 30, 30)
    b:setBackgroundColor('none')
    b:setOnClick(function() love.event.quit() end)
    buttons:add(b)
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
