--[[--
--开服礼包cell
--Author: H.X.Sun
--Date: 2015-06-24
--]]--

local ServerGiftCell = qy.class("LoginGiftCell", qy.tank.view.BaseView, "view/operatingActivities/openServerGift/ServerGiftCell")

function ServerGiftCell:ctor(delegate)
    ServerGiftCell.super.ctor(self)
	self.model = qy.tank.model.OperatingActivitiesModel
	self:InjectView("toReceiveBtn")
	self:InjectView("hasReceive")
	self:InjectView("bg")
	self:InjectView("dayPic")

	self.dayTxt = qy.tank.widget.Attribute.new({
		["numType"] = 11,
		["value"] = 1,
	})
	self.day = delegate.day
	self.dayTxt:setPosition(qy.InternationalUtil:getServerGiftCelldayPicX2(), 123) 
	self.bg:addChild(self.dayTxt)
	local activity = qy.tank.view.type.ModuleType

	self:OnClick("toReceiveBtn",function(sender)
		local service = qy.tank.service.OperatingActivitiesService
		service:getCommonGiftAward(self.day, activity.OPEN_SERVER_GIFT_BAG, true, function(reData)
			delegate:callBack()
		end)
	end)

end

function ServerGiftCell:render(idx)
	local _award =self.model:getAwardByIndexOfSeverGift(idx) 
	self.day = self.model:getDayByIndexOfSeverGift(idx) 
	local _status = self.model:getCurrentStatusByDayOfServerGift(self.day)
	self.dayTxt:update(self.day)
	if self.day < 10 then
		self.dayPic:setPosition(qy.InternationalUtil:getServerGiftCelldayPicX(),123)
	else
		self.dayPic:setPosition(qy.InternationalUtil:getServerGiftCelldayPicX1(),123)
	end
	if _status == 0 then
		--不可领取
		self.toReceiveBtn:setVisible(true)
		self.toReceiveBtn:setEnabled(false)
        		self.toReceiveBtn:setBright(false)
        		self.hasReceive:setVisible(false)
	elseif _status == 1 then
		--可领取
		self.toReceiveBtn:setVisible(true)
		self.toReceiveBtn:setEnabled(true)
        		self.toReceiveBtn:setBright(true)
        		self.hasReceive:setVisible(false)
	elseif _status == 2 then
		--已可领取
		self.toReceiveBtn:setVisible(false)
		self.hasReceive:setVisible(true)
	end

	if self.awardList then
		self.bg:removeChild(self.awardList)
		self.awardItem = nil
	end
	self.awardList = qy.AwardList.new({
		["award"] = _award,
        ["itemSize"] = 2,
        ["cellSize"] = cc.size(120,180)
	})
    self.awardList:setPosition(110,245)
	self.bg:addChild(self.awardList)
end

return ServerGiftCell