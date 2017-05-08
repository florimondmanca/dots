local P = require('params')
local class = require('utils.class')
local Button = require('ui.button')

local TextButton = class('TextButton', Button)

function TextButton:initialize(text, x, y, width, height, onClick, options)
    Button.initialize(self, x, y, width, height, onClick, options)
    self.textStr = text
    self.text = love.graphics.newText(P.font, self.textStr)
end

function TextButton:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.draw(self.text, self.x, self.y)
end
