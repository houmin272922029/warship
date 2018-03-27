--[[
	季卡年卡
	
	
]]

return function(controller)
    local service = require("year_card.src.Service")
    service:getInfo(function()
        local MainDialog = require("year_card.src.MainDialog").new()
        MainDialog:addTo(controller, 0)
        
    end)

end


