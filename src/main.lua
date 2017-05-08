local Menu = require('states.menu')
math.randomseed(os.time())

local state

function love.load()
    state = Menu()
    state:load()
end

function love.update(dt)
    state:update(dt)
    if state:isFinished() then
        state = state:next()
        state:load()
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
