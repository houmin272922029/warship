return function(controller)
    print("template module")
     local dialog = require("happy_nationalday.src.MainDialog").new()
    dialog:addTo(controller)
end
