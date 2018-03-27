return function(command)
	local controller = require("inter_service_arena.src.MainController").new()
    command:startController(controller)
end
