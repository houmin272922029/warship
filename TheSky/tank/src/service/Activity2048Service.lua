--[[
	
	Author: 
	Date: 2016年07月13日15:08:24
]]

local Activity2048Service = qy.class("Activity2048Service", qy.tank.service.BaseService)

local model = qy.tank.model.Activity2048Model
-- 获取
function Activity2048Service:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "activity_2048"}
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end


function Activity2048Service:getAward(callback, param)
    param.activity_name = "activity_2048"
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = param
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end



function Activity2048Service:getRankList(callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.get_rank_list",
       ["p"] = {["activity_name"] = "activity_2048", ["pagesize"] = 50, ["page"] = 1}
    })):send(function(response, request)
       model:initRankList(response.data)
       callback(response.data)
    end)
end




return Activity2048Service



