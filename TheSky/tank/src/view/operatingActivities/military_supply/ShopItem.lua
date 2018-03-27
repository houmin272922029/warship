--[[
	军资整备 商店
	Author: H.X.Sun
]]
local ShopItem = qy.class("ShopItem", qy.tank.view.BaseView, "military_supply/ui/ShopItem")

function ShopItem:ctor(delegate)
   	ShopItem.super.ctor(self)
    self:InjectView("cell_1")
    self:InjectView("cell_2")
    for i = 1, 2 do
		self:InjectCustomView(
            "cell_" .. i,
            qy.tank.view.operatingActivities.military_supply.ShopCell,
            delegate
        )
	end

    self.model = qy.tank.model.OperatingActivitiesModel
    self.goodsNum = self.model:getMilitaryGoodsNum()
end

function ShopItem:render(idx)
	if self.goodsNum >= idx  then
		self["cell_1"]:setVisible(true)
		self["cell_1"]:render(self.model:getMilitaryGoodsByIndex(idx))
	else
		self["cell_1"]:setVisible(false)
	end

	local otherIdx = idx + math.ceil(self.goodsNum / 2)
	if self.goodsNum >= otherIdx  then
		self["cell_2"]:setVisible(true)
		self["cell_2"]:render(self.model:getMilitaryGoodsByIndex(otherIdx))
	else
		self["cell_2"]:setVisible(false)
	end
end


return ShopItem
