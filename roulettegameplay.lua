require("roulettegraphics")

function spin(monitor)
    local continue = true
    local win = math.random(38)
    local i = 1
    local wheel_grid = wheelGrid()
    for i = 1,100 do
       spin_step(monitor,i,wheel_grid)
       sleep(0.1)
       i = (i%38)+1
    end
    
end

function spin_step(monitor,i,grid)
    highlightSquare(monitor, colors.brown,table.unpack(grid[(i-1)%38 + 1]))
    highlightSquare(monitor, colors.white,table.unpack(grid[i%38 + 1]))
end
