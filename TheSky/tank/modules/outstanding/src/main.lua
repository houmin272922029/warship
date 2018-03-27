return function(controller)
    local dialog = require("outstanding.src.MainDialog").new()
    dialog:addTo(controller)
end
