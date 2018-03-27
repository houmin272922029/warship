return function(controller)
    print("bonus module")
    local dialog = require("recharge_king.src.MainDialog").new()
    dialog:addTo(controller)
end
