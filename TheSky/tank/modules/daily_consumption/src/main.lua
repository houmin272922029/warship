return function(controller)
    local MainView = require("daily_consumption.src.Dialog").new()
    controller:addChild(MainView)
end

