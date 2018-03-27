return function(controller)
    local dialog = require("newyear_supply.src.MainDialog").new()

    controller:addChild(dialog)
end
