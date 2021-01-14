function coord(x,y,z)
    return {x = x, y = y, z = z}
end

function add(ca,cb) 
    return {x = ca.x + cb.x, y = ca.y + cb.y, z = ca.z + cb.z}
end

Turtle = {}
function Turtle:new(direction)
    local t = setmetatable({},{__index = Turtle})
    t.dir = direction
    t.loc = coord(0,0,0)
    t.loc.x, t.loc.y, t.loc.z = gps.locate()
    return t
end

function Turtle:update_pos()
    print(self.loc)
    self.loc.x, self.loc.y, self.loc.z = gps.locate()
end

function Turtle:turnLeft()
    self.dir = (self.dir - 1)%4
    turtle.turnLeft()
end


function Turtle:turnRight()
    self.dir = (self.dir + 1)%4
    turtle.turnRight()
end

function Turtle:face(dir)
    while self.dir ~= dir do
        self:turnLeft()
    end
end

function Turtle:digmove(direction)
   self:face(dir)
   while not turtle.forward() do
       turtle.dig()
   end
   self:update_pos()
end

function Turtle:digmoveUp()
   while not turtle.up() do
       turtle.digUp()
   end
   self:update_pos()
end

function Turtle:digmoveUp()
   while not turtle.down() do
       turtle.digDown()
   end
   self:update_pos()
end

function Turtle:digmoveTo(tgt)
    local tdir = 0
    while tgt.x > self.loc.x do
        Turtle:digmove(0)
    end
    while tgt.x < self.loc.x do
        Turtle:digmove(2)
    end
    while tgt.y > self.loc.y do
        Turtle:digmoveUp()
    end
    while tgt.y > self.loc.y do
        Turtle:digmoveDown()
    end
    while tgt.z > self.loc.z do
        Turtle:digmove(1)
    end
    while tgt.z < self.loc.z do
        Turtle:digmove(3)
    end
end
