local GameState = require('utils.state')
local B = require('ui.button')
local C = require('ui.containers')


local Menu = GameState:subclass('Menu')


function Menu:initialize()
    Menu.super.initialize(self)
    self.buttons = C.LinearLayout()
    self.buttons:setOrientation('vertical')
    self.buttons:setPadding(50)
    self.pools:add(self.buttons)
end

function Menu:load()
    local x, y = love.graphics.getWidth()/2, 100
    local start = B.TextButton('Start', x, y)
    start:setOnClick(function() print('Should go to puzzle 1') end)
    local quit = B.TextButton('Quit', x, y)
    quit:setOnClick(function() love.event.quit() end)
    self.buttons:add({start, quit})
end

return Menu
