--[[--
    装备套装
    Author: H.X.Sun
--]]--
local SuitCell = qy.class("SuitCell", qy.tank.view.BaseView, "view/equip/SuitCell")
local NodeUtil = qy.tank.utils.NodeUtil

function SuitCell:ctor(delegate)
    SuitCell.super.ctor(self)
    self.GarageModel = qy.tank.model.GarageModel
    self.model = qy.tank.model.EquipModel

    self:InjectView("suitTitle")
    for i = 1, 4 do
        self:InjectView("suit_bg_" .. i)
        self:InjectView("suit_" .. i)
    end
    for i = 1, 3 do
        self:InjectView("reward_" .. i)
        for j = 1, 4 do
            self:InjectView("reward_" .. i .."_" .. j)
        end
    end
    self.rewardUiTable = {
        [1] = {self.reward_1, self.reward_1_1, self.reward_1_2},
        [2] = {self.reward_2, self.reward_2_1, self.reward_2_2},
        [3] = {self.reward_3, self.reward_3_1, self.reward_3_2, self.reward_3_3, self.reward_3_4}
    }
    self.effertTable = {}
    self:update(delegate.entity)
end

--[[--
    套装信息
--]]
function SuitCell:update(entity)
    self.suitTitle:setSpriteFrame(entity:getSuitTitle())
    local suitEquit = self.model:getSuitEquipBySuitId(entity:getSuitID())
    --套装图标
    for i = 1, #suitEquit do
        self["suit_"..i]:setTexture(suitEquit[i]:getIcon())
    end

    --变灰或变亮套装图标
    local suitId = entity:getSuitID()
    local sameSuitNum = 0
    local tankUid = entity.tank_unique_id
    local tankEntity = nil
    local equipEntityList = nil
    if tankUid > 0 then
        tankEntity = self.GarageModel:getEntityByUniqueID(tankUid)
        equipEntityList = tankEntity:getEquipEntityList()

        for i = 1, 4 do
            if tankUid == 0 or equipEntityList[i] == -1 or equipEntityList[i]:getSuitID() ~= suitId then
                --没被装载(灰) 装载且套装ID不一致(灰)
                NodeUtil:darkNode(self["suit_"..i], true)
                self["suit_bg_".. i]:setSpriteFrame("Resources/common/item/item_bg_1.png")
                if self.effertTable[i] then
                    self.effertTable[i]:setVisible(false)
                end
            else
                --装载且套装ID一致(亮)
                NodeUtil:darkNode(self["suit_" .. i], false)
                self["suit_bg_".. i]:setSpriteFrame(suitEquit[i]:getIconBg())
                sameSuitNum = sameSuitNum + 1
                if self.effertTable[i] == nil then
                    self.effertTable[i] = self:createEquipSuitEffert(self["suit_" ..i])
                end
                self.effertTable[i]:setVisible(true)
            end
        end
    else
        for i = 1, 4 do
            if i == entity:getType() then
                NodeUtil:darkNode(self["suit_"..i], false)
                self["suit_bg_".. i]:setSpriteFrame(suitEquit[i]:getIconBg())
                if self.effertTable[i] == nil then
                    self.effertTable[i] = self:createEquipSuitEffert(self["suit_".. i])
                end
                self.effertTable[i]:setVisible(true)
            else
                NodeUtil:darkNode(self["suit_"..i], true)
                self["suit_bg_".. i]:setSpriteFrame("Resources/common/item/item_bg_1.png")
                if self.effertTable[i] then
                    self.effertTable[i]:setVisible(false)
                end
            end
        end
    end

    local suitReward = self.model:getSuitReward(suitId)
    for i = 1, #self.rewardUiTable do

        for j = 1, #self.rewardUiTable[i] do
            self.rewardUiTable[i][j]:setString(suitReward[i][j])

            if sameSuitNum > i  and j == 1 then
                self.rewardUiTable[i][j]:setTextColor(cc.c4b(245, 218, 135,255))
            elseif sameSuitNum > i  and j ~= 1 then
                self.rewardUiTable[i][j]:setTextColor(cc.c4b(255, 255, 255,255))
            else
                self.rewardUiTable[i][j]:setTextColor(cc.c4b(177, 177, 177,255))
            end

        end
    end
end

function SuitCell:createEquipSuitEffert(_target)
    local _effert = ccs.Armature:create("Flame")
    _target:addChild(_effert,999)
    _effert:setPosition(51,49)
    _effert:getAnimation():playWithIndex(0)
    return _effert
end

function SuitCell:getHeight()
    return 265
end

return SuitCell
