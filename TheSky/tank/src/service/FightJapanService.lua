local FightJapanService = qy.class("FightJapanService", qy.tank.service.BaseService)

FightJapanService.model = qy.tank.model.FightJapanModel
FightJapanService.garageModel = qy.tank.model.FightJapanGarageModel

-- 主接口
function FightJapanService:getList(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "expedition.getList",
        ["p"] = {}
    })):send(function(response, request)
        -- self.model:init()
        self.model:initExpeData(response.data)
        self.garageModel:init(response.data)
        -- self.model:updateMap(response.data)
        callback(response.data)
    end)
end

--重新开始
function FightJapanService:restart(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Expedition.reStart",
        ["p"] = {}
    })):send(function(response, request)
        -- self.model:init()
        -- self.model:updateMap(response.data)
        self.model:initExpeData(response.data)
        callback(response.data)
    end)
end

--获取鼓舞数据
function FightJapanService:getEncourage(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "expedition.getEncourage",
        ["p"] = {}
    })):send(function(response, request)
        self.model:updateEncourage(response.data)
        self.model.buyWhiskyCountCurrent = response.data.whisky_buy_times
        callback(response.data)
    end)
end

--鼓舞
function FightJapanService:setEncourage(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "expedition.setEncourage",
        ["p"] = param
    })):send(function(response, request)
        self.model:updateEncourage(response.data)
        callback(response.data)
    end)
end

--购买威士忌
function FightJapanService:buyWhisky(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "expedition.buyWhisky",
        ["p"] = {}
    })):send(function(response, request)
        callback(response.data)
    end)
end


--获取远征商店数据
function FightJapanService:getExchage(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "expedition.expeditionShop",
        ["p"] = {}
    })):send(function(response, request)
    	-- self.model:updateExchange(response.data)
        self.model:updateExpeditionGoodsList(response.data)
        callback(response.data)
    end)
end

--远征商店兑换
function FightJapanService:exchageItem(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "expedition.exchange",
        ["p"] = param
    })):send(function(response, request)
    	self.model:updateExpeditionGoodsList(response.data)
        callback(response.data)
    end)
end

--领取关卡奖励
function FightJapanService:getAwards(index,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Expedition.getAwards",
        ["p"] = {["id"] = index}
    })):send(function(response, request)
        --重置阵位
        self.garageModel:updateFormation({
            ["formation"] = {
                ["p_1"]=0,
                ["p_2"]=0,
                ["p_3"]=0,
                ["p_4"]=0,
                ["p_5"]=0,
                ["p_6"]=0}
            })
        qy.tank.command.AwardCommand:add(response.data.award)
        self.model:updateExDataByIdx(index)
        callback(response.data)
    end)
end

--战斗
function FightJapanService:fight(param , callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Expedition.fight",
        ["p"] = param
    }))
    -- :setShowLoading(false)
    :send(function(response, request)
        if response.data.is_win == 1 then
            self.model:updateExDataByIdx(param.defkid)
        end
        callback(response.data)
    end)
end

--远征布阵
function FightJapanService:getFormation(param , callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Expedition.getFormation",
        ["p"] = param
    })):send(function(response, request)
        -- self.model:updateTankExtendData(response.data)
        self.garageModel:updateFormation(response.data)
        self.garageModel:updateExTankData(response.data.tank_extend_list)
        callback(response.data)
    end)
end

--复活
function FightJapanService:resurrection(tankUid, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Expedition.resurrection",
        ["p"] = {["tankid"] = tankUid}
    })):send(function(response, request)
        self.garageModel:updateExTankData(response.data.tank_extend_list)
        self.model:updateRaisedNum(response.data.fuhuo_times)
        callback(response.data)
    end)
end

return FightJapanService
