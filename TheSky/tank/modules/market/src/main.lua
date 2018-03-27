return function(controller)
    print("market module")
    local MainView = require("market.src.MarketDialog").new()
    controller:addChild(MainView)
end
