return function(controller)
     local MainView = require("taste_war.src.MainDialog").new()
    controller:addChild(MainView)
end
