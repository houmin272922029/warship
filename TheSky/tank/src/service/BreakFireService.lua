--[[
	
	Author: 
]]

local BreakFireService = qy.class("BreakFireService", qy.tank.service.BaseService)

local model = qy.tank.model.BreakFireModel
-- 获取
function BreakFireService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "crossfire"}
    })):send(function(response, request)
       model:init(response.data.activity_info)
       callback(response.data)
    end)
end


function BreakFireService:Goone(callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "crossfire", ["f"] = "z"}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end
function BreakFireService:Goend(callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "crossfire", ["f"] = "y"}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end
function BreakFireService:getAward(id,callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "crossfire", ["f"] = "g",["id"] = id}
    })):send(function(response, request)
        model:update(response.data)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
        callback(response.data)
    end)
end


return BreakFireService



