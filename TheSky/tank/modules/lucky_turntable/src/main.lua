return function(controller)
    local dialog = require("lucky_turntable.src.MainView").new()
    controller:addChild(dialog)
end
