return function(command)
	local service = qy.tank.service.YouChooseMeService
	service:getInfo(function()
        local MainView = require("you_choose_me.src.MainDialog").new()
    	command:addChild(MainView)
    end)

    -- local MainView = require("you_choose_me.src.MainDialog").new()
    -- command:addChild(MainView)
end
