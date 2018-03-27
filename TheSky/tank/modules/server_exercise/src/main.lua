return function(node)
    local controller = require("server_exercise.src.MainViewController").new()
    node:startController(controller)
end