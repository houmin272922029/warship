return function(controller)
    local MainView = require("annual_bonus.src.MainDialog").new()
    controller:addChild(MainView)
end
