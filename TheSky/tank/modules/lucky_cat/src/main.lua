return function(controller)
    print("lucky_cat module")
    local dialog = require("lucky_cat.src.MainDialog").new()
    controller:addChild(dialog)
end
