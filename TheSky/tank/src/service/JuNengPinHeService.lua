--[[
	
	Author: 聚能拼合
	Date: 2016年07月13日15:08:24
]]

local JuNengPinHeService = qy.class("JuNengPinHeService", qy.tank.service.BaseService)

local model = qy.tank.model.JuNengPinHeModel
-- 获取
function JuNengPinHeService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "junengpinhe"}
    })):send(function(response, request)
       model:init(response.data)
       callback(response.data)
    end)
end


function JuNengPinHeService:pinhe(callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "junengpinhe"}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end


function JuNengPinHeService:buy(callback, num)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "activity.pay_junengpinhe",
       ["p"] = {["num"] = num}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end


return JuNengPinHeService



