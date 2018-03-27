return function(node)
    local controller = require("endless_war.src.MainViewController").new()
    node:startController(controller)
end
