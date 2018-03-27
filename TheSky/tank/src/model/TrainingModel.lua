--[[
    训练场 model
    Author: H.X.Sun
    Date:
]]
local TrainingModel = qy.class("TrainingModel", qy.tank.model.BaseModel)

local selectExpCard = {1, 5, 50, 500}--经验卡数

--训练场数据初始化
function TrainingModel:getTrainList(data)
    self.trainList = {}
    self.fee = data.fee
    self.rapidCost = data.times
    self:updateRapidCost()
    local idx = 0
    local entity = nil
    for key, var in pairs(data.train) do
        --将 "p_1" 转为 1
        idx = self:changePosToIndex(key)
        data.train[key].train_index = idx
        entity = qy.tank.entity.TrainAreaEntity.new(data.train[key])
        self.trainList[idx] = entity
    end
    self:setUpgradeBtnStatus()
end

function TrainingModel:setUpgradeBtnStatus()
    local hasLock = false
    for i = 1, #self.trainList do
        if self.trainList[i].train_status == -1 then
            if hasLock then
                self.trainList[i]:setBtnStatus(- 2)
            else
                hasLock = true
                self.trainList[i]:setBtnStatus(- 1)
            end
         elseif self.trainList[i].quality == 5 then
            self.trainList[i]:setBtnStatus(- 2)
        end
    end
end

--解锁或升级后更新某个训练位的信息
function TrainingModel:updateOneAreaInfo(data, trainIdx)
    local entity = self.trainList[trainIdx]
    if data.train["p_" ..trainIdx] then
        entity:update(data.train["p_" ..trainIdx])
        self:setUpgradeBtnStatus()
    end

end

--开始训练
function TrainingModel:beginTrainInfo(data, trainIdx, tankUid)
    self:updateOneAreaInfo(data, trainIdx)
    qy.tank.model.GarageModel:updateEntityData(data.tank["" ..tankUid])
end

--停止或领取
function TrainingModel:stopTrainOrReceiveInfo(data, trainIdx, tankUid)
    self:updateOneAreaInfo(data, trainIdx)
    self.receive = data.exp
    self.receive.add_fight_power = data.add_fight_power
    if data.crit_exp == nil then
        self.receive.crit_exp = 0
    else
        self.receive.crit_exp = data.crit_exp
    end
end

--批量突飞
function TrainingModel:massRapidIfo(data)
    self.receive = data.exp
    self.receive.add_fight_power = data.add_fight_power
    if data.crit_exp == nil then
        self.receive.crit_exp = 0
    else
        self.receive.crit_exp = data.crit_exp
    end
    self.separateTank = {}
    local tankData = {}
    for key ,var in pairs(data.tank) do
        if data.tank[key].quality > 3 and data.tank[key].level == 1 then
            tankData.name = data.tank[key].name
            tankData.quality = data.tank[key].quality
            table.insert(self.separateTank, tankData)
        end
    end
end

