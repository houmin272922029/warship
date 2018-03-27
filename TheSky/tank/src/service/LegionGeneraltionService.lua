--[[

]]--

local LegionGeneraltionService = qy.class("LegionGeneraltionService", qy.tank.service.BaseService)

local model =  qy.tank.model.LegionGeneraltionModel
local userModel = qy.tank.model.UserInfoModel




--[[
    领取界面的奖励
]]--
function LegionGeneraltionService:GetgetawardData(type,id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "activity.getaward",
        ["p"] = {["activity_name"] = "legion_mobilization",
                ["type"]=type,
                ["id"]=id,
                ["kid"]=userModel.userInfoEntity.kid}
    })):send(function(response, request)
        callback(response.data)
    end)
end



return LegionGeneraltionService
