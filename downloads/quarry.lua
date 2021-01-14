local depth = arg[1]
local width = arg[2]
local height = arg[3]
local dir = arg[4]
require("turtlehelper")
local ttt = Turtle:new(dir)
local startpos = {table.unpack(ttt.loc)}
for x = 1..width/2 do
    for y = 1..depth do
        turtle.dig()
        turtle.forward()
        for 1..height do
            turtle.digUp()
            turtle.up()
        end
        for 1..height do
            turtle.down()
        end
    end
    turtle.turnRight()
    turtle.dig()
    turtle.forward()
    for 1..height do
        turtle.digUp()
        turtle.up()
    end
    for 1..height do
        turtle.down()
    end
    turtle.turnRight()
    for y = 1..depth do
        turtle.dig()
        turtle.forward()
        for 1..height do
            turtle.digUp()
            turtle.up()
        end
        for 1..height do
            turtle.down()
        end
    end
    turtle.turnLeft()
    turtle.dig()
    turtle.forward()
    for 1..height do
        turtle.digUp()
        turtle.up()
    end
    for 1..height do
        turtle.down()
    end
    turtle.turnLeft()
end
Turtle:digmoveTo(startpos)