--切割字符串
function TrainingModel:stringSplit(str, splitChar)
    local subStrTab = {};
    while (true) do
        local pos = string.find(str, splitChar);
        if (not pos) then
            subStrTab[#subStrTab + 1] = str;
            break;
        end
        local subStr = string.sub(str, 1, pos - 1);
        subStrTab[#subStrTab + 1] = subStr;
        str = string.sub(str, pos + 1, #str);
    end

    return subStrTab;
end

--获取本次训练完成后可取得的经验
function TrainingModel:getCurTrainExp(selectTankIdx)
    local trainIdx = qy.tank.model.GarageModel.totalTanks[selectTankIdx].train_pos
    return self.trainList[tonumber(string.sub(trainIdx, 3, string.len(trainIdx)))].exp
end

--获取突飞的经验值 等级 * 2600 / 4
function TrainingModel:getRapidExp(selectTankIdx)
    local curTankLevel = qy.tank.model.GarageModel.totalTanks[selectTankIdx].level
    return curTankLevel * 2600 / 4
end

--是否有足够的钻石
function TrainingModel:isEnoughDiamondToTrain()
    if qy.tank.model.UserInfoModel.userInfoEntity.diamond - self.rapidCost >= 0 then
        return true
    else
        return false
    end
end

--[[--
--当前坦克是否经验值已足够
--@param #table tankEntity 坦克实体
--@param #number rapidExp 突飞经验
--]]
function TrainingModel:isCurTankExpFull(tankEntity, rapidExp)
    self.userLevel = qy.tank.model.UserInfoModel.userInfoEntity.level
    self.userExp = qy.tank.model.UserInfoModel.userInfoEntity.exp
    local curTankLevel = tankEntity.level
    local curTankExp = tankEntity.exp
    local differenceExp = 0
    if rapidExp == nil then
        rapidExp = 0
    end
    for i = curTankLevel, self.userLevel - 1 do
        differenceExp = differenceExp + self:getUpgradeExp(i)
    end
    differenceExp = differenceExp + self.userExp + rapidExp
    if differenceExp > 0 then
        return false
    else
        return true
    end
end

--是否有足够的资金训练
function TrainingModel:isEnoughMoneyToTrain(selectCostIdx)
    local extra = 0
    local trainFee = self:getTrainFee()
    if selectCostIdx == 1 or selectCostIdx == 2 then
        extra = qy.tank.model.UserInfoModel.userInfoEntity.silver - trainFee[selectCostIdx]
    else
        extra = qy.tank.model.UserInfoModel.userInfoEntity.diamond - trainFee[selectCostIdx]
    end
    if extra < 0 then
        return false
    else
        return true
    end
end

--[[--
--获取下一次突飞的花费
--]]
function TrainingModel:getNextRapidCost()
    return self.rapidCost .. qy.TextUtil:substitute(31001)
end

--[[--
--更新突飞猛进的花费
--]]
function TrainingModel:updateRapidCost()
    if self.rapidCost < 25 then
        self.rapidCost = self.rapidCost + 1
    else
        self.rapidCost = 25
    end
end

-- [[--
-- 是否可以选择该经验卡
--@param #number differenceExp 相差经验数
--@param #number expCardNum 经验卡数
--@param #number idx table下标
--@return 是否可以选择
-- ]]
function  TrainingModel:canSelectCard(differenceExp, expCardNum, idx)
    if differenceExp - selectExpCard[idx]  *  500  > 0 and expCardNum - selectExpCard[idx]  > 0 then
        return  true
    else
        return false
    end
end

--[[--
--是否有足够的经验卡
--@param #string 类型 card
--@param #number idx table下标
--]]
function TrainingModel:isEnoughExpCard(idx)
    local selectCardNum = 0
    if self.cellTick == nil then
        return false
    end
    for i = 1, #self.cellTick do
        if self.cellTick[i] == 1 then
            selectCardNum = selectCardNum + selectExpCard[i]
        end
    end
    selectCardNum = selectCardNum + selectExpCard[idx]
    local curCardNum = qy.tank.model.UserInfoModel.userInfoEntity.expCard

    if curCardNum - selectCardNum >= 0 then
        return true
    else
        return false
    end
end

--[[--
--一键选择方案
--]]
function TrainingModel:optimalMassRapidScheme(selectTankIdx, selectTrainIdx)
    self.cellTick = {}
    local userLevel = qy.tank.model.UserInfoModel.userInfoEntity.level
    local userExp = qy.tank.model.UserInfoModel.userInfoEntity.exp
    local expCardNum = qy.tank.model.UserInfoModel.userInfoEntity.expCard

    if self:isEnoughExpCard(4) then
        self:updataBatchCellTickStatus(4, 1)
    end
    if self:isEnoughExpCard(3) then
        self:updataBatchCellTickStatus(3, 1)
    end
    if self:isEnoughExpCard(2) then
        self:updataBatchCellTickStatus(2, 1)
    end
    if self:isEnoughExpCard(1) then
        self:updataBatchCellTickStatus(1, 1)
    end
end

--[[--
--获取坦克所有的经验
--@param #number targetLevel目标坦克等级
--@param #number targetExp目标坦克经验
--@return 获取坦克所有的经验
--]]
function TrainingModel:getTankAllExp(targetLevel, targetExp)
    local differenceLevel =targetLevel
    if differenceLevel > 5 then
        differenceLevel = differenceLevel - 1
    end
    local differenceExp = 0
    for i = 1, differenceLevel do
        differenceExp = qy.tank.entity.TankEntity:getUpgradeExp(i)
    end

    return  differenceExp + targetExp
end

--[[--
--获取目标坦克和当前选择的坦克经验值的差
--@param #number selectTankIdx 选择的坦克idx
--@param #number targetLevel 目标坦克的等级
--@param #number targetExp 目标坦克的经验
--]]
function TrainingModel:getDifferenceExp(selectTankIdx, targetLevel, targetExp )
    --local tankList = qy.tank.model.GarageModel.noTrainingTanks()
    local curTankLevel = qy.tank.model.GarageModel.totalTanks[selectTankIdx].level
    local curTankExp = qy.tank.model.GarageModel.totalTanks[selectTankIdx].exp
    local differenceLevel =targetLevel - curTankLevel
    local differenceExp = 0
    for i = 1, differenceLevel do
        differenceExp = qy.tank.entity.TankEntity:getUpgradeExp(curTankLevel + i - 1)
    end
    local curTrainExp = self:getCurTrainExp(selectTankIdx)
    return  differenceExp + targetExp - curTankExp - curTankExp
end

--[[--
--更新cell的打钩状态
-- @param #string type 类型("card": 经验卡；"tank":坦克)
--@param #number id id(经验卡ID从1~4, 坦克ID指的时唯一ID)
--@param #number status 当前的打钩icon状态 0：隐藏 1：显示
--]]--
function TrainingModel:updataBatchCellTickStatus(id, status)
    if self.cellTick == nil then
        self.cellTick = {}
    end
    self.cellTick[id] = status
end

--[[--
--获取cell的打钩状态
-- @param #string type 类型("card": 经验卡；"tank":坦克)
--@param #number id id(经验卡ID从1~4, 坦克ID指的是唯一ID)
--@return #number 当前的打钩icon状态 0：隐藏 1：显示
--]]--
function TrainingModel:getBatchCellTickStatus(id)
    if self.cellTick == nil or self.cellTick[id] == nil then
        return 0
    end

    return self.cellTick[id]
end

--[[--
--获取选择数量
--@return #number 当前的打钩显示数
--]]--
function TrainingModel:getSelectTickNum()
    if self.cellTick == nil then
        return 0
    end
    local selectNum = 0
    for i=1,#self.cellTick do
        if self:getBatchCellTickStatus(i) == 1 then
            selectNum = selectNum + 1
        end
    end
    return selectNum
end

--[[--
--获取选中的经验卡列表
--@return 已"|"分隔的经验卡列表
--]]
function TrainingModel:getSelectCardList()
    local sCardList = ""
    if self.cellTick ~= nil then
        for i=1,#self.cellTick do
            if self:getBatchCellTickStatus(i) == 1 then
                sCardList = sCardList .. i .. "|"
            end
        end
    end
    return string.sub(sCardList, 0, string.len(sCardList) - 1)
end

--[[--
--清除一键选择数据
--]]
function TrainingModel:clearChoiceData()
    self.cellTick = {}
end

--[[--
--获取增加的属性
--]]
function TrainingModel:getAddAttribute()
    local allReceive ={}
    local receive = {}
    if self.receive.add_exp > 0 then
        receive = {
            ["value"] = self.receive.add_exp,
            ["url"] = qy.ResConfig.IMG_TANK_EXP
        }
        table.insert(allReceive, receive)
    end

    if self.receive.crit_exp > 0 then
        receive = {
            ["value"] = self.receive.crit_exp,
            ["url"] = qy.ResConfig.IMG_CRIT_HURT
        }
        table.insert(allReceive, receive)
    end

    if self.receive.upgrade_level > 0 then
        receive = {
            ["value"] = self.receive.upgrade_level,
            ["url"] = qy.ResConfig.IMG_TANK_LEVEL,
        }
        table.insert(allReceive, receive)
    end

    if self.receive.attack > 0 then
         receive = {
            ["value"] = self.receive.attack,
            ["url"] = qy.ResConfig.IMG_ATTACK
        }
        table.insert(allReceive, receive)
    end

    if self.receive.defense > 0 then
        receive = {
            ["value"] = self.receive.defense,
            ["url"] = qy.ResConfig.IMG_DEFENSE
        }
        table.insert(allReceive, receive)
    end

    if self.receive.blood > 0 then
         receive = {
            ["value"] = self.receive.blood,
            ["url"] = qy.ResConfig.IMG_BLOOD
        }
        table.insert(allReceive, receive)
    end

    if self.receive.add_fight_power > 0 then
        receive = {
            ["value"] = self.receive.add_fight_power,
            ["url"] = qy.ResConfig.IMG_FIGHT_POWER,
            ["numType"] = 15,
            ["picType"] = 2,
        }
        table.insert(allReceive, receive)
    end

    return allReceive
end

--[[--
--训练费用
--]]
function TrainingModel:getTrainFee()
    local trainFee = {}
    local costFee = 0
    for i = 1, 4 do
        if i < 3 then
            costFee = self.fee[i .. ""].num *  qy.tank.model.UserInfoModel.userInfoEntity.level
        else
            costFee = self.fee[i .. ""].num
        end
        table.insert(trainFee, costFee)
    end
    return trainFee
end

--[[--
--获取训练位实体
--]]
function TrainingModel:getTrainAreaByIdx(index)
    if tonumber(index) then
        -- 1,2,3...
        return self.trainList[index]
    else
        --p_1, p_2, p_3
        return self.trainList[self:changePosToIndex(index)]
    end
end

--[[--
--将p_1转为1
--]]
function TrainingModel:changePosToIndex(sPos)
    return tonumber(string.sub(sPos, 3, string.len(sPos)))
end

--[[--
--获取升级到下一等级需要的经验
--]]
function TrainingModel:getUpgradeExp(nLevel)
    return math.floor(30 * math.pow(nLevel + 1, 2.25) + 0.5)--四舍五入
end

--[[--
--是否有红点
--]]
function TrainingModel:hasRedDot()
    for _k, _v in pairs(self.trainList) do
        if self.trainList[_k]:isCompleted() then
            return true
        end
    end

    return false
end

--[[--倒数--]]
function TrainingModel:setBottomIdx(index)
    self.bottomIdx = #qy.tank.model.GarageModel.totalTanks - index
    -- self.bottomIdx = index
end

function TrainingModel:getBottomIdx()
    if self.bottomIdx then
        return self.bottomIdx
    else
        return -1
    end
end

return TrainingModel
