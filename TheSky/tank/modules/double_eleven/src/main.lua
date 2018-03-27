--[[
	双十一活动
]]

return function(controller)

    local service = require("double_eleven.src.Service")
    service:getInfo(function()
        local MainDialog = require("double_eleven.src.MainDialog").new()
        MainDialog:addTo(controller, 0)
    end)

end


