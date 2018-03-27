--[[
	每日福利
	
	
]]

return function(controller)
    local service = require("daily_snap_up.src.Service")
    service:getInfo(function()
        local MainDialog = require("daily_snap_up.src.MainDialog").new()
        MainDialog:addTo(controller, 0)
       
    end)

end


