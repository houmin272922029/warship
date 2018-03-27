return function(command)
	local MainView = require("beat_enemy.src.BeatEnemyDialog").new()
    command:addChild(MainView)
end


