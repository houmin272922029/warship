return function(command)
	local MainView = require("break_fireline.src.MainDialog").new()
    command:addChild(MainView)
end