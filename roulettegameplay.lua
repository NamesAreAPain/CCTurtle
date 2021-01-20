require("roulettegraphics")

function spin(monitor)
    local i = 1
    local wheel_grid = wheelGrid()
    for j = 1,math.random(25,75) do
       spin_step(monitor,i,wheel_grid)
       sleep(0.1)
       i = (i%38)+1
    end
    for j = 1,math.random(10,25) do
       spin_step(monitor,i,wheel_grid)
       sleep(0.2)
       i = (i%38)+1
    end
    for j = 1,math.random(5,10) do
       spin_step(monitor,i,wheel_grid)
       sleep(0.3)
       i = (i%38)+1
    end
    for j = 1,math.random(1,5) do
       spin_step(monitor,i,wheel_grid)
       sleep(0.5)
       math.random(2)
       i = (i%38)+1
    end
    spin_finish(monitor,i,wheel_grid)
    local x,y,num,oddity,color = wheel_grid[i]
    return num
end

function spin_step(monitor,i,grid)
    highlightSquare(monitor, colors.brown,table.unpack(grid[(i-1)%38 + 1]))
    highlightSquare(monitor, colors.white,table.unpack(grid[i%38 + 1]))
end
function spin_finish(monitor,i,grid)
    highlightSquare(monitor, colors.brown,table.unpack(grid[(i-1)%38 + 1]))
    for j=1,20 do
        sleep(0.1)
        highlightSquare(monitor, colors.yellow,table.unpack(grid[(i)%38 + 1]))
        sleep(0.1)
        highlightSquare(monitor, colors.white,table.unpack(grid[(i)%38 + 1]))
    end
end

function waitForBets()
    local timeout = os.startTimer(1)
end


