return function(command)
    print("worldboss module")

    local controller = require("worldboss.src.WorldBossController").new()
    command:startController(controller)
end
