return function(command)
    local MainView = require("battlefield_supply.src.Dialog").new()
    command:addChild(MainView)
end
