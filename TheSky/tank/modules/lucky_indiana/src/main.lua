return function(controller)
    print("template module")
    local dialog = require("lucky_indiana.src.MainView").new()
    controller:addChild(dialog)
end
