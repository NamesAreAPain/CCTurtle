Shop = {}
function Shop:new(monitor,router,bankn)
    local t = setmetatable({},{__index = Shop})
    t.monitor = peripheral.wrap(monitor)
    rednet.open(router)
    t.bank = bankn
    t.cash_out = ""
    return t
end

function Shop:start()
    self.monitor.setCursorBlink(false)
    self.monitor.setTextScaling(1)
    self.monitor.setBackgroundColor(colors.black)
end

function Shop:refresh()
    self:drawPrices()
    self:drawCashOut()
end

function Shop:drawPrices()
    self.monitor.setCursorPos(1,1)
    self.monitor.blit(center("EXCHANGE",18),pad(colors.toBlit(colors.orange),18),pad(colors.toBlit(colors.red),18))
    local name = ""
    local item = ""
    local price = 0
    local t = 0
    local max_name = ""
    local max_price = ""
    for i,x in ipairs(fs.list("/prices")) do
       self.setCursorPos(1,1+i)
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

function drawCashOut()
    self.monitor.setCursor(1,15)
    self.monitor.blit(center("REDEEM",18),pad(colors.toBlit(colors.orange),18),pad(colors.toBlit(colors.red),18))
    self.monitor.setCursor(1,16)
    self.monitor.blit(center(({sanitize(self.name)})[1],18),pad(colors.toBlit(colors.orange),18),pad(colors.toBlit(colors.red),18))
    self.monitor.setCursor(1,17)
    self.monitor.blit(pad(" ",18),pad(colors.toBlit(colors.white),18),pad(colors.toBlit(colors.purple),18))
    self.monitor.setCursor(1,18)
    self.monitor.blit(center("CLICK HERE",18),pad(colors.toBlit(colors.white),18),pad(colors.toBlit(colors.purple),18))
    self.monitor.setCursor(1,19)
    self.monitor.blit(pad(" ",18),pad(colors.toBlit(colors.white),18),pad(colors.toBlit(colors.purple),18))
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
    local inv = refinedstorage.getItems({name= item})
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
        total = total + priceFunc(i,table.unpack(record))
    end
    return total
end


function priceFunction(n,pinf,p0,c)
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
