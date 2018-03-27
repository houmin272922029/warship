--[[
	限时抢购
	Author: Aaron Wei
	Date: 2016-01-27 12:13:29
]]

return function(controller)

    local service = require("newrush_purchase.src.Service")
    service:getInfo(function()
        local MainDialog = require("newrush_purchase.src.MainDialog").new()
        MainDialog:addTo(controller, 0)
        MainDialog:render()
    end)

end


