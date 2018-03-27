return function(node)
    local controller = require("strong.src.MianController").new()
    node:startController(controller)
end
