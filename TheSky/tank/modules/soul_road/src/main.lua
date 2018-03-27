return function(command)
	local controller = require("soul_road.src.MainController").new()
    command:startController(controller)
end
