return function(command)
    local MainView = require("anniver_pay.src.Dialog").new()
    command:addChild(MainView)
end
