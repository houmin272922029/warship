return function(command)
	local controller = require("all_servers_group_battles.src.MainController").new()
    command:startController(controller)
end
