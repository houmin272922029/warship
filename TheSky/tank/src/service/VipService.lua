--[[
	VIP服务器
	Author: Aaron Wei
	Date: 2015-06-13 15:49:49
]]

local VipService = qy.class("VipService", qy.tank.service.BaseService)

-- 获取VIP用户信息
function VipService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "recharge.get",
        ["p"] = {}
    })):send(function(response, request)
        callback(response.data)
    end)
end

-- 领取充值奖励
function VipService:drawGiftAward(level,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "recharge.drawGiftAward",
        ["p"] = {["vip_level"]=level}
    })):send(function(response, request)
        callback(response.data)
    end)
end

-- 领取每日奖励
function VipService:drawDailyAward(level,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "recharge.drawDailyAward",
        ["p"] = {["vip_level"]=level}
    })):send(function(response, request)
        -- self.model:updateFormation(response.data)
        callback(response.data)
    end)
end

return VipService



