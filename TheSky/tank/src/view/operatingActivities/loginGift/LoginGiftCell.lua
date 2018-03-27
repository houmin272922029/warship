--[[--
--七天登陆礼包cell
--Author: H.X.Sun
--Date: 2015-06-24
--]]--

local LoginGiftCell = qy.class("LoginGiftCell", qy.tank.view.BaseView, "view/operatingActivities/loginGift/LoginGiftCell")

function LoginGiftCell:ctor(delegate)
    LoginGiftCell.super.ctor(self)
	self:InjectView("toReceiveBtn")
	self:InjectView("hasReceive")
	self:InjectView("bg")

	self.dayTxt = qy.tank.widget.Attribute.new({
		["numType"] = 11,
		["value"] = 1,
	})
	self.day = delegate.day
	
	self.dayTxt:setPosition(qy.InternationalUtil:getLoginGiftCellX(), 123)
	self.bg:addChild(self.dayTxt)

	self:OnClick("toReceiveBtn",function(sender)
		local service = qy.tank.service.OperatingActivitiesService
		service:getCommonGiftAward(self.day, "seven_day_login", true, function(reData)
			delegate:callBack()
			qy.GuideManager:next(98765467)
		end)
	end)

end

-- function LoginGiftCell:createEquipSuitEffert(_target)
--     local _effert = ccs.Armature:create("Flame")
--     -- _effert:setScale(1.1)
--     _target:addChild(_effert,999)
--     _effert:setPosition(2,0)
--     _effert:getAnimation():playWithIndex(0)
--     return _effert
-- end

function LoginGiftCell:render(data)
	self.day = data.day
	self.dayTxt:update(data.day)
	if data.status == 0 then
		--不可领取
		self.toReceiveBtn:setVisible(true)
		self.toReceiveBtn:setEnabled(false)
        self.toReceiveBtn:setBright(false)
        self.hasReceive:setVisible(false)
	elseif data.status == 1 then
		--可领取
		self.toReceiveBtn:setVisible(true)
		self.toReceiveBtn:setEnabled(true)
        self.toReceiveBtn:setBright(true)
        self.hasReceive:setVisible(false)
	elseif data.status == 2 then
		--已可领取
		self.toReceiveBtn:setVisible(false)
		self.hasReceive:setVisible(true)
	end

	if self.awardItem then
		self.bg:removeChild(self.awardItem)
		self.awardItem = nil
	end
	local itemData = qy.tank.view.common.AwardItem.getItemData(data.award[1])
	-- print("data.award.type=="..qy.json.encode(data))
	if data.award[1].type == 11 then
		itemData.namePos = 2
		itemData.fontSize = 18
		itemData.scale = 1
		self.awardItem = qy.tank.view.common.TankItem.new(itemData)
		self.awardItem:setPosition(170, 58)
	else
		itemData.size = cc.size(0,0)
		itemData.fontSize = 20
		self.awardItem = qy.tank.view.common.ItemIcon.new(itemData)
		self.awardItem:setPosition(170, 67)
		-- if data.award[1].type == 12 or data.award[1].type == 13 then
		-- 	self:createEquipSuitEffert(self.awardItem)
		-- end
	end
	-- self.awardList:setScale(0.8)
	-- self.awardItem:setPosition(170, 80)
	self.awardItem:setScale(0.8)
	self.bg:addChild(self.awardItem)
end

function LoginGiftCell:onEnter()
end

function LoginGiftCell:onExit()
end

return LoginGiftCell
