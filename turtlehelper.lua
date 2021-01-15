function coord(x,y,z)
    return {x = x, y = y, z = z}
end

function add(ca,cb) 
    return {x = ca.x + cb.x, y = ca.y + cb.y, z = ca.z + cb.z}
end

function mul(ca,cb)
    return {x = ca.x*cb.x, y = ca.y*cb.y, z = ca.z + cb.z}
end

function max(a,b)
    if a > b then return a else return b end
end

function min(a,b)
    if a < b then return a else return b end
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

function Turtle:digmove(dir)
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

function Turtle:digmoveDown()
   while not turtle.down() do
       turtle.digDown()
   end
   self:update_pos()
end

function Turtle:digmoveTo(tgt)
    while tgt.x > self.loc.x do
        self:digmove(0)
    end
    while tgt.x < self.loc.x do
        self:digmove(2)
    end
    while tgt.y > self.loc.y do
        self:digmoveUp()
    end
    while tgt.y < self.loc.y do
        self:digmoveDown()
    end
    while tgt.z > self.loc.z do
        self:digmove(1)
    end
    while tgt.z < self.loc.z do
        self:digmove(3)
    end
end

function Turtle:mineCuboid(ca,cb)
   local upp = coord(max(ca.x,cb.x),max(ca.y,cb.y),max(ca.z,cb.z))
   local low = coord(min(ca.x,cb.x),min(ca.y,cb.y),min(ca.z,cb.z))
   self:digmoveTo(low)
   local i = 0
   for x = low.x,upp.x do
       if i % 2 == 0 then
            digmoveTo(x,low.y,low.z)
       else
            digmoveTo(x,low.y,upp.z)
       end
       for y = low.y,upp.y do
            if i % 2 == 0 then 
                self:digmoveTo(x,y,upp.z)
            else
                self:digmoveTo(x,y,low.z)
            end
            i = i + 1
       end
   end
end





