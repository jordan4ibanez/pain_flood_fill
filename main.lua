require("ecs")

local
table_insert, math_random, graphics
=
table.insert, math.random, love.graphics

local map = {}

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

-- 800 by 800 pixel grid
for i = 1,640000 do
    table_insert(map,0)
end

-- current and new queue
local current_queue = ecs:new()
local new_queue = ecs:new()

current_queue:add_components({"pos_x", "pos_y"})
new_queue:add_components({"pos_x", "pos_y"})

-- ecs bolt on
function current_queue:get_entity(index)
    return ({self.pos_x[index], self.pos_y[index]})
end

-- user input
function love.mousepressed( x, y, button, istouch, presses )
    -- and so begins the flood fill, entry point to flood fill
    if button == 1 and x <= 800 and x >= 0 and y <= 800 and y >= 0 and current_queue.entity_count == 0 then
        current_queue:add_entity({
            pos_x = x,
            pos_y = y,
        })
        print("started")
    end
end


-- 1d to 2d calcultion
local function convert_1d_to_2d(i)
    i = i - 1
    local x = (i % 800) % 800
    local y = math.floor(i / 800)
    return({ x, y })
end
-- 2d to 1d calculation
local function convert_2d_to_1d(x,y)
    return (x * 800) + y
end

-- engine load entry point
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")
end


-- processes the queues and lines up next engine cycles queue
local function process_queue()

    -- this allows ultimate flexibility for processing of ecs
    while current_queue.entity_count > 0 do
        
    end

    while new_queue.entity_count > 0 do

    end
end

-- engine update loop
function love.update()
    process_queue()
end

local pass = 0

-- opengl draw loop to engine api
function love.draw()

    for i = 1,640000 do
        local new_color = map[i]
        if new_color == 1 then
            local x,y = unpack(convert_1d_to_2d(i))
            graphics.setColor(new_color, 0, 0, 1)
            graphics.points( x, y)
        end
    end

    pass = pass + 1
end