function host(modem_name)
    if not fs.exists("/accounts") then
        fs.makeDir("/accounts")
    end
    local modem = rednet.open(modem_name)
    local sender = 0
    local message = ""
    local protocol = ""
    while true do
        sender,message,protocol = rednet.receive()
        message = split(message,"-")
        if message[1] == "deposit" then
            rednet.send(sender,deposit(message[2],tonumber(message[3])))
        elseif message[1] == "withdraw" then
            rednet.send(sender,withdraw(message[2],tonumber(message[3])))
        elseif message[1] == "checkbal" then
            rednet.send(sender,getBalance(message[2]))
        end
    end
end

function deposit(user,amount)
   local bal = getBalance(user)
   return setBalance(user,bal+amount)
end

function withdraw(user,amount)
    local bal = getBalance(user)
    if bal-amount > 0 then
        return setBalance(user,bal-amount)
    else
        return "ERROR"
    end
end

function getBalance(user)
    local accountReadHandle = fs.open(getPathToUserFile(user),"r")
    local bal = accountReadHandle.readAll()
    accountReadHandle.close()
    return tonumber(bal)
end

function setBalance(user,amount)
    local accountWriteHandle = fs.open(getPathToUserFile(user),"w")
    accountWriteHandle.write(tostring(amount))
    accountWriteHandle.close()
    return amount
end

function getPathToUserFile(user)
    local path = "/account/"..user
    if not fs.exists(path) then
        local accountWriteHandle = fs.open(path,"w")
        accountWriteHandle.write(tostring(0))
        accountWriteHandle.close()
    end
    return path 
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

