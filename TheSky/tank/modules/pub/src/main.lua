return function(controller)
    print("pub module")

    local MianDialog = require("pub.src.MainDialog").new()
    MianDialog:addTo(controller, 1000)
end
