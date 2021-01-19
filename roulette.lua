function drawCircle(cX,cY,r,color)
    local radius = math.pi * r
    for i = 1,360 do
        local x = math.sin(radius*i)
        local y = math.cos(radius*i)
        paintutils.drawLine(cX,cY,cX+x,xY+y,colors.red)
    end
end

local roulette_order = {
    table.pack("19",1,colors.red),
    table.pack("31",1,colors.black),
    table.pack("18",2,colors.red),
    table.pack("6",2,colors.black),
    table.pack("21",1,colors.red),
    table.pack("33",1,colors.black),
    table.pack("16",2,colors.red),
    table.pack("4",2,colors.black),
    table.pack("23",1,colors.red),
    table.pack("35",1,colors.black),
    table.pack("14",2,colors.red),
    table.pack("2",2,colors.black),
    table.pack("0",0,colors.lime),
    table.pack("28",2,colors.black),
    table.pack("9",1,colors.red),
    table.pack("26",2,colors.black),
    table.pack("30",2,colors.red),
    table.pack("11",1,colors.black),
    table.pack("7",1,colors.red),
    table.pack("20",2,colors.black),
    table.pack("32",2,colors.red),
    table.pack("17",1,colors.black),
    table.pack("5",1,colors.red),
    table.pack("22",2,colors.black),
    table.pack("34",2,colors.red),
    table.pack("15",1,colors.black),
    table.pack("3",1,colors.red),
    table.pack("24",2,colors.black),
    table.pack("36",2,colors.red),
    table.pack("13",1,colors.black),
    table.pack("1",1,colors.red),
    table.pack("00",0,colors.lime),
    table.pack("27",1,colors.red),
    table.pack("10",2,colors.black),
    table.pack("25",1,colors.red),
    table.pack("29",1,colors.black),
    table.pack("12",2,colors.red),
    table.pack("8",2,colors.black),
}

function rouletteGrid()
    local grid = {}
    local i = 1
    for y = 9,51,7 do
        if y == 16 or y == 44 then
            for x = 19,61,7 do
                grid[i] = table.pack(x,y,table.unpack(roulette_order[i]))
                i = i + 1
            end
        else
            for x = 19,54,7 do
                grid[i] = table.pack(x,y,table.unpack(roulette_order[i]))
                i = i + 1
            end
        end
    end
end
function drawGrid(monitor,grid)
    monitor.setTextScale(0.5)
    monitor.setCursorBlink(false)
    monitor.setCursorPos(1,1)
    monitor.setBackgroundColor(colors.green)
    monitor.clear()
    for i,x in ipairs(grid) do
        drawSquare(monitor,table.unpack(x))
    end
end
function drawSquare(monitor,x,y,num,oddity,color)
   monitor.setCursorPos(x-3,y-3)
   monitor.blit("       ","ccccccc","ccccccc")
   monitor.setCursorPos(x-3,y-2)
   monitor.blit("       ","c"..pad(colors.toBlit(color),5).."c","c"..pad(colors.toBlit(color),5).."c")
   monitor.setCursorPos(x-3,y-1)
   monitor.blit("       ","c"..pad(colors.toBlit(color),5).."c","c"..pad(colors.toBlit(color),5).."c")
   monitor.setCursorPos(x-3,y)
   if string.len(num) == 2 then
        monitor.blit("  "..string.sub(num,1,1).." "..string.sub(2,2).."  ","c"..colors.toBlit(color)..colors.toBlit(colors.white)..colors.toBlit(color)..colors.toBlit(colors.white)..colors.toBlit(color).."c","c"..pad(colors.toBlit(color),5).."c")
   else
        monitor.blit("   "..num.."   ","c"..pad(colors.toBlit(color),2)..colors.toBlit(colors.white)..pad(colors.toBlit(color),2).."c","c"..pad(colors.toBlit(color),5).."c")
   end
   monitor.setCursorPos(x-3,y+1)
   monitor.blit("       ","c"..pad(colors.toBlit(color),5).."c","c"..pad(colors.toBlit(color),5).."c")
   monitor.setCursorPos(x-3,y+2)
   monitor.blit("       ","c"..pad(colors.toBlit(color),5).."c","c"..pad(colors.toBlit(color),5).."c")
   monitor.setCursorPos(x-3,y+3)
   monitor.blit("       ","ccccccc","ccccccc")
end
function pad(str,n)
    local out = ""
    for i=1,n do
        out = out..str
    end
end

