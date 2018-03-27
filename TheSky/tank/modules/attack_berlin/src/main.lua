return function(command)
	local controller = require("attack_berlin.src.MainController").new()
    command:startController(controller)
end
