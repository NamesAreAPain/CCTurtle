function drawCircle(cX,cY,radius,color)
    local radius = math.pi * r
    for i = 1,360 do
        local x = math.sin(radius*i)
        local y = math.cos(radius*i)
        paintutils.drawLine(cX,cY,cX+x,xY+y,colors.red)
    end
end
