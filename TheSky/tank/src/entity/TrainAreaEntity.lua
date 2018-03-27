--[[
--训练位
--Author: H.X.Sun
--Date: 2015-05-18
--]]

local TrainAreaEntity = qy.class("TrainAreaEntity", qy.tank.entity.BaseEntity)

local trainModel = qy.tank.model.TrainingModel
local _VipModel = qy.tank.model.VipModel

function TrainAreaEntity:ctor(data)
    -- 训练的坦克唯一ID
    self.tank_unique_id = data.unique_id
    -- -1为锁定状态，0为已开锁状态，1为训练状态
    self:setproperty("train_status", data.status)
    -- 白 绿 蓝 紫 橙
    self:setproperty("quality", data.class)
    -- 训练的开始时间
    self:setproperty("start_time", data.start_time)
    -- 训练的结束时间
    self:setproperty("end_time", data.end_time)
    -- 本次训练可以获得的总经验数
    self:setproperty("exp", data.exp)
    --升级按钮状态
    self.btn_status = data.status
    --位置
    self:setproperty("train_index", data.train_index)
end

--根据品质nClass获取品质背景图路径 param quality:品质(1-5 白 绿 蓝 紫 橙)
function TrainAreaEntity:getQualityBgPath()
    -- 白绿蓝紫橙
    local quality = self.quality
    if tonumber(quality) == 1 then
        return "tank/bg/bg1.png"
    elseif tonumber(quality) == 2 then
        return "tank/bg/bg2.png"
    elseif tonumber(quality) == 3 then
        return "tank/bg/bg3.png"
    elseif tonumber(quality) == 4 then
        return "tank/bg/bg4.png"
    elseif tonumber(quality) == 5 then
        return "tank/bg/bg5.png"
    end
end

--根据品质nClass获取训练位等级 param quality:品质(1-5 白 绿 蓝 紫 橙)
function TrainAreaEntity:getTrainLevelPath()
    local quality = self.quality
    return "Resources/training/train_level_".. quality .. ".png"
end

function TrainAreaEntity:getTankInfo()
    local tankUid = self.tank_unique_id
    local status = self.train_status
    local tankInfo = {}
    if status == 1 then
        --训练状态
        local entity = qy.tank.model.GarageModel:getEntityByUniqueID(tankUid)
        tankInfo.trainAreaSprite = entity:getIcon()
        tankInfo.tankLevel = "LV：" .. entity.level
        tankInfo.tankName = entity.name
        tankInfo.color = qy.tank.utils.ColorMapUtil.qualityMapColor(entity.quality)
        tankInfo.bg = entity:getIconBg()
    elseif status == -1 then
        --锁定状态(训练位为锁)
        tankInfo.trainAreaSprite = "Resources/common/icon/XL_10.png"
        tankInfo.tankLevel = ""
        tankInfo.tankName = ""
    else
        tankInfo.trainAreaSprite = "Resources/common/icon/XL_10.png"
        tankInfo.tankLevel = ""
        tankInfo.tankName = ""
    end
    return tankInfo
end

--获取升级信息
function TrainAreaEntity:getUpgradeInfo()
    local quality = self.quality
    if tonumber(quality) == 1 then
        --1级升到2级
        return {["upgrade_cost"] = 50,["title"] = qy.TextUtil:substitute(37042), ["percentage"] = "150%", ["color"] = cc.c3b(46, 190, 83), ["quality"] = quality + 1}
    elseif tonumber(quality) == 2 then
        --2级升到3级
        return {["upgrade_cost"] = 100,["title"] = qy.TextUtil:substitute(37043), ["percentage"] = "225%", ["color"] = cc.c3b(36, 174, 242),["quality"] = quality + 1}
    elseif tonumber(quality) == 3 then
        --3级升到4级
        return {["upgrade_cost"] = 200,["title"] = qy.TextUtil:substitute(37044), ["percentage"] = "300%", ["color"] = cc.c3b(174, 53, 248),["quality"] = quality + 1}
    elseif tonumber(quality) == 4 then
        --4级升到5级
        return {["upgrade_cost"] = 300,["title"] = qy.TextUtil:substitute(37045), ["percentage"] = "400%", ["color"] = cc.c3b(192, 89, 42),["quality"] = quality + 1}
    end
