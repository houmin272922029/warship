return function(command)
	local MainView = require("limit_reinforce.src.SingleRechargeDialog").new()
    command:addChild(MainView)
end
