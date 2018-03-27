return function(command)
	local controller = require("offer_a_reward.src.MainController").new()
    command:startController(controller)
end
