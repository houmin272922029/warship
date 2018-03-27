return function(node)
    local controller = require("god_of_war.src.MianController").new()
    node:startController(controller)
end
