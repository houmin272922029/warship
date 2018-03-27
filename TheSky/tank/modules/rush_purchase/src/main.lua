--[[
	限时抢购
	Author: Aaron Wei
	Date: 2016-01-27 12:13:29
]]

return function(controller)
    print("rush_purchase module")

    local service = require("rush_purchase.src.Service")
    service:getInfo(function()
        local MainDialog = require("rush_purchase.src.MainDialog").new()
        MainDialog:addTo(controller, 0)
        MainDialog:render()
    end)

    -- local service = require("rush_purchase.src.TorchService").new()
    -- service:get(function()
	   --  local MianDialog = require("rush_purchase.src.MainDialog").new()
    -- 	MianDialog:addTo(controller, 0)
    -- end)
end


