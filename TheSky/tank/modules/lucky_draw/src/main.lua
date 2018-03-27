return function(controller)
    print("lucky_cat module")
    local dialog = require("lucky_draw.src.MainDialog").new()
    controller:addChild(dialog)
end
