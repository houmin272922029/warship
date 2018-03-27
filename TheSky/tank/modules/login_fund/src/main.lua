return function(command)
    local MainView = require("login_fund.src.MainDialog").new()
    command:addChild(MainView)
end
