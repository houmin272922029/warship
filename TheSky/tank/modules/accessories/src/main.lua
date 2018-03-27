return function(node)
    local controller = require("accessories.src.MainViewController").new()
    node:startController(controller)
end
