local GameState = require('utils.state')
local B = require('ui.button')
local C = require('ui.containers')
local P = require('params')


local Menu = GameState:subclass('Menu')


function Menu:initialize()
    Menu.super.initialize(self)
    self.buttons = C.LinearLayout()
    self.buttons:setOrientation('horizontal')
    self.buttons:setPadding(10)
    self.clickable:add(self.buttons)
end

function Menu:load()
    love.graphics.setBackgroundColor(P.backgroundColor)
    -- create buttons
    local x, y = love.graphics.getWidth()/2, 100
    local start = B.TextButton('Start', x, y)
    start:setOnClick(function() print('Should go to puzzle 1') end)
    start:setPadding(5)
    local quit = B.TextButton('Quit', x, y)
    quit:setOnClick(function() love.event.quit() end)
    quit:setPadding(5)
    self.buttons:add(start)
    self.buttons:add(quit)
    for b in self.buttons:iter() do
        b:setBackgroundColor('none')
        b:addBorder(2)
    end
end

return Menu
