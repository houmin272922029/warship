return function(controller)
    print("bonus module")
    local dialog = require("earth_soul.src.MainDialog").new()
    dialog:addTo(controller)
end
