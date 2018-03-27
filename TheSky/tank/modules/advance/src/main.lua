return function(controller)
    print("advance module")
    local MainView = require("advance.src.MainView").new(controller)
    controller.viewStack:push(MainView)
end
