--[[--
	跨服商店cell
--]]--

local ShopCell = qy.class("ShopCell", qy.tank.view.BaseView)

local model = qy.tank.model.ServiceWarModel
local userModel = qy.tank.model.UserInfoModel

function ShopCell:ctor(delegate)
	ShopCell.super.ctor(self)

	self.itemList = {}
	for i = 1, 3 do
		self.itemList[i] = require("servicewar.src.IconView").new()
		self:addChild(self.itemList[i])
		self.itemList[i]:setPosition(180 * (i - 1) + 110, 110)
	end
	self.delegate = delegate
end
	
function ShopCell:setData(data, idx,callback)
	self.idx = idx
	for i = 1, 3 do
		if data[i] then
			local itemData = qy.tank.view.common.AwardItem.getItemData(data[i].award[1])
			itemData.callback = function()
				self.delegate:ItemDetail(self.idx * 3 + i)
				model:setChooseIndex(self.idx * 3 + i)
				callback()
				self.delegate:clearLights()
				self.itemList[i]:setLight(true)
			end
			self.itemList[i]:setData(itemData, false)
			self.itemList[i]:setVisible(true)
		else
			self.itemList[i]:setVisible(false)
		end
	end
end

function ShopCell:setLight(flag)
	for i = 1, 3 do
		self.itemList[i]:setLight(false)
	end
end

return ShopCell