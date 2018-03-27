return function(controller)
    local dialog = require("Natasha_gift.src.MainView").new()
    controller:addChild(dialog)
end
