--[[
	
	Author: 
	Date: 2016年07月13日15:08:24
]]

local LoginFundService = qy.class("LoginFundService", qy.tank.service.BaseService)

local model = qy.tank.model.LoginFundModel
-- 获取
function LoginFundService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "login_fund"}
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end


function LoginFundService:buy(callback, id, day)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "login_fund", ["id"] = id, ["day"] = day}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end



return LoginFundService

