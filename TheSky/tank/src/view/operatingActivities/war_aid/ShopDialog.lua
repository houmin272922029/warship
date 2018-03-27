--[[
	商店
	Author: H.X.Sun
]]

local ShopDialog = qy.class("ShopDialog", qy.tank.view.BaseDialog, "war_aid/ui/ShopDialog")

function ShopDialog:ctor(delegate)
    ShopDialog.super.ctor(self)
    self:InjectView("container")
    for i = 1, 4 do
        self:InjectView("num_"..i)
    end

    local style = qy.tank.view.style.DialogStyle1.new({
		size = cc.size(830,420),
		position = cc.p(0,0),
		offset = cc.p(0,0),
		titleUrl = "war_aid/res/shop_title.png",

        ["onClose"] = function()
            if delegate.callback then
                delegate.callback()
            end
            self:dismiss()
        end
    })
	self:addChild(style, -1)

    self.model = qy.tank.model.PropShopModel
    self.userInfo = qy.tank.model.UserInfoModel
    self.currencyMap = {["diamond"]=qy.TextUtil:substitute(31001),["silver"]=qy.TextUtil:substitute(31002),["blue_iron"]=qy.TextUtil:substitute(31003),["purple_iron"]=qy.TextUtil:substitute(31014)}

    for i = 1, 4 do
        self:OnClick("btn_"..i,function()
            local entity = self.model:getAidPropEntityByIndex(i)
            local have
            if entity.currency_type == 1 then
                have = self.userInfo.userInfoEntity.diamond
            elseif entity.currency_type == 2 then
                have = self.userInfo.userInfoEntity.silver
            elseif entity.currency_type == 3 then
                have = self.userInfo.userInfoEntity.blueIron
            elseif entity.currency_type == 4 then
                have = self.userInfo.userInfoEntity.purpleIron
            end

            if tonumber(self.userInfo.userInfoEntity.vipLevel) >= tonumber(entity.vip_limit) then
                local buyDialog = qy.tank.view.shop.PurchaseDialog.new(entity,function(num)
                    local service = qy.tank.service.ShopService
                    local entity = self.model:getAidPropEntityByIndex(i)
                    service:buyProp(entity.id,num,function(data)
                        service = nil
                        if data and data.consume then
                            qy.hint:show(qy.TextUtil:substitute(31004)..self.currencyMap[data.consume.type].."x"..data.consume.num)
                        end
                    end)
                end)
                buyDialog:show(true)
            else
                qy.hint:show(qy.TextUtil:substitute(31006))
            end
        end)
    end

    self:__createList()
end

function ShopDialog:__createList()
    local shop_list = {}
    for i = 1, #self.model.aid_shop_list do
        table.insert(shop_list, {["type"]=14,["id"]=self.model.aid_shop_list[i].shop_id})
        self["num_"..i]:setString("x "..self.model.aid_shop_list[i].number)
    end
    local aidList = qy.AwardList.new({
        ["award"] = shop_list,
        ["hasName"] = true,
        ["len"] = 4,
        ["type"] = 1,
        ["cellSize"] = cc.size(193,180),
        ["itemSize"] = 1,
    })
    self.container:addChild(aidList)
    aidList:setPosition(-292,255)
end

return ShopDialog
