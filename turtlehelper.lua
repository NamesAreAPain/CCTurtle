function coord(x,y,z)
    return {x = x, y = y, z = z}
end

function add(ca,cb) 
    return {x = ca.x + cb.x, y = ca.y + cb.y, z = ca.z + cb.z}
end

function translate(coord,x,y,z)
    return {x = coord.x + x, y = coord.y + y ,z = coord.z + z}
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
function Turtle:new()
    local t = setmetatable({},{__index = Turtle})
    t.dir = 0
    t.loc = coord(0,0,0)
    t:dirdance()
    t.coord_stack = Stack:new()
    t.step_funcs = {}
    table.insert(t.step_funcs,refuel)
    table.insert(t.step_funcs,deposit)
    t.loc.x, t.loc.y, t.loc.z = gps.locate()
    return t
end

function Turtle:dirdance()
    local loc1 = coord(0,0,0)
    loc1.x, loc1.y, loc1.z = gps.locate()
    turtle.dig()
    turtle.forward()
    local loc2 = coord(0,0,0)
    loc2.x, loc2.y, loc2.z = gps.locate()
    if loc2.x > loc1.x then
        self.dir = 0
    elseif loc2.x < loc1.x then
        self.dir = 2
    elseif loc2.z > loc1.z then
        self.dir = 1
    elseif loc2.z < loc1.z then
        self.dir = 3
    end
    turtle.back()
end

function Turtle:enable_veinminer()
    table.insert(self.step_funcs,veinminer)
end

function Turtle:start()
    local tgt = coord(0,0,0)
    while tgt ~= nil do
        tgt = self.coord_stack:pop()
        self:digmoveTo(tgt)
    end
end

function Turtle:step()
    local interrupt = true
    for i,v in ipairs(self.step_funcs) do
        interrupt = interrupt or v(self)
    end
    return interrupt
end

function refuel(ttt)
    if turtle.getFuelLevel() < 100 then
        local slot = 0
        for i = 1,16 do
            slot = turtle.getItemDetail(i,true)
            if slot ~= nil and slot.nbt == "2d39e538707a294bc5f91f47288cc603" then
                turtle.select(i)
                turtle.dig()
                turtle.place()
                turtle.suck()
                for j = 1,16 do
                    slot = turtle.getItemDetail(j) 
                    if slot ~= nil and turtle.getItemDetail(j).name == "minecraft:lava_bucket" then
                        turtle.select(j)
                        turtle.refuel()
                        turtle.drop()
                    end
                end
                turtle.select(1)
                turtle.dig()
            end
        end
    end
    return false
end

function deposit(ttt)
    if turtle.getItemCount(16) ~= 0 then
        local slot = 0
        for i = 1,16 do
            slot = turtle.getItemDetail(i,true)
            if slot ~= nil and slot.nbt == "391c6358c189111b0cf8d617f3855773" then
                turtle.select(i)
                turtle.dig()
                turtle.place()
            end
        end
        for i = 1,16 do
            slot = turtle.getItemDetail(i)
            if slot ~= nil and slot.name ~= "enderstorage:ender_chest" then
                turtle.select(i)
                turtle.drop()
            end
        end
        turtle.select(1)
        turtle.dig()
    end
    return false
end

function veinminer(ttt)
    loc = coord(gps.locate())
    ttt:turnLeft()
    local block = 0 
    local data = 0
    local found_anything = false
    local temp_queue = Queue:new()
    ttt:turnLeft()
    block, data  = turtle.inspect()
    if block and string.find(data.name,"ore") then
        temp_queue:push(ttt:coord_facing())
        found_anything = true
    end
    ttt:turnRight()
    ttt:turnRight()
    block, data  = turtle.inspect()
    if block and string.find(data.name,"ore") then
        temp_queue:push(ttt:coord_facing())
        found_anything = true
    end
    ttt:turnLeft()
    block, data  = turtle.inspectUp()
    if block and string.find(data.name,"ore") then
        temp_queue:push(translate(self.loc,0,1,0))
        found_anything = true
    end
    block, data  = turtle.inspectDown()
    if block and string.find(data.name,"ore") then
        temp_queue:push(translate(self.loc,0,-1,0))
        found_anything = true
    end
    if found_anything then
        ttt.coord_stack:push(loc)
        local temp = temp_queue.pop()
        while temp do
            ttt.coord_stack:push(temp)
            temp = temp_queue.pop()
        end
    end
    return found_anything
end

function Turtle:coord_facing()
    if self.dir == 0 then
        return translate(self.loc, 1,0,0)
    elseif self.dir == 1 then
        return translate(self.loc,0,0,1)
    elseif self.dir == 2 then
        return translate(self.loc,-1,0,0)
    elseif self.dir == 3 then
        return translate(self.loc,0,0,-1)
    end
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
    return self:step()
end

function Turtle:digmoveUp()
    while not turtle.up() do
       turtle.digUp()
    end
    self:update_pos()
    return self:step()
end

function Turtle:digmoveDown()
    while not turtle.down() do
       turtle.digDown()
    end
    self:update_pos()
    return self:step()
end

function Turtle:digmoveTo(tgt)
    while tgt.x > self.loc.x do
        if self:digmove(0) then return true end
    end
    while tgt.x < self.loc.x do
        if self:digmove(2) then return true end
    end
    while tgt.y > self.loc.y do
        if self:digmoveUp() then return true end
    end
    while tgt.y < self.loc.y do
        if self:digmoveDown() then return true end
    end
    while tgt.z > self.loc.z do
        if self:digmove(1) then return true end
    end
    while tgt.z < self.loc.z do
        if self:digmove(3) then return true end
    end
    return false
end

function Turtle:mineCuboid(ca,cb)
   local upp = coord(max(ca.x,cb.x),max(ca.y,cb.y),max(ca.z,cb.z))
   local low = coord(min(ca.x,cb.x),min(ca.y,cb.y),min(ca.z,cb.z))
   local reverseStack = Stack:new()
   reverseStack:push(low)
   local i = 0
   for x = low.x,upp.x do
       if i % 2 == 0 then
            reverseStack:push(coord(x,low.y,low.z))
       else
            reverseStack:push(coord(x,low.y,upp.z))
       end
       for y = low.y,upp.y do
            if i % 2 == 0 then 
                reverseStack:push(coord(x,y,upp.z))
            else
                reverseStack:push(coord(x,y,low.z))
            end
            i = i + 1
       end
   end
   local j = coord(0,0,0)
   while j~= nil do
        j = reverseStack:pop()
        self.coord_stack:push(j)
   end
end

Queue = {}
function Queue:new()
    local t = setmetatable({},{__index = Queue})
    t.arr = {}
    return t
end

function Queue:push(x)
   table.insert(self.arr,x)
end

function Queue:pop()
    return table.remove(self.arr,1)
end

Stack = {}
function Stack:new()
    local t = setmetatable({},{__index = Stack})
    t.arr = {}
    return t
end

function Stack:push(x)
    table.insert(self.arr,1,x)
end

function Stack:pop()
    return table.remove(self.arr)
end

