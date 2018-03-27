

local LegionRechargeService = qy.class("LegionRechargeService", qy.tank.service.BaseService)

local model = qy.tank.model.LegionRechargeModel
-- -- 入口
function LegionRechargeService:getInfo(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "legion_recharge"}
    })):send(function(response, request)
       model:init(response.data.activity_info)
       callback(response.data)
    end)
end
    --领奖
function LegionRechargeService:getAward(id,callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getAward",
       ["p"] = {
                ["activity_name"] = "legion_recharge",
                ["id"] = id
   }
    })):send(function(response, request)
         qy.tank.command.AwardCommand:add(response.data.award)
         qy.tank.command.AwardCommand:show(response.data.award,{["isShowHint"]=false})
       -- model:init(response.data)
        callback(response.data)
    end)
end

    function LegionRechargeService:getNextList(  )
        
    end


return LegionRechargeService
