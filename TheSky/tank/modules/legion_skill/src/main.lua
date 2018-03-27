return function(command)
    local controller = require("legion_skill.src.LegionSkillController").new()
    command:startController(controller)
end