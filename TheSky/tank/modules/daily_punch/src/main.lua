return function(controller)
    local MainView = require("daily_punch.src.Dialog").new()
    controller:addChild(MainView)
end

