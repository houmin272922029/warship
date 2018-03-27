return function(node)
    local controller = require("service_legion_war.src.MainViewController").new()
    node:startController(controller)
end
