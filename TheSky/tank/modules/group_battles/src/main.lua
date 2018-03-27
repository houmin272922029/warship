return function(command)
	local MainView = require("group_battles.src.GroupBattlesLayer").new()
    command:addChild(MainView)
end