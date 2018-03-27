--【
    -- 幸运转盘
--】

local LuckyTurntableService = qy.class("LuckyTurntableService", qy.tank.service.BaseService)

local model = qy.tank.model.StorageModel
local model1 = qy.tank.model.LuckyTurntableModel
local StorageModel = qy.tank.model.StorageModel
-- 开始
function LuckyTurntableService:openAward(prop_id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "props.useprops",
        ["p"] = {
        ["num"] = 1,
        ["props_id"] = prop_id,
        }
    })):send(function(response, request)
        self:remove(response.data.props)
        callback(response.data)
    end)
end

function LuckyTurntableService:remove( data )
    local Num1 = StorageModel:getPropNumByID(model1.id)
    local Num2 = StorageModel:getPropNumByID(model1.need_id)
    local Num1_1 = 0
    local Num1_2 = 0
    if data[tostring(model1.id)] then
        Num1_1 = data[tostring(model1.id)].num
    end
    if data[tostring(model1.need_id)] then
        Num1_2 = data[tostring(model1.need_id)].num
    end
    model:remove(tostring(model1.id),Num1-Num1_1)
    model:remove(tostring(model1.need_id),Num2-Num1_2)
end
-- 开启十次
function LuckyTurntableService:openTenAward(prop_id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "props.useprops",
        ["p"] = {
        ["num"] = 10,
        ["props_id"] = prop_id,
        }
    })):send(function(response, request)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
        self:remove(response.data.props)
        callback(response.data)
    end)
end
return LuckyTurntableService



