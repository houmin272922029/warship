--[[
	
	Author: 
	Date: 2016年07月13日15:08:24
]]

local IntruderTimeService = qy.class("IntruderTimeService", qy.tank.service.BaseService)

local model = qy.tank.model.IntruderTimeModel
-- 获取
function IntruderTimeService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "intruder_time"}
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end


function IntruderTimeService:fight(callback, unique)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "intruder_time", ["unique"] = unique}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end

function IntruderTimeService:share(callback, unique)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "intruder_time", ["share"] = 1, ["unique"] = unique}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end

function IntruderTimeService:help(callback, unique)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "intruder_time", ["help"] = 1, ["unique"] = unique}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end


return IntruderTimeService



