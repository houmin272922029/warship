return function(controller)
    print("head_treasure module")
    local dialog = require("head_treasure.src.MainDialog").new()
    dialog:addTo(controller)
end
