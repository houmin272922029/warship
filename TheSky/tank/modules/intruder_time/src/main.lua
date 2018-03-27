return function(command)
    local MainView = require("intruder_time.src.Dialog").new()
    command:addChild(MainView)
end
