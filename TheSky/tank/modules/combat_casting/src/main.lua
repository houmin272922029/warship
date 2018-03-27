return function(controller)
    local MainView = require("combat_casting.src.Dialog").new()
    controller:addChild(MainView)
end

