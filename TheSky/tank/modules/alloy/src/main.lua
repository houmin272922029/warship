return function(command)
    print("alloy module")
    local controller = require("alloy.src.AlloyController").new()
    command:startController(controller)
end
