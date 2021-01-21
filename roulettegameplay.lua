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


function drawWaitingForCard(monitor)
    monitor.setTextScale(0.5)
    monitor.setCursorBlink(false)
    monitor.setCursorPos(1,1)
    monitor.setBackgroundColor(colors.green)
    monitor.clear()
    drawRectangle(79,23,colors.green,monitor,"Please Insert Your Identification Card.",colors.green,1,1)
end

function buttons()
    local squares, local twelves, local doubles = boardGrid()
    local buttons = {}
    for i,x in ipairs(squares) do
        squaresToButtons(buttons,table.unpack(x))
    end
    for i,x in ipairs(squares) do
        twelvesToButtons(buttons,table.unpack(x))
    end
    for i,x in ipairs(squares) do
        doublesToButtons(buttons,table.unpack(x))
    end
    return buttons
end

function twelvesToButtons(buttons,num,color,x,y)
    buttons[num] = {
            identify = function(xp,yp)
                return xp >= x+1 and xp <= x+23 and yp >= y+1 and yp <= y+3
            end,
            bet = function(rstation,amount)
                if amount < 10 then
                    return false
                end
                if rstation:wager(amount) then
                    return false
                end
                if rstation.bets[num] ~= nil then
                    rstation.bets[num] = amount + rstation.bets[num]
                else 
                    rstation.bets[num] = amount
                end
                drawChip(rstation.monitor,rstation.bets[num],x+23,y+1)
                return true
            end,
            odds = 3,
            name = num
        }
end

function doublesToButtons(buttons,num,color,x,y)
    buttons[num] = {
            identify = function(xp,yp)
                return xp >= x+1 and xp <= x+11 and yp >= y+1 and yp <= y+3
            end,
            bet = function(rstation,amount)
                if amount < 10 then
                    return false
                end
                if rstation:wager(amount) then
                    return false
                end
                if rstation.bets[num] ~= nil then
                    rstation.bets[num] = amount + rstation.bets[num]
                else 
                    rstation.bets[num] = amount
                end
                drawChip(rstation.monitor,rstation.bets[num],x+11,y+1)
                return true
            end,
            odds = 2,
            name = num
        } 
end

function squaresToButtons(buttons,x,y,num,oddity,color)
    local edge_name = ""
    buttons[num] = {
            identify = function(xp,yp)
                return xp >= x+1 and xp <= x+5 and yp >= y+1 and yp <= y+3
            end,
            bet = function(rstation,amount)
                if amount < 1 then
                    return false
                end
                if rstation:wager(amount) then
                    return false
                end
                if rstation.bets[num] ~= nil then
                    rstation.bets[num] = amount + rstation.bets[num]
                else 
                    rstation.bets[num] = amount
                end
                drawChip(rstation.monitor,rstation.bets[num],x+5,y+1)
                return true
            end,
            odds = 36,
            name = num
        }
    if num == "0" or tonumber(num)%3 ~= 0 then
        if num == "0" then
            edge_name = "0-00"
        else 
            edge_name = num.."-"..(tonumber(num)+1)
        end
        buttons[edge_name] = {
                identify = function(xp,yp)
                    return xp >= x+2 and xp <= x+4 and yp == y
                end,
                bet = function(rstation,amount)
                    if amount < 1 then
                        return false
                    end
                    if rstation:wager(amount) then
                        return false
                    end
                    if rstation.bets[edge_name] ~= nil then
                        rstation.bets[edge_name] = amount + rstation.bets[edge_name]
                    else 
                        rstation.bets[edge_name] = amount
                    end
                    drawChip(rstation.monitor,rstation.bets[num],x+3,y)
                    return true
                end,
                odds = 18,
                name = edge_name
            }
    end
    if num ~= "0" and num ~= "00" and tonumber(num) <= 33 then
        edge_name = num.."-"..(tonumber(num)+3)
        buttons[edge_name] = {
                identify = function(xp,yp)
                    return xp == x+6 and yp == y+2 
                end,
                bet = function(rstation,amount)
                    if amount < 1 then
                        return false
                    end
                    if rstation:wager(amount) then
                        return false
                    end
                    if rstation.bets[edge_name] ~= nil then
                        rstation.bets[edge_name] = amount + rstation.bets[edge_name]
                    else 
                        rstation.bets[edge_name] = amount
                    end
                    drawChip(rstation.monitor,rstation.bets[num],x+6,y+2)
                    return true
                end,
                odds = 18,
                name = edge_name
            }
    end
    if num ~= "0" and num ~= "00" and tonumber(num)%3 ~= 0 and tonumber(num) <= 33 then
        edge_name = num.."-"..(tonumber(num)+1).."-"..(tonumber(num)+3).."-"..(tonumber(num+4))
        buttons[edge_name] = {
                identify = function(xp,yp)
                    return xp == x+6 and yp == y 
                end,
                bet = function(rstation,amount)
                    if amount < 1 then
                        return false
                    end
                    if rstation:wager(amount) then
                        return false
                    end
                    if rstation.bets[edge_name] ~= nil then
                        rstation.bets[edge_name] = amount + rstation.bets[edge_name]
                    else 
                        rstation.bets[edge_name] = amount
                    end
                    drawChip(rstation.monitor,rstation.bets[num],x+6,y)
                    return true
                end,
                odds = 9,
                name = edge_name
            }
    end
