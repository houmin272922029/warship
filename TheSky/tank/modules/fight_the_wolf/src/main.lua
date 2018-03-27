--[[
	战狼归来
	
	
]]

return function(controller)
    local service = require("fight_the_wolf.src.Service")
    service:getInfo(function()
        local MainDialog = require("fight_the_wolf.src.MainDialog").new()
        MainDialog:addTo(controller, 0)
        MainDialog:render()
    end)

end


