return function(controller)
     local MainView = require("happy_fiveday.src.MainDialog").new()
    controller:addChild(MainView)
end
