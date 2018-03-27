return function(controller)
    print("grouppurchase module")
    local dialog = require("grouppurchase.src.MainView").new()
    dialog:addTo(controller)
end