return function(controller)
    print("bonus module")
    local dialog = require("recharge_doyen.src.MainDialog").new()
    dialog:addTo(controller)
end
