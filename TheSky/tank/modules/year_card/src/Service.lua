--[[
	季卡年卡
]]
local Service = qy.class("Service", qy.tank.service.BaseService)
Service.model = require("year_card.src.Model")



function Service:getInfo(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"]= "activity.getInfo",
        ["p"]= {["activity_name"]= "year_card"}
    })):send(function(response, request)
        self.model:init(response.data.activity_info)
        callback()
    end)
end

function Service:getAward(index,name,callback)
	local param = {}
	if type(index) == "table" then
		param = index
	else
		param = index == nil and   {["activity_name"] = name} or {["id"] = index, ["activity_name"] = name}
		if param == nil then
			param = {}
		end

		if op then  --精铁矿买用到
			param.op = op
		end
		if category then
			param.category = category
		end
	end

    qy.Http.new(qy.Http.Request.new({
        ["m"]= "activity.getaward",

        ["p"] = param
    })):send(function(response, request) 
    userInfoModel = qy.tank.model.UserInfoModel   
       if response.data.award then			
			print("添加道具")
			qy.tank.command.AwardCommand:add(response.data.award)					
			qy.tank.command.AwardCommand:show(response.data.award,{["critMultiple"] = response.data.weight})
			userInfoModel:updateUserInfo(response.data.award)			
		end
		callback(response.data)        
    end)
 -- qy.Http.new(qy.Http.Request.new({
 --        ["m"]= "activity.getaward",
 --        ["p"]= {["activity_name"]= "year_card",
 --        ["product_id"]= product_id,
 --        ["gift_type"]= gift_type,
 --        ["gift_id"]= gift_id
 --          }
 --    })):send(function(response, request)
 --        qy.tank.command.AwardCommand:add(response.data.award)					
	-- 	qy.tank.command.AwardCommand:show(response.data.award,{["critMultiple"] = response.data.weight})
 --        callback(response.data)        
 --    end)
end

return Service
