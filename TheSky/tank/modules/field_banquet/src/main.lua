--[[
	每日福利
	
	
]]

return function(controller)
    local service = qy.tank.service.FieldBanquetService
    service:getInfo(function()
        local MainDialog = require("field_banquet.src.MainDialog").new()
        MainDialog:addTo(controller, 0)
       
    end)

end


