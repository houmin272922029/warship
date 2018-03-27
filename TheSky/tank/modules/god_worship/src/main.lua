return function(controller)
    local MainView = require("god_worship.src.Dialog").new()
    controller:addChild(MainView)
end
