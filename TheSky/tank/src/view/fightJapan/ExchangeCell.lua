--[[
	远征商店 cell
	Author: H.X.Sun
	Date: 2015-09-09
--]]
local ExchangeCell = qy.class("ExchangeCell", qy.tank.view.BaseView, "view/fightJapan/ExchangeCell")

function ExchangeCell:ctor(delegate)
	self.model = qy.tank.model.FightJapanModel
	self.goodsNum = self.model:getExpeditionGoodsNum()

	for i = 1, 2 do
		self:InjectCustomView("item_" .. i, qy.tank.view.fightJapan.ExchangeItem, {
			["isTouchMoved"] = function()
                return delegate:isTouchMoved()
            end,
		})
	end
end

function ExchangeCell:render(idx)
	if self.goodsNum >= idx  then
		self["item_1"]:setVisible(true)
		self["item_1"]:render(self.model:getExGoodsByIndex(idx))
	else
		self["item_1"]:setVisible(false)
	end
	print("idx ====", idx)

	local otherIdx = idx + math.ceil(self.model:getExpeditionGoodsNum() / 2)
	print("otherIdx ====", otherIdx)

	if self.goodsNum >= otherIdx  then
		self["item_2"]:setVisible(true)
		self["item_2"]:render(self.model:getExGoodsByIndex(otherIdx))
	else
		self["item_2"]:setVisible(false)
	end
end

return ExchangeCell