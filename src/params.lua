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
P.puzzleLineWidth = 6  -- px
P.puzzleA = 70 -- px

P.arrowLineWidth = 6 -- px
P.arrowSize = 15 -- px

P.dotRadius = 8 -- px
P.dotMoveDuration = 1 -- seconds

P.rectangleLineWidth = 6  -- px
P.rectangleColor = makeColor('#ff8822')
P.rectangleDotRadius= 4 -- px

P.font = love.graphics.newFont('res/fonts/hellovetica.ttf')
P.fontColor = makeColor('#bbbfbf')

P.defaultButtonColor = makeColor('#ffffff')

return P
