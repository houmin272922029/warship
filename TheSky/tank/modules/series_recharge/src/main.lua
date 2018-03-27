return function(command)
    local MainView = require("series_recharge.src.Dialog").new()
    command:addChild(MainView)
end
