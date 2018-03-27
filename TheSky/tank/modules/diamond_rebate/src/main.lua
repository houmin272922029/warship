return function(controller)
    local MainView = require("diamond_rebate.src.MainDialog").new()
    controller:addChild(MainView)
end