end

--[[--
--获取训练位状态
--]]
function TrainAreaEntity:getBtnStatus()
    return self.btn_status
end

--[[--
--设置状态
--]]
function TrainAreaEntity:setBtnStatus(nStatus)
    self.btn_status = nStatus
end

--[[--
--是否完成训练
--]]
function TrainAreaEntity:isCompleted()
    if self.tank_unique_id > 0 then
        if self.end_time < qy.tank.model.UserInfoModel.serverTime then
            return true
        else
            return false
        end
    else
        return false
    end
end

--[[--
--获取坦克在战车列表的indx
--]]
function TrainAreaEntity:getTankIndex()
    local tankUid = self.tank_unique_id
    if tankUid > 0 then
        return qy.tank.model.GarageModel:getIndexByUniqueID(tankUid)
    else
        return -1
    end
end

--[[--
--获取解锁条件
--]]
function TrainAreaEntity:getUnlockConditions()
    local index = self.train_index
    --第N个训练位，开启该训练位的vip等级，开启消耗
    local vipLevel = _VipModel:getTrainAreaOpenVipLevelByIndex(tonumber(index))
    if tonumber(index) == 1 then
        return {["vip_level"] = vipLevel, ["unlock_cost"] = 0}
    elseif tonumber(index) == 2 then
        return {["vip_level"] = vipLevel, ["unlock_cost"] = 0}
    elseif tonumber(index) == 3 then
        return {["vip_level"] = vipLevel, ["unlock_cost"] = 50} --v2
    elseif tonumber(index) == 4 then
        return {["vip_level"] = vipLevel, ["unlock_cost"] = 100} --v2
    elseif tonumber(index) == 5 then
        return {["vip_level"] = vipLevel, ["unlock_cost"] = 200} --v3
    elseif tonumber(index) == 6 then
        return {["vip_level"] = vipLevel, ["unlock_cost"] = 200}--v4
    elseif tonumber(index) == 7 then
        return {["vip_level"] = vipLevel, ["unlock_cost"] = 200} --v6
    end
end

--[[--
--已经训练的时间
--]]
function TrainAreaEntity:getTrainedTime()
    return qy.tank.model.UserInfoModel.serverTime - self.start_time
end

--[[--
--剩余时间
--]]
function TrainAreaEntity:getRemainTime()
    return self.end_time - qy.tank.model.UserInfoModel.serverTime
end

--[[--
--训练总时间
--]]
function TrainAreaEntity:getTotalTime()
    return self.end_time - self.start_time
end

--[[--
--本次训练已获得的经验
--]]
function TrainAreaEntity:hasExp()
    return self.exp * (self:getTrainedTime() / self:getTotalTime())
end

--[[--
--更新
--]]
function TrainAreaEntity:update(data)
    -- 训练的坦克唯一ID
    self.tank_unique_id = data.unique_id or self.tank_unique_id
    -- -1为锁定状态，0为已开锁状态，1为训练状态
    self.train_status = data.status or self.train_status
    -- 白 绿 蓝 紫 橙
    self.quality_:set(data.class or self.quality)
    -- 训练的开始时间
    self.start_time_:set(data.start_time or self.start_time)
    -- 训练的结束时间
    self.end_time_:set(data.end_time or self.end_time)
    -- 本次训练可以获得的总经验数
    self.exp_:set(data.exp or self.exp)
    --升级按钮状态
    self.btn_status = data.status or self.btn_status
    --位置
    -- self.train_index_:set(data.train_index or self.train_index)
end

--[[--
--获取训练位坦克
--]]
function TrainAreaEntity:getTankEntity()
     local tankUid = self.tank_unique_id
     if tankUid > 0 then
        return qy.tank.model.GarageModel:getEntityByUniqueID(tankUid)
    else
        return nil
    end
end

return TrainAreaEntity
