return function(controller)
     local MainView = require("collect_dumplings.src.MainDialog").new()
    controller:addChild(MainView)
end
