--[[
	战狼归来
	
	
]]

return function(controller)
    local service = require("time_limit_spike.src.Service")
    service:getInfo(function()
        local MainDialog = require("time_limit_spike.src.MainDialog").new()
        MainDialog:addTo(controller, 0)
    end)

end


