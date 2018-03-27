return function(command)
	local MainView = require("sign.src.SignDialog").new()
    command:addChild(MainView)
end
