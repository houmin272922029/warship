return function(controller)
    local MainView = require("boil_dumpling.src.Dialog").new()
    controller:addChild(MainView)
end

