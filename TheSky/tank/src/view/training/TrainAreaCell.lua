--[[
--训练位 view
--Author: H.X.Sun
--Date:
--]]
local TrainAreaCell = qy.class("TrainAreaCell", qy.tank.view.BaseView, "view/training/TrainAreaCell")

local _VipModel = qy.tank.model.VipModel
local userInfoEntity = qy.tank.model.UserInfoModel.userInfoEntity

function TrainAreaCell:ctor(delegate)
    TrainAreaCell.super.ctor(self)

    self.delegate = delegate
    self.model = qy.tank.model.TrainingModel
    self:InjectView("bgQuality")--训练位背景
    self:InjectView("trainLevel")--训练位等级
    self:InjectView("tankSprite")--战车精灵
    self:InjectView("upgradeBtn")--升级解锁按钮
    self:InjectView("tankLevel")--坦克名字
    self:InjectView("tankName")--坦克等级
    -- self.isUsed = false

    self:OnClick("upgradeBtn", function (sendr)
        self:upgradeOrUnlockLogic()
    end)
end

--[[--
--更新训练位
--]]
function TrainAreaCell:updateCell(entity)
    if entity then
        self.entity = entity
        self.trainLevel:setSpriteFrame(entity:getTrainLevelPath())
        local info = entity:getTankInfo()
        self.tankLevel:setString(info.tankLevel)
        self.tankName:setString(info.tankName)
        if entity.train_status == 1 then
            self.tankName:setTextColor(info.color)
            self.bgQuality:loadTexture(info.bg)
            self.tankSprite:setTexture(info.trainAreaSprite)
        elseif entity.train_status == 0 then
          self.bgQuality:loadTexture("tank/bg/bg1.png")
          self.tankSprite:setTexture("Resources/common/bg/c_12.png")
        else
            self.bgQuality:loadTexture("tank/bg/bg1.png")
            self.tankSprite:setSpriteFrame(info.trainAreaSprite)
        end

        if entity:getBtnStatus() == -1 then
            --锁定
            -- self.bgQuality:loadTexture("tank/bg/bg1.png")
            self.upgradeBtn:setVisible(true)
            self.upgradeBtn:setTitleText(qy.TextUtil:substitute(37008))
        elseif entity:getBtnStatus() == -2 then
            -- self.bgQuality:loadTexture("tank/bg/bg1.png")
            --隐藏
            -- self.tankSprite:setSpriteFrame(info.trainAreaSprite)
            self.upgradeBtn:setVisible(false)
        else
            -- self.bgQuality:loadTexture(info.bg)
            self.upgradeBtn:setTitleText(qy.TextUtil:substitute(37009))
            self.upgradeBtn:setVisible(true)
        end
    end
end

--[[--
--展示解锁逻辑
--]]
function TrainAreaCell:showUnlockLogic()
        if self.entity:getBtnStatus() == -1 then
            local unlockConditions = self.entity:getUnlockConditions()
            -- local userInfoEntity = qy.tank.model.UserInfoModel.userInfoEntity
            --锁定状态 解锁逻辑
            print("unlockConditions.vip_level ==" .. unlockConditions.vip_level)
            local function callBack(flag)
                if qy.TextUtil:substitute(37011) == flag then
                    if userInfoEntity.diamond < unlockConditions.unlock_cost then
                        qy.hint:show(qy.TextUtil:substitute(37010))
                        return
                    end
                    if userInfoEntity.vipLevel < unlockConditions.vip_level then
                        qy.hint:show(qy.TextUtil:substitute(37012, unlockConditions.vip_level, self.entity.train_index))
                        return
                    end
                    local service = qy.tank.service.TrainingService
                    service:unLockTrain(self.entity.train_index,function(data)
                        self.delegate:updateTrainList()
                    end)
                end
            end
            self.content = qy.tank.view.training.UpgradeAreaTip.new({
                ["num"] = unlockConditions.unlock_cost,
                ["type"] = 1,--解锁
            })
            qy.alert:showWithNode(qy.TextUtil:substitute(37014),  self.content, cc.size(560,250), {{qy.TextUtil:substitute(37015) , 4},{qy.TextUtil:substitute(37011) , 5} }, callBack, {})
        elseif self.entity:getBtnStatus() == -2 then
            qy.hint:show(qy.TextUtil:substitute(37016))
        end
end

--[[--
--显示升级逻辑
--]]
function TrainAreaCell:showUpgradeLogic()
    local upgradeInfo = self.entity:getUpgradeInfo()
    local function callBack(flag)
        if qy.TextUtil:substitute(37011) == flag then
            local _needVip = _VipModel:getUpgradeTrainAreaVipLevelByIndex(upgradeInfo.quality)
            if _needVip > userInfoEntity.vipLevel then
                qy.hint:show(qy.TextUtil:substitute(37013, _needVip, upgradeInfo.title))
                return
            end

            local service = qy.tank.service.TrainingService
            service:updateTrain(self.entity.train_index,function(data)
                qy.hint:show(qy.TextUtil:substitute(37018, upgradeInfo.percentage))
                self.delegate:updateTrainList()
           end)
        end
    end

    self.content = qy.tank.view.training.UpgradeAreaTip.new({
        ["upgradeInfo"] = upgradeInfo,
        ["type"] = 2,
    })
    qy.alert:showWithNode(qy.TextUtil:substitute(37014),  self.content, cc.size(560,250), {{qy.TextUtil:substitute(37015) , 4},{qy.TextUtil:substitute(37011) , 5} }, callBack, {})
end

--点击解锁或者升级按钮逻辑
function TrainAreaCell:upgradeOrUnlockLogic()
    if self.entity.btn_status == -1  then
        self:showUnlockLogic()
    elseif self.entity.btn_status == 1 or self.entity.btn_status == 0 then
        self:showUpgradeLogic()
    end
end

return TrainAreaCell
