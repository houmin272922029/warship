return function(controller)
    print("pay_rebate_vip module")
    local MainView = require("pay_rebate_vip.src.PayRebateVipDialog").new()
    controller:addChild(MainView)
end
