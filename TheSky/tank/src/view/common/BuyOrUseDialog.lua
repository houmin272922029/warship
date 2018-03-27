--[[
    购买或使用 dialog
    Author: H.X.Sun
    Date: 2015-08-13
]]

local BuyOrUseDialog = qy.class("BuyOrUseDialog", qy.tank.view.BaseDialog, "view/common/BuyOrUseDialog")

function BuyOrUseDialog:ctor(delegate)
    BuyOrUseDialog.super.ctor(self)
    self:InjectView("Image_5")
    self:InjectView("costNum")
    self:InjectView("remainNum")
    self.propShopModel = qy.tank.model.PropShopModel
    self.storageModel = qy.tank.model.StorageModel

	--通用弹窗样式
    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(695,485),
        position = cc.p(0,0),
        offset = cc.p(0,0), 
        titleUrl = "Resources/common/title/goumaitili.png",

        ["onClose"] = function()
            self:dismiss()
        end
    })

    style:setLocalZOrder(-1)
    self:addChild(style)

    self.awardList = qy.AwardList.new({ 
        ["award"] = delegate.award,
    })
    self.awardList:setPosition(80,300)
    self.Image_5:addChild(self.awardList)

    local itme = self.awardList:getList()[1]
    self.awardId = delegate.award[1].id
    -- print("delegate ==", qy.json.encode(delegate))
    self.shopEntity =  self.propShopModel:getShopPropsEntityById(self.propShopModel:getShopPropsIdByProsId(self.awardId))
    -- self.storageEntity = self.storageModel:getEntityByID(_id)

    if self.shopEntity and self.shopEntity.props then
        itme:changeTitle(self.shopEntity.props.desc)
    end

    --使用
    self:OnClick("useBtn", function(sender)
        local service = qy.tank.service.StorageService
        service:use(tostring(self.awardId),1,function(data)
            self:updateRemainNum()
        end)
    end)

    --购买
    self:OnClick("buyBtn", function(sender)
        local service = qy.tank.service.ShopService
        service:buyProp(self.propShopModel:getShopPropsIdByProsId(self.awardId),1,function(data)
            qy.hint:show(qy.TextUtil:substitute(8029) .. " " .. data.consume.num)
            self:updateCost()
            self:updateRemainNum()
        end)
    end)

    self:updateCost()
    self:updateRemainNum()
end

function BuyOrUseDialog:updateCost()
    self.costNum:setString(self.shopEntity.number)
end

function BuyOrUseDialog:updateRemainNum()
    -- print("id =updateRemainNum=======", self.awardId)
    local storageEntity = self.storageModel:getEntityByID(self.awardId)
    if storageEntity then
        self.remainNum:setString(storageEntity.num)
    else
        self.remainNum:setString(0)
    end
end

return BuyOrUseDialog