local class = require('utils.class')
local P = require('params')

local M = {} -- module

local Button = class('Button')

function Button:initialize(x, y, width, height, onClick)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 0
    self.height = height or 0
    self.visible = true
    self.onClick = onClick or function() end
    self.hovering = false
    self.color = P.defaultButtonColor
    return self
end

function Button:setBackgroundColor(color)
    self.color = color or P.defaultButtonColor
end
function Button:hide() self.visible = false end
function Button:show() self.visible = true end

function Button:getWidth() return self.width end
function Button:getHeight() return self.height end

function Button:update(_) end

function Button:draw() end

function Button:setOnClick(callback)
    self.onClick = callback
end

function Button:isHovering(x, y)
    return (x > self.x and x < self.x + self:getWidth() and y > self.y and y < self.y + self:getHeight())
end

function Button:mousemoved(x, y)
    if not self.visible then return end
    self.hovering = self:isHovering(x, y)
    if self.hovering then print('hovering!') end
end

function Button:mousepressed(x, y, button)
    if not self.visible then return end
    if button == 1 and self.onClick and self.hovering then
        self.onClick(x, y)
    end
end

M.Button = Button


local TextButton = Button:subclass('TextButton')

function TextButton:initialize(text, x, y, width, height, onClick)
    Button.initialize(self, x, y, width, height, onClick)
    self.wrapWidth = true
    self.wrapHeight = true
    self.textColor = P.textColor
    self.textStr = text
    self.text = love.graphics.newText(P.font, self.textStr)
end

function TextButton:setWidth(value)
    if type(value) == 'string' then
        if value == 'wrap_content' then self.wrapWidth = true
        else return end
    else self.width = value end
end

function TextButton:setHeight(value)
    if type(value) == 'string' then
        if value == 'wrap_content' then self.wrapHeight = true
        else return end
    else self.height = value end
end

function TextButton:getWidth()
    if self.wrapWidth then
        return self.text:getWidth() + 2*self:getPadX()
    else return self.width + 2*self:getPadX() end
end

function TextButton:getHeight()
    if self.wrapHeight then
        return self.text:getHeight() + 2*self:getPadY()
    else return self.height + 2*self:getPadY() end
end

function TextButton:setPadding(padX, padY)
    padX = padX or 1
    padY = padY or padX
    self.padX, self.padY = padX, padY
end

function TextButton:getPadX() return self.padX or 0 end
function TextButton:getPadY() return self.padY or 0 end

function TextButton:addBorder(width, color)
    width = width or 1
    color = color or self.textColor
    self.borderWidth = width
    self.borderColor = color
end

function TextButton:drawBackground()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, self:getWidth(), self:getHeight())
end

function TextButton:drawBorder()
    if self.borderWidth and self.borderColor then
        love.graphics.setLineJoin('miter')
        love.graphics.setColor(self.borderColor)
        love.graphics.setLineWidth(self.borderWidth)
        love.graphics.rectangle('line', self.x, self.y, self:getWidth(), self:getHeight())
    end
end

function TextButton:drawText()
    love.graphics.setColor(self.textColor)
    love.graphics.draw(self.text,
        self.x + self:getWidth()/2 - self.text:getWidth()/2,
        self.y + self:getHeight()/2 - self.text:getHeight()/2
    )
end

function TextButton:draw()
    if not self.visible then return end
    self:drawBackground()
    self:drawBorder()
    self:drawText()
end

M.TextButton = TextButton

return M
