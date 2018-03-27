return function(node)
    local controller = require("service_faction_war.src.MainViewController").new()
    node:startController(controller)
end