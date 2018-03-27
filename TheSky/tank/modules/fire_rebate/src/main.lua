return function(controller)
    print("bonus module")
    local dialog = require("fire_rebate.src.MainDialog").new()
    dialog:addTo(controller)
end
