--[[
	
	
]]

return function(controller)
    local service = qy.tank.service.LegionRechargeService
    service:getInfo(function(data)
        local MainDialog = require("legion_recharge.src.MainDialog").new()
        MainDialog:addTo(controller, 0)
    end)

end


