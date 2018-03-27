--[[--
--油量list
--Author: H.X.Sun
--Date: 2015-05-25
--]]--

local OilList = qy.class("OilList", qy.tank.view.BaseView, "view/mine/OilList")

function OilList:ctor(delegate)
    OilList.super.ctor(self)
	self.delegate = delegate
	self.model = qy.tank.model.MineModel
	self:InjectView("remianTime")
	self.remianTime:enableOutline(cc.c4b(0,0,0,255),1)
	self:InjectView("bg_t")
	for i = 1, 4 do
		self:InjectView("oil_" .. i)
	end
	if delegate.type == 1 then
		self.bg_t:setPosition(360,46)
	else
		self.bg_t:setPosition(100,-18)
	end
end

--[[--
--更新油料
--]]
function OilList:updateOil()
	local oilNum = self.model.mineEntity.owner.oil
	if oilNum >= 4 then
		self.bg_t:setVisible(false)
	else
		self.bg_t:setVisible(true)
	end
	for i = 1, 4 do
		if oilNum >= i then
			self["oil_" .. i]:setSpriteFrame("Resources/common/icon/oil_icon_1.png")
		else
			self["oil_" .. i]:setSpriteFrame("Resources/common/icon/oil_icon_2.png")
		end
	end
end

--[[--
--更新矿区时间
--]]
function OilList:updateRemainTime()
	self.remianTime:setString(self.model.mineEntity.owner:getRemainTimeStr())
end

return OilList