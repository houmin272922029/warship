return function(controller)
    
    local dialog = require("help.src.MainDialog").new()
    -- dialog:show()
    controller:addChild(dialog)
end
