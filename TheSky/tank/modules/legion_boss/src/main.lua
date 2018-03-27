return function(command)
    print("legion_boss module")

    local controller = require("legion_boss.src.LegionBossController").new()
    command:startController(controller)
end
