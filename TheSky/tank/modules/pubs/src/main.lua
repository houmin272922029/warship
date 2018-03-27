return function(controller)
    print("pubs module")

    local MianDialog = require("pubs.src.MainDialog").new()
    MianDialog:addTo(controller, 1000)
end
