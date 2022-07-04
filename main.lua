local
math_random, graphics,      math_floor
=
math.random, love.graphics, math.floor

local map = {}

local start_sound
local music
local end_sound
local started = false
local ended = false
local counter = 0

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end



-- 800 by 800 pixel grid
for i = 1,800*800 do
    table.insert(map,-1)
end

-- current and new queue
local current_queue = {}

-- user input
function love.mousepressed( x, y, button )
    -- and so begins the flood fill, entry point to flood fill
    if button == 1 and x <= 800 and x >= 0 and y <= 800 and y >= 0 and not started then
        current_queue[1] = {
            pos_x = x,
            pos_y = y,
        }
        started = true
        start_sound:play()
        music:play()
    end
end


--[[
x == z
y == y
]]--
-- 1d to 2d calcultion
local function convert_1d_to_2d(i)
    i = i - 1
    local x = math.floor(i / 800)
    i = i % 800
    local y = math.floor(i)

    return({x,y})
end
-- 2d to 1d calculation
local function convert_2d_to_1d(x,y)
    return math.floor((x * 800) + y + 1)
end

-- engine load entry point
function love.load()

    start_sound = love.audio.newSource("sounds/start.wav", "static")
    music = love.audio.newSource("sounds/Lightless Dawn.mp3", "stream")
    end_sound = love.audio.newSource("sounds/impact.ogg", "static")


    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")
end

-- basic collision detection
local function clear(x,y)
    if x > 0 and x < 800 and y > 0 and y < 800 and map[convert_2d_to_1d(x,y)] <= 0 then
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

local function unfree_slot()
    local not_found = true
    while not_found do
        local selection = math_random(1,20)
        if current_queue[selection] then
            return selection
        end
    end
end

-- processes the queues and lines up next engine cycles queue
local function process_queue()

    local current_loop = 0
    for index,value in pairs(current_queue) do


        if math_random() > 0.5 then

            current_loop = current_loop + 1

            if current_loop >= 3000 then
                return
            end

            


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

            counter = counter + 1
        end
    end

    -- end of the program signal
    if started == true and current_loop == 0 and ended == false and counter > 100 then
        ended = true

        music:stop()
        end_sound:play()
    end
end

-- engine update loop
function love.update()
    process_queue()

    if not ended then
        if started and not music:isPlaying() then
            music:play()
        end
    end
end

-- opengl draw loop to engine api
function love.draw()

    for index,value in ipairs(map) do
        if value > 0 then
            local x,y = unpack(convert_1d_to_2d(index))
            graphics.setColor(value, 0, 0, 1)
            graphics.points( x, y)
        end
    end

    love.graphics.setColor(0,0,0,1)
    
    if ended then
        love.graphics.print("PAINTING",360,360,0,3,3)

        love.graphics.print("PAINTING",0,0,0,3,3)

        love.graphics.print("PAINTING",620,750,0,3,3)

        love.graphics.print("PAINTING",620,0,0,3,3)

        love.graphics.print("PAINTING",0,750,0,3,3)
    else
        love.graphics.print("PAIN",360,360,0,3,3)

        love.graphics.print("PAIN",0,0,0,3,3)

        love.graphics.print("PAIN",620,750,0,3,3)

        love.graphics.print("PAIN",620,0,0,3,3)

        love.graphics.print("PAIN",0,750,0,3,3)
    end

end