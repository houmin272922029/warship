return function(controller)
    print("template module")
     local dialog = require("recruit_supply.src.MainDialog").new()
    dialog:addTo(controller)
end
