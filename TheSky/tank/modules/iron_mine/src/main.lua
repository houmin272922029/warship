return function(controller)
    print("iron_mine module")
    local dialog = require("iron_mine.src.MainDialog").new()

    controller:addChild(dialog)
end
