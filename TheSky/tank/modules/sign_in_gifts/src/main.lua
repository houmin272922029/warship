--[[
	每日好礼
	
	
]]

return function(controller)
    local service = require("sign_in_gifts.src.Service")
    service:getInfo(function()
        local MainDialog = require("sign_in_gifts.src.MainDialog").new()
        MainDialog:addTo(controller, 0)  
    end)

end


