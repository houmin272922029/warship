

local YouChooseMeService = qy.class("YouChooseMeService", qy.tank.service.BaseService)

local model = qy.tank.model.YouChooseMeModel



-- 获取
function YouChooseMeService:getInfo(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "you_choose_i_send"}
    })):send(function(response, request)
       model:init(response.data.activity_info)
       callback(response.data)
    end)
end

function YouChooseMeService:getAward(type,id,callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getAward",
       ["p"] = {
                ["activity_name"] = "you_choose_i_send",
                ["gift_id"] = id,
                ["type"] = type
   }
    })):send(function(response, request)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award,{["isShowHint"]=false})
       model:init(response.data)
       callback(response.data)
    end)
end

return YouChooseMeService



