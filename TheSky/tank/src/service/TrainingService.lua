--[[--
--训练场服务器
--add by H.X.Sun
--]]

local TrainingService = qy.class("TrainingService", qy.tank.service.BaseService)

TrainingService.model = qy.tank.model.TrainingModel
local GarageModel = qy.tank.model.GarageModel

--获取训练场信息
function TrainingService:getTrainInfo(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "train.get",
        ["p"] = {}
    })):send(function(response, request)
        self.model:getTrainList(response.data)
        callback(response.data)
    end)
end

--解锁 param trainIdx : 训练位置 tankId
function TrainingService:unLockTrain(trainIdx, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "train.unlock",
        ["p"] = {position = "p_" .. trainIdx}
    })):send(function(response, request)
        self.model:updateOneAreaInfo(response.data, trainIdx)
        callback(response.data)
    end)
end

--升级训练场 param trainIdx : 训练位置 tankId
function TrainingService:updateTrain(trainIdx, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "train.upgrade",
        ["p"] = {position = "p_" .. trainIdx}
    })):send(function(response, request)
        self.model:updateOneAreaInfo(response.data, trainIdx)
        callback(response.data)
    end)
end

--开始训练 param trainIdx : 训练位置 tankUid ： 坦克ID ， type：训练类型
function TrainingService:startTrain(trainIdx, tankUid, nType, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "train.start",
        ["p"] = {["position"] = "p_" .. trainIdx, ["unique_id"] = tankUid, ["type"] = nType,["ftue"] = qy.GuideModel:getCurrentBigStep()}
    })):send(function(response, request)
        self.model:beginTrainInfo(response.data, trainIdx, tankUid)
        callback(response.data)
    end)
end

--终止训练或领取 param trainIdx : 训练位置
function TrainingService:stopTrainOrReceive(trainIdx, tankUid, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "train.draw",
        ["p"] = {position = "p_" .. trainIdx}
    })):send(function(response, request)
        if response.data.tank then
            qy.tank.model.GarageModel:updateEntityData(response.data.tank["" ..tankUid])
        end
        self.model:stopTrainOrReceiveInfo(response.data, trainIdx, tankUid)
        qy.RedDotCommand:emitSignal(qy.RedDotType.M_TRAIN, qy.tank.model.RedDotModel:isTranHasRedDot())
        qy.Event.dispatch(qy.Event.GARAGE_UPDATE)
        callback(response.data)
    end)
end

--突飞猛进 param trainIdx : 训练位置
function TrainingService:rapidTrain(trainIdx,tankUid, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "train.rapid",
        ["p"] = {["position"] = "p_" .. trainIdx,["ftue"] = qy.GuideModel:getCurrentBigStep()}
    })):send(function(response, request)
        if response.data.tank then
            qy.tank.model.GarageModel:updateEntityData(response.data.tank["" ..tankUid])
        end
        self.model:stopTrainOrReceiveInfo(response.data, trainIdx,tankUid)
        self.model:updateRapidCost()
        qy.Event.dispatch(qy.Event.GARAGE_UPDATE)
        callback(response.data)
    end)
end

--批量突飞 param trainIdx : 训练位置
function TrainingService:massRapid(trainIdx, sExpCard, sTankUid, selectTankUid,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "train.massRapid",
        ["p"] = {position = "p_" .. trainIdx, exp_card = sExpCard, tank = sTankUid}
    })):send(function(response, request)
        if response.data.eated_tank then
            for i = 1, #response.data.eated_tank do
                qy.tank.model.GarageModel:removeTank(response.data.eated_tank[i])
            end
        end
        if response.data.tank then
            for key, var in pairs(response.data.tank) do
                qy.tank.model.GarageModel:updateTank(response.data.tank[key])
            end
        end
        self.model:massRapidIfo(response.data)
        qy.Event.dispatch(qy.Event.GARAGE_UPDATE)
        callback(response.data)
    end)
end



--一键批量突飞 param trainIdx : 训练位置
function TrainingService:autoRapid(trainIdx,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "train.autoRapid",
        ["p"] = {position = "p_" .. trainIdx}
    })):send(function(response, request)
        if response.data.eated_tank then
            for i = 1, #response.data.eated_tank do
                qy.tank.model.GarageModel:removeTank(response.data.eated_tank[i])
            end
        end
        if response.data.tank then
            for key, var in pairs(response.data.tank) do
                qy.tank.model.GarageModel:updateTank(response.data.tank[key])
            end
        end
        self.model:massRapidIfo(response.data)
        qy.Event.dispatch(qy.Event.GARAGE_UPDATE)
        callback(response.data)
    end)
end




--坦克改造 param id : 坦克id
function TrainingService:reform(entity,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "tank.reform",
        ["p"] = {["id"] = entity.unique_id}
    })):send(function(response, request)
        if response.data.tank and response.data.tank[tostring(entity.unique_id)] then
            GarageModel:updateEntityData(response.data.tank[tostring(entity.unique_id)])
        end
        callback(response.data)
    end)
end

return TrainingService
