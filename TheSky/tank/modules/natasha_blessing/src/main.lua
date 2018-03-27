return function(controller)
    local dialog = require("natasha_blessing.src.MainView").new()
    controller:addChild(dialog)
end

