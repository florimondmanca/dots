local colors = require('utils.colors')

local P = {}
local function makeColor(code, alpha)
    alpha = alpha or 255
    local c = colors.new(code)
    return {colors.hsl_to_rgb(c.H, c.S, c.L), alpha}
end


P.backgroundColor = {235, 240, 240, 255}

P.puzzleLineColor = {180, 185, 185, 255}
P.puzzleLineWidth = 6  -- px
P.puzzleA = 70 -- px

P.arrowLineWidth = 6 -- px
P.arrowSize = 15 -- px

P.dotRadius = 8 -- px
P.dotMoveDuration = .2 -- seconds

P.rectangleLineWidth = 6  -- px
P.rectangleColor = {255, 130, 30, 255}
P.rectangleDotRadius= 4 -- px

P.font = love.graphics.newFont('res/fonts/VCR_OSD_MONO_1.001.ttf')
P.fontColor = makeColor('#000000')

return P
