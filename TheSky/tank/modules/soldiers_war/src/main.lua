return function(command)
	local controller = require("soldiers_war.src.MainController").new()
    command:startController(controller)
end
