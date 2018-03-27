return function(command)
	local controller = require("singlehero.src.MainController").new()
    command:startController(controller)
end
