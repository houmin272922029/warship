return function(controller)
    local MainView = require("pay_everyday.src.PayEveryDayDialog").new()
    controller:addChild(MainView)
end
