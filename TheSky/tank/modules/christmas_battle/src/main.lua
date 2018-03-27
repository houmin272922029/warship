

return function(controller)
    local service = qy.tank.service.ChristmasBattleService
    service:getInfo(function(data)
        local MainDialog = require("christmas_battle.src.MainDialog").new(data)
        MainDialog:addTo(controller, 0)
    end)
end


