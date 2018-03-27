return function(controller)
     local MainView = require("merge_carnival.src.MainDialog").new()
    controller:addChild(MainView)
end
