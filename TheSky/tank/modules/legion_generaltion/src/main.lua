return function(controller)
    print("bonus module")
    local dialog = require("legion_generaltion.src.MainDialog").new()
    dialog:addTo(controller)
end
