--[[
    任务
    Author: H.X.Sun
    Date: 2015-05-11
]]

local TaskService = qy.class("TaskService", qy.tank.service.BaseService)

TaskService.model = qy.tank.model.TaskModel

--[[--
--获取任务列表
--@param #table entity 任务实体
--]]
function TaskService:getList(callback) 
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "DailyTask.index",
        ["p"] = {}
    })):send(function(response, request)
        -- self.model:getList(response.data)
        callback(response.data)
    end)
end

--[[--
--获取任务奖励
--@param #table entity 任务实体
--]]
function TaskService:getReward(entity, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "DailyTask.getReward",
        ["p"] = {task_id = entity.task_id, category = entity.category}
    })):send(function(response, request)
        self.model:setReward(response.data)
        callback(response.data)
    end)
end

return TaskService