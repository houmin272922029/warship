return function(controller)
    print("torch module")

    local service = require("torch.src.TorchService").new()
    service:get(function()
	    local MianDialog = require("torch.src.TorchDialog").new()
    	MianDialog:addTo(controller, 0)
    end)
end