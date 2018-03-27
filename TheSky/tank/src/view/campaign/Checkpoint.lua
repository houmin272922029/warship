--[[
    关卡item
]]
local Checkpoint = qy.class("Checkpoint", qy.tank.view.BaseView, "view/campaign/Checkpoint")

function Checkpoint:ctor(delegate)
    Checkpoint.super.ctor(self)

    self:InjectView("image")
    self:InjectView("borderBtn")
    self:InjectView("numTxt")
    self:InjectView("nameTxt")
    self:InjectView("bossSign")
    self:InjectView("checkpoint")
    self:InjectView("award")
    self:InjectView("checkpointLight")
    self:InjectView("awardLight")
    self:InjectView("lockNode")
    self.campaignModel = qy.tank.model.CampaignModel
    self.isSelected = false
--    self:OnClick(self.borderBtn, function()
--        print(delegate.checkpointNum.."----------"..delegate.checkpointName)
--    end)
    self.updateData = nil
    self.light = self.checkpointLight
end

function Checkpoint:update(delegate)
    self.updateData = delegate
    self.checkpointLight:setVisible(false)
    self.awardLight:setVisible(false)
    self.image:setVisible(false)
    self.award:setVisible(false)
    self:setAnchorPoint(0,0)
    self.borderBtn:setTouchEnabled(false)
    
    if delegate.isAward == true then
        self.light = self.awardLight
        self.award:setVisible(true)

    else
        self.numTxt:setString(delegate.checkpointNum)
        self.nameTxt:setString(delegate.checkpointName)
        self.bossSign:setVisible(tonumber(delegate.checkpointData.type) == 2)
        self.light = self.checkpointLight
        self.image:setVisible(true)
        self:showCheckpointEffert(delegate)
        self.light:setVisible(self.isSelected)

        if(delegate.checkpointData.checkpointId > self.campaignModel.checkpointCurrentId) then
            self.lockNode:setVisible(true)
        else
            self.lockNode:setVisible(false)
        end
    end 

    if (delegate.checkpointData and delegate.checkpointData.icon) and tonumber(delegate.checkpointData.icon) > 0 then
        self.image:loadTexture("Resources/campaign/" .. delegate.checkpointData.icon .. ".jpg")
    end
end

function Checkpoint:showCheckpointEffert(delegate)
    -- if self.effect~=nil then
    --     self.effect:getParent():removeChild(self.effect)
    --     self.effect = nil
    -- end
    function showEffert()
        if not self.effect then
            self.effect = ccs.Armature:create("ui_fx_kuangzi") 
            self.image:addChild(self.effect,200)
            self.effect:setPosition(-8, 137)
        end
        self.effect:getAnimation():playWithIndex(0)
        self.effect:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
            if movementType == ccs.MovementEventType.complete then
                self.effect:getAnimation():playWithIndex(0)
            end
        end)
    end

    if tonumber(delegate.checkpointData.checkpointId)==tonumber(self.campaignModel.checkpointCurrentId) then
        showEffert()
        self.effect:setVisible(true)
    else
        if self.effect then
            self.effect:setVisible(false)
        end
    end
end

function Checkpoint:showUnlockEffert()
    print("-------------showUnlockEffert--------------")
    if self.unlockEffect~=nil then
        self.unlockEffect:getParent():removeChild(self.unlockEffect)
        self.unlockEffect = nil
    end
    function showUnlockEffert()
        
        self.unlockEffect = ccs.Armature:create("UI_fx_guankajiesuo") 
        self.image:addChild(self.unlockEffect,999)
        self.unlockEffect:setPosition(110, 70)
        self.unlockEffect:getAnimation():playWithIndex(0)
        self.unlockEffect:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
            if movementType == ccs.MovementEventType.complete then
                 print("-------------showUnlockEffert------complete!!!--------")
                self.unlockEffect:getParent():removeChild(self.unlockEffect)
                self.unlockEffect = nil
            end
        end)
    end

    if tonumber(self.updateData.checkpointData.checkpointId)==tonumber(self.campaignModel.checkpointCurrentId) then
        showUnlockEffert()
    end
end

function Checkpoint:clear( )
    -- if self.effect~=nil then
    --     self.effect:getParent():removeChild(self.effect)
    --     self.effect = nil
    -- end
end

function Checkpoint:ResetSelect()
    self.isSelected = false
    self.light:setVisible(self.isSelected)
end

function Checkpoint:setSelected()
    self.isSelected = true
    self.light:setVisible(self.isSelected)
end

--获取checkpointConfigData
function Checkpoint:getCheckpointConfigData()
    return self.updateData.checkpointData
end

function Checkpoint:onExit( )
    self:clear()
end

return Checkpoint