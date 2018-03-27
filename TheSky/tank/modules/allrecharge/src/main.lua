return function(controller)
    print("allrecharge module")
    local dialog = require("allrecharge.src.MainView").new()
    dialog:addTo(controller)
end
