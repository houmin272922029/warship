--[[
	
	Author: 
]]

local HappyFiveDayService = qy.class("HappyFiveDayService", qy.tank.service.BaseService)

local model = qy.tank.model.HappyFiveDayModel


function HappyFiveDayService:getaward(task_id, callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "may_pleasure", ["id"] = task_id}
    })):send(function(response, request)
        model:update(task_id)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
        callback()
    end)
end


return HappyFiveDayService



