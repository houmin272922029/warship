
 --[[
	Author: fq
	Date: 2016年08月05日15:02:10
]]

local SeriesRecharge = qy.class("SeriesRecharge", qy.tank.service.BaseService)

local model = qy.tank.model.SeriesRechargeModel



-- 获取
function SeriesRecharge:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "series_recharge"}
    })):send(function(response, request)
       model:init(response.data)
       callback(response.data)
    end)
end



function SeriesRecharge:getAward(callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "series_recharge"}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end




return SeriesRecharge



