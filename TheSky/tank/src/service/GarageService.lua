--[[
	车库服务器
	Author: Aaron Wei
	Date: 2015-03-20 10:39:36
]]

local GarageService = qy.class("GarageService", qy.tank.service.BaseService)

GarageService.model = qy.tank.model.GarageModel
GarageService.fightJapanModel = qy.tank.model.FightJapanGarageModel

-- 主接口
function GarageService:getMainData(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "user.main",
        ["p"] = {}
    })):send(function(response, request)
        self.model:init(response.data)
        callback(response.data)
    end)
end

-- -- 添加or更换战车
-- function GarageService:change(p,uid,callback)
--     qy.Http.new(qy.Http.Request.new({
--         ["m"] = "formation.change",
--         ["p"] = {position="p_"..p,unique_id=uid}
--     })):send(function(response, request)
--         self.model:updateFormation(response.data)
--         callback(response.data)
--     end)
-- end

-- -- 布阵
-- function GarageService:deploy(param, callback)
--     qy.Http.new(qy.Http.Request.new({
--         ["m"] = "formation.deploy",
--         ["p"] = {}
--     })):send(function(response, request)
--         self.model:updateFormation(response.data)
--         callback(response.data)
--     end)
-- end

-- 布阵
function GarageService:adjust(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "formation.adjust",
        ["p"] = param
    })):send(function(response, request)
        if self:isForFightJapan() then

            self.fightJapanModel:updateTankListBySerData(response.data.tank)
            self.fightJapanModel:updateFormation(response.data)
        else
             self.model:updateTankListBySerData(response.data.tank)
            self.model:updateFormation(response.data)
        end
       
        -- qy.tank.model.EquipModel:loadEquip(response.data)
        callback()
    end)
end

function GarageService:lineup(type,line,param1,param2,onSuccess,onError,ioError)
    local ftype = type
    if self:isForFightJapan() then
        ftype = 2
    else
        ftype = 1
    end
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "formation.lineup",
        ["p"] = {["type"]=ftype,["lineup_type"]=line,["param1"]=param1,["param2"]=param2,["ftue"] = qy.GuideModel:getCurrentBigStep()}
    }))
    :setShowLoading(false)
    :send(function(response, request)
        if self:isForFightJapan() then
            self.fightJapanModel:updateTankListBySerData(response.data.tank)
            self.fightJapanModel:updateFormation(response.data)
        else
            self.model:updateTankListBySerData(response.data.tank)
            self.model:updateFormation(response.data)
           
        end
        qy.tank.model.EquipModel:loadEquip(response.data)
        qy.QYPlaySound.playEffect(qy.SoundType.FORMATION_CHANGE)
        --更新科技武装
        qy.tank.model.TechnologyModel:init2(response.data)
        --更新勋章
        if response.data.medal then
            qy.tank.model.MedalModel:removetankmedal(response.data.medal)
        end
        --更新配件
        if response.data.fittings then
            qy.tank.model.FittingsModel:removetankfittings(response.data.fittings)
        end
        onSuccess()
    end,onError,ioError)
end

-- 判断是否为抗日远征专属
function GarageService:isForFightJapan()
    return qy.tank.model.UserInfoModel.isInFightJapan
end

--鼠式晋升
function GarageService:Promotion(id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"]= "tank.get_promotion",
        ["p"]=  {["unique_id"]= id}
    })):send(function(response, request)
        GarageService.model:init2(response.data)
        callback()
    end)
end

function GarageService:GetPromotion(id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"]= "tank.promotion",
        ["p"]=  {["unique_id"]= id}
    })):send(function(response, request)
        print("GarageService000",response.data.tank[tostring(id)].quality)
        GarageService.model:updateEntityData(response.data.tank[tostring(id)])

        callback(response.data.tank[tostring(id)].tank_id)
    end)
end

return GarageService



