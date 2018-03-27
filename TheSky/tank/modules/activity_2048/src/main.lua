return function(controller)
    local MainView = require("activity_2048.src.Dialog").new()
    controller:addChild(MainView)
end
