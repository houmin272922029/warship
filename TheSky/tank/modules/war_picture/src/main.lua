return function(command)
	local MainView = require("war_picture.src.WarPictureDialog").new()
    command:addChild(MainView)
end


