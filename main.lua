local
table_insert, math_random, graphics
=
table.insert, math.random, love.graphics

local map = {}

-- 800 by 800 pixel grid
for i = 1,640000 do
    table_insert(map,0)
end

-- 2d to 1d calcultion
local function convert_1d_to_2d(i)
    i = i - 1
    local x = (i % 800) % 800
    local y = math.floor(i / 800)
    return({ x, y })
end

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")
end

function love.update()

end

local pass = 0

-- opengl draw loop to engine api
function love.draw()

    for i = 1,640000 do
        local x,y = unpack(convert_1d_to_2d(i))
        graphics.setColor(math_random(), math_random(), math_random(), 1)
        graphics.points( x, y)
    end

    pass = pass + 1
end-- opengl draw loop to engine api