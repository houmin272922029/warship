return function(controller)
    print("login_total module")

    local service = require("login_total.src.Service").new()
    service:getInfo(function()
	    local MianDialog = require("login_total.src.MainDialog").new()
    	MianDialog:addTo(controller, 0)
    end)
end
