local Base = require('utils.base')
local Pool = require('utils.pool')

local GameState = Base:subclass('GameState')

function GameState:initialize()
    self.pools = Pool()
    self.objects = Pool()
    self.clickable = Pool()
    self.pools:add(self.objects, self.clickable)
end

function GameState:update(dt)
    self.pools:update(dt)
end

function GameState:draw()
    self.pools:draw()
end

function GameState:mousemoved(x, y)
    self.clickable:mousemoved(x, y)
end

function GameState:mousepressed(x, y, button)
    self.clickable:mousepressed(x, y, button)
end

return GameState
