return function(node)
    print("soul module")
    local controller = require("soul.src.MainController").new()
    node:startController(controller)
end
