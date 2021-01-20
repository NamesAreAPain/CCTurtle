require("roulettegraphics")

function spin(monitor)
    local continue = true
    local win = math.random(38)
    local i = 1
    local wheel_grid = wheelGrid()
    for j = 1,100 do
       spin_step(monitor,i,wheel_grid)
       sleep(0.1)
       i = (i%38)+1
    end
    for j = 1,math.random(50) do
       spin_step(monitor,i,wheel_grid)
       sleep(0.1)
       i = (i%38)+1
    end
    for j = 1,50 do
       spin_step(monitor,i,wheel_grid)
       sleep(0.15)
       i = (i%38)+1
    end
    for j = 1,math.random(25) do
       spin_step(monitor,i,wheel_grid)
       sleep(0.15)
       i = (i%38)+1
    end
    for j = 1,25 do
       spin_step(monitor,i,wheel_grid)
       sleep(0.2)
       i = (i%38)+1
    end
    for j = 1,math.random(10) do
       spin_step(monitor,i,wheel_grid)
       sleep(0.2)
       i = (i%38)+1
    end
    for j = 1,math.random(5) do
       spin_step(monitor,i,wheel_grid)
       sleep(0.3)
       i = (i%38)+1
    end
    print(i)
end

function spin_step(monitor,i,grid)
    highlightSquare(monitor, colors.brown,table.unpack(grid[(i-1)%38 + 1]))
    highlightSquare(monitor, colors.white,table.unpack(grid[i%38 + 1]))
end
