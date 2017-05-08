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
    if color == 'none' then self.color = {0, 0, 0, 0}
    else self.color = color or P.defaultButtonColor end
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
    TextButton.super.initialize(self, x, y, width, height, onClick)
    self.wrapWidth = true
    self.wrapHeight = true
    self.textColor = P.fontColor
    self.textStr = text
    self.text = love.graphics.newText(P.font, self.textStr)
end

function TextButton:setWidth(value)
    if type(value) == 'string' then
        if value == 'wrap_content' then self.wrapWidth = true
        else return end
    else
        self.wrapWidth = false
        self.width = value
    end
end

function TextButton:setHeight(value)
    if type(value) == 'string' then
        if value == 'wrap_content' then self.wrapHeight = true
        else return end
    else
        self.wrapHeight = false
        self.height = value
    end
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

function TextButton:getTextColor()
    if self.hovering then
        local c = self.textColor
        return {
            c[1] + (c[1] < 128 and 50 or -50),
            c[2] + (c[2] < 128 and 50 or -50),
            c[3] + (c[3] < 128 and 50 or -50),
            c[4]
        }
    else return self.textColor end
end

function TextButton:setTextColor(color)
    self.textColor = color
end

function TextButton:addBorder(width, color)
    width = width or 1
    self.borderWidth = width
    self.borderColor = color
end

function TextButton:getBorderColor()
    return self.borderColor or self:getTextColor()
end

function TextButton:drawBackground()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, self:getWidth(), self:getHeight())
end

function TextButton:drawBorder()
    if self.borderWidth then
        love.graphics.setLineJoin('bevel')
        love.graphics.setColor(self:getBorderColor())
        love.graphics.setLineWidth(self.borderWidth)
        love.graphics.rectangle('line', self.x, self.y, self:getWidth(), self:getHeight())
    end
end

function TextButton:drawText()
    love.graphics.setColor(self:getTextColor())
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
