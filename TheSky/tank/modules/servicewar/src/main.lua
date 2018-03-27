return function(command)
    print("servicewar module")
    local controller = require("servicewar.src.ServiceWarController").new()
    command:startController(controller)
end
