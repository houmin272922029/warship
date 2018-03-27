return function(controller)
    local MainView = require("leap_fund.src.Dialog").new()
    controller:addChild(MainView)
end