end

RStation = {}
function RStation:new(monitor,drive)
    local t = setmetatable({},{__index = Turtle})
    t.monitor_name = monitor
    t.monitor = peripheral.wrap(monitor)
    t.drive_name = drive
    t.drive = peripheral.wrap(drive)
    t.user = nil
    t.selected_amount = 0
    t.bets = {}
    t.master = nil
    return t
end

function RStation:refresh()
    if self.drive.getDiskID() == nil then
        self:idEjected()
    end
    self.bets = {}
    drawBoard(self.monitor)
    drawInfoBar(self.monitor,self:getBal())
end

function RStation:idEjected()
    self.user = nil
    drawWaitingForCard(self.monitor)
end

function RStation:idInserted()
    self.user = self.drive.getDiskID()
    drawBoard(self.monitor)
end

function RStation:userInput(x,y)
    for i,z in ipairs(buttons()) do
        if z.identify(x,y) then
            if self.selected_amount > z.minimum_bet then
                return z.bet(self,self.selected_amount)
            end
            break
        end
    end
    for i,z in ipairs(chips) do
        if z.identify(x,y) then
            self.selected_amount = z.val
        end
    end
end

function RStation:resolveBets()
    local wagers = buttons()
    for i,x in ipairs(self.bets) do
       self:win(wagers[i].odds*x)
    end
end

function RStation:wager(amount)
    local x = self.master:bankMsg("withdraw-"..self.user.."-"..amount)
    return x == "ERROR"
end

function RStation:win(amount)
    self.master:bankMsg("deposit-"..self.user.."-"..amount)
end

function RStation:getBal()
    return tonumber(self.master:bankMsg("checkbal-"..self.user))
end

Roulette = {}
function Roulette:new(wheel_monitor,bank_modem,bank_n,station_list)
    local t = setmetatable({},{__index = Turtle})
    t.modem = bank_modem
    t.bank = bank_n
    rednet.open(bank_modem)
    t.wheel_name = wheel_monitor
    t.wheel = peripheral.wrap(wheel_monitor)
    drawWheel(t.wheel)
    t.stations = station_list
    for i,x in ipairs(station_list) do
        x.master = t
    end
    t.timer = -1
    return t
end

function Roulette:start()
    while true do
        self:waitForInputs()
    end
end


function Roulette:stationFromMonitor(monitor_name)
    for i,x in ipairs(self.stations) do
        if x.monitor_name == monitor_name then
            return x
        end
    end
    return nil
end
function Roulette:stationFromDrive(drive_name)
    for i,x in ipairs(self.stations) do
        if x.drive_name == drive_name then
            return x
        end
    end
    return nil
end

function Roulette:waitForInputs()
    local event = nil 
    while true do
        event = {os.pullEvent()}
        if event[1] == "monitor_touch" then
            if self:stationFromMonitor(event[2]):userInput(tonumber(event[3]),tonumber(event[4])) then
                self.timer = os.startTimer(10)
            end
        elseif event[1] == "disk" then
            self:stationFromDrive(event[2]):idInserted()
        elseif event[1] == "disk_eject" then
            self:stationFromDrive(event[2]):idEjected()
        elseif event[1] == "timer" then
            if event[2] == self.timer then
                self:resolveBets(spin(self.wheel))
                self:refresh()
                break
            end
        end
    end
end

function Roulette:refresh()
    for i,x in ipairs(self.stations) do
        x:refresh()
    end
end

function Roulette:resolveBets()
    for i,x in ipairs(self.stations) do
        x:resolveBets()
    end
end

function Roulette:bankMsg(str)
    rednet.send(self.bank,str)
    local x, local y, local z = rednet.recieve()
    return y
end
