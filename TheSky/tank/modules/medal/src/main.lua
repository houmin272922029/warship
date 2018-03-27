return function(node)
    local controller = require("medal.src.MainViewController").new()
    node:startController(controller)
end
