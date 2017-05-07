local class = require('utils.class')
local P = require('params')

local Animator = class('Animator')

function Animator:initialize(sprite, from, to, duration)
    self.sprite = sprite
    self.t = 0
    self.from = from
    self.to = to
    self.duration = duration
    self.running = true
end

function Animator:update(dt)
    -- cosine-LERP between from and to
    self.t = self.t + dt / self.duration
    local mu = (1 - math.cos(self.t*math.pi))/2
    self.sprite.x = self.from.x + mu * (self.to.x - self.from.x)
    self.sprite.y = self.from.y + mu * (self.to.y - self.from.y)
    if self.t > 1 then
        -- if finished, stick sprite to the destination
        self.sprite.x = self.to.x
        self.sprite.y = self.to.y
        self.running = false
    end
end

--

local Dot = class('Dot')

function Dot:initialize(i, j, x, y)
    self.i = i or 1
    self.j = j or 1
    self.x = x or 0
    self.y = y or 0
    self.animator = nil
end


function Dot:update(dt)
    if self.animator then
        self.animator:update(dt)
        if not self.animator.running then
            -- destroy the animator
            self.animator = nil
        end
    end
end


function Dot:draw()
    love.graphics.setColor(P.puzzleLineColor)
    love.graphics.circle('fill', self.x, self.y, P.dotRadius)
    love.graphics.setLineWidth(1)
    love.graphics.circle('line', self.x, self.y, P.dotRadius)
end


function Dot:isMoving()
    return self.animator ~= nil
end


function Dot:startAnim(tox, toy)
    self.animator = Animator(self, {x=self.x, y=self.y}, {x=tox, y=toy})
end


function Dot:__tostring()
    return "Dot(" .. self.i .. ", " .. self.j .. ")"
end

return Dot
