function rouletteOrder()
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
    return roulette_order
end

function wheelGrid()
    local roulette_order = rouletteOrder()
    local grid = {}
    local i = 1
    for y = 2,22,4 do
        if y == 6 or y == 18 then
            for x = 5,41,6 do
                grid[i] = table.pack(x,y,table.unpack(roulette_order[i]))
                i = i + 1
            end
        else
            for x = 5,35,6 do
                grid[i] = table.pack(x,y,table.unpack(roulette_order[i]))
                i = i + 1
            end
        end
    end
    return grid
end
function drawWheel(monitor)
    local grid = wheelGrid()
    monitor.setTextScale(1)
    monitor.setCursorBlink(false)
    monitor.setCursorPos(1,1)
    monitor.setBackgroundColor(colors.green)
    monitor.clear()
    for i,x in ipairs(grid) do
        drawSquare(monitor,table.unpack(x))
    end
end
function drawSquare(monitor,x,y,num,oddity,color)
    local name = num
    if string.len(num) == 2 then
        name = string.sub(num,1,1).." "..string.sub(num,2,2)
    end
    drawRectangle(7,5,colors.brown,monitor,name,color,x,y)
end
function pad(str,n)
    local out = ""
    for i=1,n do
        out = out..str
    end
    return out
end

function boardGrid()
    local board = {}
    local roulette_order = rouletteOrder()
    local i = 1
    for x = 7,73,6 do
        for y = 11,3,-4 do
            board[i] = table.pack(x,y,table.unpack(roulette_order[searchTable(roulette_order,i.."")]))
            i = i + 1
        end
    end
    board[i] = table.pack(1,5,table.unpack(roulette_order[searchTable(roulette_order,"00")]))
    i = i + 1
    board[i] = table.pack(1,9,table.unpack(roulette_order[searchTable(roulette_order,"0")]))
    local twelves = {
        table.pack("1st  12",colors.green,7,15),
        table.pack("2nd  12",colors.green,31,15),
        table.pack("3rd  12",colors.green,55,15),
    }
    local doubles = {
        table.pack("1 to 18",colors.green,7,19),
        table.pack(" EVENS ",colors.green,19,19),
        table.pack("  RED  ",colors.red,31,19),
        table.pack(" BLACK ",colors.black,43,19),
        table.pack("  ODD  ",colors.green,55,19),
        table.pack("19to 36",colors.green,67,19)
    }
    return board,twelves,doubles
end

function drawRectangle(width,height,outer_color,monitor,text,inner_color,x,y)
    local tlen = string.len(text)
    local padding = (width-2-tlen)/2
    for i = 1,(height-2) do
        monitor.setCursorPos(x+1,y+i)
        if i == (height-1)/2 then
           monitor.blit(pad(" ",padding)..text..pad(" ",padding),pad(colors.toBlit(colors.white),width-2),pad(colors.toBlit(inner_color),width-2))
        else
            monitor.blit(pad(" ",width-2),pad(colors.toBlit(inner_color),width-2),pad(colors.toBlit(inner_color),width-2))
        end
    end
    drawBorder(width,height,monitor,outer_color,x,y)
end
function drawBorder(width,height,monitor,color,x,y)
    monitor.setCursorPos(x,y)
    monitor.blit(pad(" ",width),pad(colors.toBlit(color),width),pad(colors.toBlit(color),width))
    for i=1,(height-2) do
        monitor.setCursorPos(x,y+i)
        monitor.blit(" ",colors.toBlit(color),colors.toBlit(color))
        monitor.setCursorPos(x+(width-1),y+i)
        monitor.blit(" ",colors.toBlit(color),colors.toBlit(color))
    end
    monitor.setCursorPos(x,(y+height-1))
    monitor.blit(pad(" ",width),pad(colors.toBlit(color),width),pad(colors.toBlit(color),width))
end
function drawTwelves(monitor,name,color,x,y)
    drawRectangle(25,5,colors.brown,monitor,name,color,x,y)
end

function drawDoubles(monitor,name,color,x,y)
    drawRectangle(13,5,colors.brown,monitor,name,color,x,y)
end

function drawBoard(monitor)
    monitor.setTextScale(0.5)
    monitor.setCursorBlink(false)
    monitor.setCursorPos(1,1)
    monitor.setBackgroundColor(colors.green)
    monitor.clear()
    local numgrid,twelves,doubles = boardGrid()
    for i,x in ipairs(numgrid) do
        drawSquare(monitor,table.unpack(x))
    end
    for i,x in ipairs(twelves) do
        drawTwelves(monitor,table.unpack(x))
    end
    for i,x in ipairs(doubles) do
        drawDoubles(monitor,table.unpack(x))
    end
end


function searchTable(t,val)
    for i,x in ipairs(t) do
        if table.unpack(x) == val then
            return i
        end
    end
    return nil
end




