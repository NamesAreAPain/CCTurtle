Shop = {}
function Shop:new(monitor_price,monitor_bal,router,drive,bankn)
    local t = setmetatable({},{__index = Shop})
    t.price_monitor_name = monitor_price
    t.monitor = peripheral.wrap(monitor_price)
    t.bal_monitor = peripheral.wrap(monitor_bal)
    t.drive = peripheral.wrap(drive)
    rednet.open(router)
    t.bank = bankn
    t.cash_out = ""
    return t
end

function Shop:start()
    self.monitor.setCursorBlink(false)
    self.monitor.setTextScale(1)
    self.monitor.setBackgroundColor(colors.black)
    self.monitor.clear()
    self.bal_monitor.setCursorBlink(false)
    self.bal_monitor.setTextScale(1)
    self.bal_monitor.setBackgroundColor(colors.black)
    self.bal_monitor.clear()
    self:refresh()
    self:inputLoop()
end

function Shop:inputLoop()
    local event = nil 
    while true do
        event = {os.pullEvent()}
        if event[1] == "monitor_touch" then
            if event[2] == self.price_monitor_name and y <= 17 then
                self:redeem()
            end
        elseif event[1] == "disk" then
        elseif event[1] == "disk_eject" then
        elseif event[1] == "turtle_inventory" then
            self:deposit()
        end
        self:refresh()
    end
end

function Shop:redeem()
    local t = refinedstorage.getItems(self.cash_out)
    if t == nil then return "No items available" end
    if t[1].count < 1 then return "No items available" end
    if self:bankWithdraw(getPrice(self.cash_out)) then return "Insufficient Funds" end
    refinedstorage.extractItem(self.cash_out)
    turtle.drop()
    return "Deposit Successful"
end

function Shop:deposit()
    turtle.turnRight()
    local any_items = true
    local t = nil
    while any_items do
        any_items = false
        os.sleep(0.5)
        for i=1,16 do
            t = turtle.getItemDetail(i)
            while t ~= nil do
                any_items = true
                t = getPrice(t.name)
                if t ~= nil then
                    self:bankDeposit(t)
                    self:drawBalScreen()
                end
                turtle.select(i)
                turtle.drop()
            end
        end
    end
    turtle.turnLeft()
    turtle.select(1)
end

function Shop:refresh()
    self:drawPrices()
    self:drawCashOut()
    if self.drive.getDiskID() == nil then
        self:drawInsertID()
    else 
        self:drawBalScreen()
    end
end

function Shop:drawPrices()
    self.monitor.setCursorPos(1,1)
    self.monitor.blit(centerText("EXCHANGE",18),pad(colors.toBlit(colors.orange),18),pad(colors.toBlit(colors.red),18))
    local name = ""
    local item = ""
    local price = 0
    local t = 0
    local max_name = ""
    local max_price = -1
    for i,x in ipairs(fs.list("/prices")) do
       print(i,x)
        self.monitor.setCursorPos(1,2+i)
       name,item = sanitize(getRecord(x))
       price = getPrice(item)
       self.monitor.blit(twoColumns(18,name,price),pad(colors.toBlit(colors.orange),18),pad(colors.toBlit(colors.black),18))
       price = sumPrice(item)
       if price > max_price then
           max_price = price
           max_name = item
       end
    end
    self.cash_out = max_name
end

function Shop:drawCashOut()
    self.monitor.setCursorPos(1,14)
    self.monitor.blit(pad(" ",18),pad(colors.toBlit(colors.white),18),pad(colors.toBlit(colors.purple),18))
    self.monitor.setCursorPos(1,15)
    self.monitor.blit(centerText("REDEEM",18),pad(colors.toBlit(colors.orange),18),pad(colors.toBlit(colors.red),18))
    self.monitor.setCursorPos(1,16)
    self.monitor.blit(centerText(({sanitize(self.cash_out)})[1],18),pad(colors.toBlit(colors.orange),18),pad(colors.toBlit(colors.red),18))
    self.monitor.setCursorPos(1,17)
    self.monitor.blit(pad(" ",18),pad(colors.toBlit(colors.white),18),pad(colors.toBlit(colors.purple),18))
    self.monitor.setCursorPos(1,18)
    self.monitor.blit(centerText("CLICK HERE",18),pad(colors.toBlit(colors.white),18),pad(colors.toBlit(colors.purple),18))
    self.monitor.setCursorPos(1,19)
    self.monitor.blit(pad(" ",18),pad(colors.toBlit(colors.white),18),pad(colors.toBlit(colors.purple),18))
end

function Shop:drawInsertID()
    self.bal_monitor.clear()
    self.bal_monitor.setCursorPos(1,3)
    self.bal_monitor.blit(centerText("Please Insert ID",18),pad(colors.toBlit(colors.orange),18),pad(colors.toBlit(colors.black),18))
end

function Shop:drawBalScreen()
    self.bal_monitor.clear()
    self.bal_monitor.setCursorPos(1,1)
    self.bal_monitor.blit("Balance:",pad(colors.toBlit(colors.white),8),pad(colors.toBlit(colors.purple),8))
    self.bal_monitor.setCursorPos(1,2)
    local bal = self:getBal()
    self.bal_monitor.blit(twoColumns(18,"",bal),pad(colors.toBlit(colors.cyan),18),pad(colors.toBlit(colors.black),18))
end

function Shop:getBal()
    local x = self.drive.getDiskID()
    local y = ""
    if x ~= nil then
        rednet.send(self.bank,"checkbal-"..x)
        x,y = rednet.receive()
        return tonumber(y)
    end
end
function Shop:bankWithdraw(amount)
    rednet.send(self.bank,"withdraw"..self.drive.getDiskID()..amount)
    local x,y = rednet.recieve()
    if y == "ERROR" then
        return true
    end
    return false
end
function Shop:bankDeposit(amount)
    rednet.send(self.bank,"deposit"..self.drive.getDiskID()..amount)
    local x,y = rednet.recieve()
    return false
end

function sanitize(item_name)
    local name = getRecord(item_name)
    local j = 0
    t = string.find(name,":")
    name = string.sub(name,t+1)
    name = name:gsub("_"," ")
    return name,item_name
end

function getRecord(item)
    local itemReadHandle = fs.open("/prices/"..item,"r")
    if itemReadHandle == nil then
        return nil
    end
    local contents = itemReadHandle.readAll()
    contents = split(contents)
    return contents[1], tonumber(contents[2]), tonumber(contents[3]), tonumber(contents[4])
end

function getPrice(item,n)
    local inv = refinedstorage.getItem({name= item})
    if inv[1] == nil then
        return nil
    end
    if n == nil then
        return priceFunction(inv[1].count,getRecord(item))
    else 
        return priceFunction(n,getRecord(item))
    end
end

function sumPrice(item)
    local inv = refinedstorage.getItems({name= item})
    local n = inv[1].count
    local record = table.pack(getRecord(item))
    local total = 0
    for i = 1,n do
        total = total + priceFunction(i,table.unpack(record))
    end
    return total
end


function priceFunction(n,name,pinf,p0,c)
    if pinf == nil then return nil end
    return math.floor((p0-pinf)*math.exp(-1*c*n) + pinf)
end

function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function pad(str,n)
    local out = ""
    for i=1,n do
        out = out..str
    end
    return out
end
function centerText(text,width)
    local len = string.len(text)
    return pad(" ",math.floor((width-len)/2))..text..pad(" ",math.ceil((width-len)/2))
end
function twoColumns(width,left,right)
    local llen = string.len(left)
    local rlen = string.len(right)
    return left..pad(" ",(width-llen-rlen))..right
end
