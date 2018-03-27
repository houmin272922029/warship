
local Tank918Service = qy.class("Tank918Service", qy.tank.service.BaseService)

Tank918Service.model = qy.tank.model.Tank918Model

--[[--
--获玩家信息
--]]
function Tank918Service:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Once.tank918",
        ["p"] = {}
    })):send(function(response, request)
        self.model:update(response.data)
        callback(response.data)
    end)
end
function Tank918Service:getaward(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Once.tank918award",
        ["p"] = {}
    })):send(function(response, request)
    	if response.data.award then
	        qy.tank.command.AwardCommand:add(response.data.award)
	   		qy.tank.command.AwardCommand:show(response.data.award)
   		end
   		self.model:initstatus(response.data)
        callback(response.data)
    end)
end

return Tank918Service