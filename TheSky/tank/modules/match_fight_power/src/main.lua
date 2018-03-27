return function(command)
	local MainView = require("match_fight_power/src/MatchFightPowerDialog").new()
    command:addChild(MainView)
end