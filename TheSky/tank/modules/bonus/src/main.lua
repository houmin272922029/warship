return function(controller)
    print("bonus module")
    local dialog = require("bonus.src.MainDialog").new()
    dialog:addTo(controller)
end
