--[[
	
	Author: 翻翻乐
	Date: 2016年07月13日15:08:24
]]

local FanFanLeService = qy.class("FanFanLeService", qy.tank.service.BaseService)

local model = qy.tank.model.FanFanLeModel
-- 获取
function FanFanLeService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "fanfanle"}
    })):send(function(response, request)
       model:init(response.data)
       callback(response.data)
    end)
end


function FanFanLeService:getAward(callback, type, status, post)
    --local param = post == nil and {["activity_name"] = "fanfanle", ["type"] = type, ["status"] = status} or {["activity_name"] = "fanfanle", ["type"] = type, ["status"] = status, ["post"] = post}
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "fanfanle", ["type"] = type, ["status"] = status, ["post"] = post or 1}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end
function FanFanLeService:buyAward(status,callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "fanfanle", ["type"] = 201, ["status"] = status}
    })):send(function(response, request)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
        callback(response.data)
    end)
end




function FanFanLeService:updateAward(callback, type)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.restart_fanfanle_award",
       ["p"] = {["activity_name"] = "fanfanle", ["type"] = type}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end


return FanFanLeService



