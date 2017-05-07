local P = require('params')
local Puzzle = require('puzzle')
math.randomseed(os.time())

local puzzle
-- local buttons = {}
local level = 1

function love.load()
	love.graphics.setBackgroundColor(P.backgroundColor)
    puzzle = Puzzle.fromlevel(level)
end

function love.update(dt)
    puzzle:update(dt)
    -- if puzzle:isFinished() then
    --     level = level + 1
    --     puzzle = Puzzle.fromlevel(level)
    -- end
end

function love.draw()
    puzzle:draw()
end

function love.keypressed(key, _, _)
    if key == 'escape' then love.event.quit() end
end

function love.mousemoved(x, y, dx, dy)
    puzzle:mousemoved(x, y, dx, dy)
end

function love.mousepressed(x, y, button, _)
    puzzle:mousepressed(x, y, button)
end
