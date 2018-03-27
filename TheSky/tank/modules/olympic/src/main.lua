return function(command)
    print("olympic module")

    local controller = require("olympic.src.OlympicController").new()
    command:startController(controller)
end