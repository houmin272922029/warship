--[[--
--黑市Cell
--Author: H.X.Sun
--Date: 2015-10-13
--]]--

local MarketCell = qy.class("MarketCell", qy.tank.view.BaseView, "market/ui/MarketCell")

local _AwardUtils = qy.tank.utils.AwardUtils
local _awardType = qy.tank.view.type.AwardType
local userModel = qy.tank.model.UserInfoModel

function MarketCell:ctor(param)
	MarketCell.super.ctor(self)

	self:InjectView("tick")
	self:InjectView("dis_num")
	self:InjectView("dis_txt")
	self:InjectView("original")
	self:InjectView("present")
	self.model = qy.tank.model.OperatingActivitiesModel
	self.idx = param.idx

	self:setTickShowOrNot(false)

	self:OnClick("t_btn", function(sender)
		print("打钩 t_btn")
		self:setTickShowOrNot(not self._is_tick_show)
    end)

    self:OnClick("buy_btn", function(sender)
		print("购买 buy_btn")
		if self.awardT == _awardType.TANK then
			function callBack(flag)
    			if flag == qy.TextUtil:substitute(57001) then
    				self:buyLoginc(param.idx)
    			end
        	end
    		self.content = require("market.src.BuyTips").new({
    			["entity"] = self.entity,
    			["coinUrl"] = self.coinUrl,
    			["sale"] = self.sale,
    		})
        	qy.alert:showWithNode(qy.TextUtil:substitute(57002),  self.content, cc.size(560,250), {{qy.TextUtil:substitute(57003) , 4},{qy.TextUtil:substitute(57001) , 5} }, callBack, {})
		else
			self:buyLoginc(param.idx)
		end
    end)

    for i = 1, 2 do
    	self:InjectView("icon_"..i)
    end

    self:update(param.idx)
end

function MarketCell:buyLoginc(_idx)
	local service = qy.tank.service.OperatingActivitiesService
	service:getCommonGiftAward(_idx, "market", true, function(reData)
		self:update(_idx)
	end)
end

function MarketCell:update(idx)
	local data = self.model:getCellInfoByIndex(idx)

    local _color = self.model:getColorByDis(data.discount)
    self.dis_num:setString(qy.language == "cn" and (data.discount * 10) or ((100 - data.discount * 100) .. "%"))
    self.original:setString(data.original .. "")
    self.sale = math.floor(data.original * data.discount)
    self.discount = data.discount
    self.present:setString(self.sale .. "")
    self.dis_num:setTextColor(_color)
    self.dis_txt:setTextColor(_color)

    self.coinUrl = _AwardUtils.getAwardIconByType(data.coin)
    for i = 1, 2 do
    	self["icon_"..i]:setTexture(self.coinUrl)
    end

    self.awardT = data.award[1].type

    if self.awardItem then
		self:removeChild(self.awardItem)
		self.awardItem = nil
	end

	local itemData = qy.tank.view.common.AwardItem.getItemData(data.award[1])
	if data.award[1].type == _awardType.TANK then
		itemData.fontSize = 18
		itemData.scale = 1
		self.awardItem = qy.tank.view.common.TankItem.new(itemData)
		self.awardItem:setPosition(108, 335)
		self.entity = itemData.entity
	else
		itemData.size = cc.size(0,0)
		itemData.fontSize = 20
		self.awardItem = qy.tank.view.common.ItemIcon.new(itemData)
		self.awardItem:setPosition(110, 335)
		-- if data.award[1].type == 12 or data.award[1].type == 13 then
		-- 	self:createEquipSuitEffert(self.awardItem)
		-- end
	end

	-- self.awardItem:setScale(0.9)
	self:addChild(self.awardItem)
end

function MarketCell:setTickShowOrNot(flag)
	self.tick:setVisible(flag)
	self._is_tick_show = flag
	local _str = "0"
	if flag then
		_str = "1"
	else
		_str = "0"
	end
	cc.UserDefault:getInstance():setStringForKey(userModel.userInfoEntity.kid .."_maket_t_"..self.idx, _str)
end

function MarketCell:isTickShow()
	return self._is_tick_show
end

function MarketCell:isLowDiscount()
	if self.discount > 0.7 then
		return false
	else
		return true
	end
end

return MarketCell
