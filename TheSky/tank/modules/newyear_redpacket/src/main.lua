return function(controller)
    local dialog = require("newyear_redpacket.src.MainDialog").new()
    controller:addChild(dialog)
end
