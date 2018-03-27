--[[
    补给奖励 cell
    Author: H.X.Sun
    Date: 2015-05-04
]]

local SupplyAwardCell = qy.class("SupplyAwardCell", qy.tank.view.BaseView, "view/supply/SupplyAwardCell")

function SupplyAwardCell:ctor(delegate)
    SupplyAwardCell.super.ctor(self)

    self.delegate = delegate
    self:InjectView("normal")
    self:InjectView("special")
    self:InjectView("sealSprite")
    self:InjectView("expNum")
    self:InjectView("silverNum")
    self:InjectView("earningsTxt")
    self.sealSprite:setLocalZOrder(5)
    self.model = qy.tank.model.SupplyModel
    self.itemIcon = {}
end

--[[--
--刷新
--@param #boolean flag 是否是特殊事件
--]]
function SupplyAwardCell:render(flag)
    if flag then
        self.sealSprite:setVisible(false)
        self.normal:setVisible(false)
        self.special:setVisible(true)
        for i = 1, 2 do
            if self.itemIcon[i] then
                self.special:removeChild(self.itemIcon[i])
            end
        end
        self.itemIcon = {}

        local supplyAward = self.model:getSupplyAward()
        if supplyAward == nil then return end

        if self.model:isSpecialEvent() then
            for i = 1, 2 do
                if supplyAward[i] then
                    self.itemIcon[i] = qy.tank.view.common.AwardItem.createAwardView(supplyAward[i],1,0.82)
                    self.itemIcon[i]:setPosition(60 + (i - 1) * 135, 67)
                    self.special:addChild(self.itemIcon[i])
                end
            end
        end
    else
        self.normal:setVisible(true)
        self.special:setVisible(false)
        self.expNum:setString(self.model:getAddExp())
        self.silverNum:setString(self.model:getAddSliver())
        self.earningsTxt:setString(self.model:getEarnings())
        self.earningsTxt:setPosition(self.silverNum:getPositionX() + self.silverNum:getContentSize().width, self.silverNum:getPositionY())
    end
end

--[[--
--显示盖章动画
--]]
function SupplyAwardCell:showSealAnim(flag)
    self.sealSprite:stopAllActions()
    if flag then
        self.sealSprite:setScale(5)
        self.sealSprite:setVisible(true)
        local scaleAction =  cc.ScaleTo:create(0.2, 1)
        local ease = cc.EaseOut:create(scaleAction,0.2)
        local callFunc = cc.CallFunc:create(function ()
            self.delegate.animEnd = true
        end)
        self.sealSprite:runAction(cc.Sequence:create(ease, callFunc))
    else
        self.delegate.animEnd = true
    end
end

return SupplyAwardCell
