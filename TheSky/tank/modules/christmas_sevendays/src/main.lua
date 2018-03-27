return function(controller)
     local MainView = require("christmas_sevendays.src.MainDialog").new()
    controller:addChild(MainView)
end
