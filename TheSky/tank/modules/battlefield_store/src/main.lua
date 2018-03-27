return function(command)
    local MainView = require("battlefield_store.src.Dialog").new()
    command:addChild(MainView)
end
