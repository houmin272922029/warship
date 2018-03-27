--[[--
    合金嵌入
    Author: H.X.Sun
--]]--
local AlloyCell = qy.class("AlloyCell", qy.tank.view.BaseView, "view/equip/AlloyCell")

function AlloyCell:ctor(delegate)
    AlloyCell.super.ctor(self)
    for i = 1, 3 do
        self:InjectView("alloy_" .. i)
        self:InjectView("level_bg_" .. i)
        self:InjectView("level_" .. i)
        self:InjectView("att_"..i)
    end

    self:update(delegate.entity)
end

function AlloyCell:update(equipEntity)
    local function __showDefault(_index)
        self["alloy_" .. _index]:setTexture("Resources/common/bg/c_12.png")
        self["level_bg_" .. _index]:setVisible(false)
    end
    local function __showAlloy(_index,_aEntity)
        self["alloy_" .. _index]:setTexture(_aEntity:getIcon())
        self["level_bg_" .. _index]:setVisible(true)
        self["level_".._index]:setString(_aEntity.level)
    end

    local alloyArr = equipEntity.alloy
    local alloyEntity
    self.loadNum = 0
    for i = 1, 3 do
        if alloyArr and alloyArr["p_".. i] > 0 then
            alloyEntity = equipEntity:getAlloyEntityByAlloyId(i)
            if alloyEntity then
                __showAlloy(i,alloyEntity)
                self.loadNum = self.loadNum + 1
                self["att_"..self.loadNum]:setString(alloyEntity:getAttributeDesc())
            else
                __showDefault(i)
            end
        else
            __showDefault(i)
        end
    end
    for i = 1, 3 do
        if i <= self.loadNum then
            self["att_".. i]:setVisible(true)
        else
            self["att_".. i]:setVisible(false)
        end
    end
end

function AlloyCell:getRemainHeight()
    return (3-self.loadNum) * 30
end

function AlloyCell:getHeight()
    return 185 + self.loadNum * 30
end

return AlloyCell
