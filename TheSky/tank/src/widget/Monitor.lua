--[[
    监控器
    Author: Your Name
    Date: 2015-04-09 17:22:48
]]

local Monitor = class("Monitor",function()
    return cc.Node:create()
end)

function Monitor:ctor()
    -- RAM
    self.ram = cc.Label:createWithSystemFont(self:getRam(),"Helvetica", 20.0,cc.size(200,0))
    self.ram:setTextColor(cc.c4b(0,255,0,255))
    self.ram:setAnchorPoint(0,1)
    self.ram:setPosition(0,0)
    self:addChild(self.ram)

    -- CPU
    -- GL VERTS
    -- GL CALLS
    -- FPS
    -- RENDER TIME

end

function Monitor:start()
    self.listener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function()
        self.ram:setString(self:getRam())
    end)
end

function Monitor:stop()
    qy.Event.remove(self.listener)
end

function Monitor:getRam()
    if collectgarbage("count") >= 1000000 then
        -- GB
        return "RAM: "..(math.ceil(collectgarbage("count")/1000000*10000)/10000).."GB"
    elseif collectgarbage("count") < 1000000 and collectgarbage("count") >= 1000 then
        -- MB
        return "RAM: "..(math.ceil(collectgarbage("count")/1000*10000)/10000).."MB" 
    elseif collectgarbage("count") < 1000 and collectgarbage("count") >= 1 then
        -- KB
        return "RAM: "..(math.ceil(collectgarbage("count")*10000)/10000).."KB" 
    elseif collectgarbage("count") < 1 then
        -- K
        return "RAM: "..math.ceil(collectgarbage("count")*1000).."B"
    end
end

return Monitor
