--[[
	
	Author: 
]]

local MergeCarnialService = qy.class("MergeCarnialService", qy.tank.service.BaseService)

local model = qy.tank.model.MergeCarnialModel


function MergeCarnialService:getaward(task_id, callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "merge_carnival", ["id"] = task_id}
    })):send(function(response, request)
        model:update(task_id)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
        callback()
    end)
end


return MergeCarnialService



