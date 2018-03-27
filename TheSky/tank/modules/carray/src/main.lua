return function(command)
	local controller = require("carray.src.MainController").new()
    command:startController(controller)
end
