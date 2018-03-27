return function(controller)
    print("hello module")

    local MainView = require("hello.src.MainView").new()
    MainView:addTo(controller, 1000)
end
