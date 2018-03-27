return function(controller)
    local MainView = require("kelubo_treasury.src.keluboTreasuryDialog").new()
    controller:addChild(MainView)
end
