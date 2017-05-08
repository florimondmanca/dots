local Puzzle = require('puzzle')
local Menu = require('menu')
math.randomseed(os.time())

local level
local state


function love.load()
    level = 1
    -- state = Puzzle.fromlevel(level)
    state = Menu()
    state:load()
end

local function nextLevel()
    print('Finished!')
    -- level = level + 1
    -- puzzle = Puzzle.fromlevel(level)
end

function love.update(dt)
    state:update(dt)
    if state:isFinished() then
        nextLevel()
    end
end

function love.draw()
    state:draw()
end


function love.keypressed(key, _, _)
    if key == 'escape' then love.event.quit() end
end

function love.mousemoved(x, y, dx, dy)
    state:mousemoved(x, y, dx, dy)
end

function love.mousepressed(x, y, button, _)
    state:mousepressed(x, y, button)
end
