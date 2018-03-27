return function(command)
    local MainView = require("recharge_duty.src.MainDialog").new()
    command:addChild(MainView)
end
