local class = require('utils.class')
local P = require('params')

local function Animator(dot, from, to, duration)
    local animator = {}
    local t = 0
    duration = duration or P.dotMoveDuration
    local running = true
    function animator:update(dt)
        -- cosine-LERP between from and to
        t = t + dt / duration
        local mu = (1 - math.cos(t*math.pi))/2
        dot.x = from.x + mu * (to.x - from.x)
        dot.y = from.y + mu * (to.y - from.y)
        if t > 1 then
            -- if finished, stick dot to the destination
            dot.x = to.x
            dot.y = to.y
            running = false
        end
    end
    function animator:running() return running end
    return animator
end

local Dot = class()

function Dot.new(i, j, x, y)
    local self = setmetatable({}, Dot)
    self.i, self.j = i, j
    self.x = x or 0
    self.y = y or 0
    self.animator = nil
    return self
end

function Dot:update(dt)
    if self.animator then
        self.animator:update(dt)
        if not self.animator:running() then
            -- destroy the animator
            self.animator = nil
        end
    end
end

function Dot:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

function Dot:isMoving() return self.animator ~= nil end

function Dot:startAnim(tox, toy)
    self.animator = Animator(self, {x=self.x, y=self.y}, {x=tox, y=toy})
end

function Dot:draw()
    love.graphics.setColor(P.puzzleLineColor)
    love.graphics.circle('fill', self.x, self.y, P.dotRadius)
    love.graphics.setLineWidth(1)
    love.graphics.circle('line', self.x, self.y, P.dotRadius)
end

function Dot:__tostring()
    return "Dot(" .. self.i .. ", " .. self.j .. ")"
end

return Dot
