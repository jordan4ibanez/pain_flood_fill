local
math_random, graphics,      math_floor
=
math.random, love.graphics, math.floor

local map = {}

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end



-- 800 by 800 pixel grid
for i = 1,800*800 do
    table.insert(map,0)
end

-- current and new queue
local current_queue = {}

-- user input
local started = false
function love.mousepressed( x, y, button )
    -- and so begins the flood fill, entry point to flood fill
    if button == 1 and x <= 800 and x >= 0 and y <= 800 and y >= 0 and not started then
        current_queue[1] = {
            pos_x = x,
            pos_y = y,
        }
        started = true
        print("started")
    end
end


-- 1d to 2d calcultion
local function convert_1d_to_2d(i)
    i = i - 1
    return({ (i % 800) % 800, math_floor(i / 800) })
end
-- 2d to 1d calculation
local function convert_2d_to_1d(x,y)
    return (y * 800) + x
end

-- engine load entry point
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")
end

-- basic collision detection
local function clear(x,y)
    if x >= 0 and x <= 800 and y >= 0 and y <= 800 and map[convert_2d_to_1d(x,y)] == 0 then
        return true
    end
    return false
end

-- basic slotting function
local function free_slot()
    for i = 1,800000000 do
        if not current_queue[i] then
            return i
        end
    end
end

-- processes the queues and lines up next engine cycles queue
local function process_queue()

    local current_loop = 0
    for index, value in pairs(current_queue) do

        local x = value.pos_x
        local y = value.pos_y

        map[convert_2d_to_1d(x,y)] = math_random()

        current_queue[index] = nil

        
        if clear(x + 1 , y) then
            current_queue[free_slot()] = {
                pos_x = x + 1,
                pos_y = y
            }
        end

        if clear(x - 1 , y) then
            current_queue[free_slot()] = {
                pos_x = x - 1,
                pos_y = y
            }
        end

        
        if clear(x , y + 1) then
            current_queue[free_slot()] = {
                pos_x = x,
                pos_y = y + 1
            }
        end

        if clear(x , y - 1) then
            current_queue[free_slot()] = {
                pos_x = x,
                pos_y = y - 1
            }
        end
        
        current_loop = current_loop + 1
        if current_loop >= 133 then
            break
        end
    end
end

-- engine update loop
function love.update()
    process_queue()
end

-- opengl draw loop to engine api
function love.draw()

    for index,value in ipairs(map) do
        if value ~= 0 then
            local x,y = unpack(convert_1d_to_2d(index))
            graphics.setColor(value, 0, 0, 1)
            graphics.points( x, y)
        end
    end

    love.graphics.setColor(0,0,0,1)
    love.graphics.print("PAIN",360,360,0,3,3)

    love.graphics.print("PAIN",0,0,0,3,3)

    love.graphics.print("PAIN",710,750,0,3,3)

    love.graphics.print("PAIN",710,0,0,3,3)

    love.graphics.print("PAIN",0,750,0,3,3)

end