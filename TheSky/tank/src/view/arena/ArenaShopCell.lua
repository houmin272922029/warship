--[[
	军神商店cell
	Author: Aaron Wei
	Date: 2015-12-28
--]]
local ArenaShopCell = qy.class("ArenaShopCell", qy.tank.view.BaseView, "view/fightJapan/ExchangeCell")

function ArenaShopCell:ctor(delegate)
	self.model = qy.tank.model.ArenaModel
	self.goodsNum = self.model:getExpeditionGoodsNum()

	for i = 1, 2 do
		self:InjectCustomView("item_" .. i, qy.tank.view.arena.ArenaShopItem, {
			["isTouchMoved"] = function()
                return delegate:isTouchMoved()
            end,
		})
	end
end

function ArenaShopCell:render(idx)
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

return ArenaShopCell