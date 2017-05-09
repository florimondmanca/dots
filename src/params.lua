local colors = require('utils.colors')

local P = {}
local function makeColor(code, alpha)
    alpha = alpha or 255
    local c = colors.new(code)
    local r, g, b = colors.hsl_to_rgb(c.H, c.S, c.L)
    return {255*r, 255*g, 255*b, alpha}
end


P.backgroundColor = makeColor('#ffffff')

P.puzzleLineColor = makeColor('#bbbfbf')
local lineWidth = 8
P.puzzleLineWidth = lineWidth  -- px
P.puzzleA = 60 -- px

P.arrowLineWidth = lineWidth*.8 -- px
P.arrowSize = P.puzzleA/4 -- px

P.dotRadius = lineWidth -- px
P.dotMoveDuration = .1 -- seconds

P.rectangleLineWidth = lineWidth  -- px
P.rectangleColor = makeColor('#ff8822')

P.font = love.graphics.newFont('res/fonts/hellovetica.ttf')
P.fontColor = makeColor('#bbbfbf')

P.defaultButtonColor = makeColor('#ffffff')

return P
