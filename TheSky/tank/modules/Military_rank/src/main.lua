return function(node)
    local controller = require("Military_rank.src.MainViewController").new()
    node:startController(controller)
end