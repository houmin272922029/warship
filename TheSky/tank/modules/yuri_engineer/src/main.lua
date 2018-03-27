return function(command)
	local MainView = require("yuri_engineer.src.Dialog").new()
    command:addChild(MainView)
end
