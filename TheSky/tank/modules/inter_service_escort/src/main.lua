return function(command)
	local controller = require("inter_service_escort.src.MainController").new()
    command:startController(controller)
end
