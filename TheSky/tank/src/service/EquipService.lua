--[[
    装备 service
    Author: H.X.Sun
    Date: 2015-04-18
]]


local EquipService = qy.class("EquipService", qy.tank.service.BaseService)

EquipService.model = qy.tank.model.EquipModel
EquipService.AlloyModel = qy.tank.model.AlloyModel
EquipService.GarageModel = qy.tank.model.GarageModel

--装载装备
function EquipService:loadEquipment(tankUid,  selectEquip, sType, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "equip.equipment",
        ["p"] = {["tank_unique_id"]=tankUid, ["gun"]=selectEquip[1], ["bullet"]=selectEquip[2], ["armor"]=selectEquip[3], ["engine"]=selectEquip[4],
            ["ftue"] = qy.GuideModel:getCurrentBigStep()
        }
    })):send(function(response, request)
        self.model:getOldAttribute(self.GarageModel:getEntityByUniqueID(response.data.tank[tostring(tankUid)].unique_id))
        self.GarageModel:updateTankListBySerData(response.data.tank)
        self.model:loadEquip(response.data, sType)
        self.AlloyModel:updateAlloyPos(response.data.alloy)
        self.model:calculateAddAttributeValues(self.GarageModel:getEntityByUniqueID(response.data.tank[tostring(tankUid)].unique_id), response.data.add_fight_power)
        -- qy.Event.dispatch(qy.Event.GARAGE_UPDATE)
        callback(response.data)
    end)
end

--卸下装备
function EquipService:unload(params,tankUid, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "equip.unload",
        ["p"] = params,
    })):send(function(response, request)
        self.model:getOldAttribute(self.GarageModel:getEntityByUniqueID(response.data.tank[tostring(tankUid)].unique_id))
        self.GarageModel:updateTankListBySerData(response.data.tank)
        self.model:loadEquip(response.data, params.type)
        self.AlloyModel:updateAlloyPos(response.data.alloy)
        self.model:calculateAddAttributeValues(self.GarageModel:getEntityByUniqueID(response.data.tank[tostring(tankUid)].unique_id), response.data.add_fight_power)
        -- qy.Event.dispatch(qy.Event.GARAGE_UPDATE)
        callback(response.data)
    end)
end

--强化装备
function EquipService:strengthenEquip(flag,uniqueId, sType, onSuccess,onError,ioError)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "equip.strengthen",
        ["p"] = {["unique_id"]=uniqueId, ["type"] = sType,["ftue"] = qy.GuideModel:getCurrentBigStep()}
    }))
    :setShowLoading(flag)
    :send(function(response, request)
        self.model:strengthenEquip(response.data, sType, uniqueId)
        qy.RedDotCommand:emitSignal(qy.RedDotType.M_EQUIP, qy.tank.model.RedDotModel:isEquipHasRedDot(), false)
        if not qy.tank.model.RedDotModel:getGarageHasNew() then
            qy.RedDotCommand:emitSignal(qy.RedDotType.M_GARAGE, qy.tank.model.RedDotModel:getGarageRedDot())
        end
        qy.Event.dispatch(qy.Event.GARAGE_UPDATE)
        onSuccess(response.data)
    end,onError,ioError)
end

--强化十次装备
function EquipService:autoStrengthenEquip(flag,uniqueId, sType, onSuccess,onError,ioError)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "equip.autoStrengthen",
        ["p"] = {["unique_id"]=uniqueId, ["type"] = sType,["ftue"] = qy.GuideModel:getCurrentBigStep()}
    }))
    :setShowLoading(flag)
    :send(function(response, request)
        self.model:strengthenEquip(response.data, sType, uniqueId)
        qy.Event.dispatch(qy.Event.GARAGE_UPDATE)
        onSuccess(response.data)
    end,onError,ioError)
end



--改造装备
function EquipService:reformEquip(uniqueId, sType, status, onSuccess)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "equip.equip_reform",
        ["p"] = {["unique_id"]=uniqueId, ["type"] = sType,["status"] = status}
    })):send(function(response, request)
        self.model:strengthenEquip(response.data, sType, uniqueId)
        -- qy.RedDotCommand:emitSignal(qy.RedDotType.M_EQUIP, qy.tank.model.RedDotModel:isEquipHasRedDot(), false)
        -- if not qy.tank.model.RedDotModel:getGarageHasNew() then
        --     qy.RedDotCommand:emitSignal(qy.RedDotType.M_GARAGE, qy.tank.model.RedDotModel:getGarageRedDot())
        -- end
        qy.Event.dispatch(qy.Event.GARAGE_UPDATE)
        onSuccess(response.data)
    end)
end



--进阶装备
function EquipService:advanceEquip(uniqueId, sType, use_id, onSuccess)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "equip.equip_advanced",
        ["p"] = {["unique_id"]=uniqueId, ["type"] = sType,["use_id"] = use_id}
    })):send(function(response, request)
        self.model:strengthenEquip(response.data, sType, uniqueId)
        -- qy.RedDotCommand:emitSignal(qy.RedDotType.M_EQUIP, qy.tank.model.RedDotModel:isEquipHasRedDot(), false)
        -- if not qy.tank.model.RedDotModel:getGarageHasNew() then
        --     qy.RedDotCommand:emitSignal(qy.RedDotType.M_GARAGE, qy.tank.model.RedDotModel:getGarageRedDot())
        -- end
        qy.Event.dispatch(qy.Event.GARAGE_UPDATE)
        onSuccess(response.data)
    end)
end


--装备洗练
function EquipService:clearEquip(uniqueId, sType, onSuccess)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Equip.additionPolish",
        ["p"] = {["unique_id"]=uniqueId, ["type"] = sType}
    })):send(function(response, request)
        self.model:strengthenEquip(response.data, sType, uniqueId)
        onSuccess(response.data)
    end)
end

--洗练保存
function EquipService:saveClearEquip(uniqueId, sType, onSuccess)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Equip.additionPolishSave",
        ["p"] = {["unique_id"]=uniqueId, ["type"] = sType}
    })):send(function(response, request)
        self.model:strengthenEquip(response.data, sType, uniqueId)
        qy.Event.dispatch(qy.Event.GARAGE_UPDATE)
        onSuccess(response.data)
    end)
end
--装备萃取
function EquipService:ExtracterEquip(uniqueId, sType, onSuccess)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Equip.additionExtracter",
        ["p"] = {["unique_id"]=uniqueId, ["type"] = sType}
    })):send(function(response, request)
        onSuccess(response.data)
    end)
end
--装备突破
function EquipService:BrokenEquip(uniqueId, sType, onSuccess)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Equip.additionBroken",
        ["p"] = {["unique_id"]=uniqueId, ["type"] = sType}
    })):send(function(response, request)
        onSuccess(response.data)
    end)
end
--装备修复
function EquipService:RepairEquip(uniqueId, sType, onSuccess)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Equip.additionRepair",
        ["p"] = {["unique_id"]=uniqueId, ["type"] = sType}
    })):send(function(response, request)
        onSuccess(response.data)
    end)
end



return EquipService
