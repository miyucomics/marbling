love.graphics.setLineStyle("rough")
love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setFont(love.graphics.newFont("assets/pico8.ttf", 6))

local Drop = require("objects.drop")
local Vector = require("libraries.vector")

local drops = {}

local function addDrop(position, radius, color)
    local drop = Drop(position, radius, color)
    for _, other in pairs(drops) do
        other:marble(position, radius)
    end
    table.insert(drops, drop)
end

local function tine(position, velocity, z, c)
    for _, dot in pairs(drops) do
        dot:tine(position, velocity, z, c)
    end
end

local timer = 0
local tickLength = 0.01
local previous = Vector(0, 0)
local mode = 0
local modes = {
    { "fine brush", 8, 2 },
    { "perfect tip", 20, 0.5 },
    { "mass displacement", 18, 20 }
}

function love.load()
    require("libraries.post")
end

function love.update(dt)
    timer = timer + dt
    if timer > tickLength then
        timer = timer - tickLength
        local current = Vector(love.mouse.getX(), love.mouse.getY()) / 2
        if love.mouse.isDown(1) then
            addDrop(current, 5)
        elseif love.mouse.isDown(2) then
            tine(current, (current - previous) / 25, modes[mode + 1][2], modes[mode + 1][3])
        end
        previous = current
    end
end

function love.draw()
    love.graphics.clear(30 / 255, 30 / 255, 46 / 255)
	love.graphics.setColor(242 / 255, 205 / 255, 205 / 255)
    love.graphics.print(modes[mode + 1][1], 10, 10)
    love.graphics.print("z: " .. modes[mode + 1][2], 10, 16)
    love.graphics.print("c: " .. modes[mode + 1][3], 10, 22)
    love.graphics.print("drops: " .. #drops, 10, 28)
    for _, drop in pairs(drops) do
        drop:draw()
    end
end

function love.wheelmoved(_, y)
    if y > 0 then
        mode = mode - 1
    elseif y < 0 then
        mode = mode + 1
    end
    mode = mode % #modes
end

function love.keypressed(key)
    if key == "delete" then
        drops = {}
    end
end
