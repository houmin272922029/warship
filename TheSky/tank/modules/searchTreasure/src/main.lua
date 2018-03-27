return function(controller)
    print("searchTreasure module")
    local dialog = require("searchTreasure.src.MainView").new()
    dialog:addTo(controller)
end
