--[[--
--矿区cell
--Author: H.X.Sun
--Date: 2015-05-25
--]]--

local RareMineCell = qy.class("RareMineCell", qy.tank.view.BaseView, "view/mine/RareMineCell")

function RareMineCell:ctor(delegate)
    RareMineCell.super.ctor(self)
	self.delegate = delegate
	self.model = qy.tank.model.MineModel
	self:InjectView("mineBg")
	self:InjectView("info")
	self:InjectView("bar")
	self:InjectView("name")

	--矿区
	self:OnClick("mineBg", function (sendr)
		qy.tank.view.mine.MineTip.new({
			["entity"] = self.entity,
			["updateMineInfo"] = function (nType)
				self:updateCell(self.index)
				self:showReward(nType)
			end,
			["refreshPage"] = function ()
				self.delegate:refreshPage()
			end
		}):show(true)
	end, {["isScale"] = false})
end

--[[--
--展示奖励
--]]
function RareMineCell:showReward(nType)
	if nType ==2 then
		--收获
		if self.model:isFullMineHarvest() then
			self:showSpecialEvent(1)
		else
			qy.tank.command.AwardCommand:show(self.model:getHarvestAward())
		end
		self.delegate:refreshPage()
	elseif nType == 3 then
		--抢夺
		if self.delegate.updateOil then
			self.delegate.updateOil()
		end
		self.delegate:refreshPage()
	end
end

--[[--
--特殊事件
--_type 1：收获 2:抢夺
--]]
function RareMineCell:showSpecialEvent(_type)
	local  _award = self.model:getHarvestAward()
	qy.tank.view.mine.MineEventDialog.new({["award"] = _award, ["type"] = _type}):show(true)

end

function RareMineCell:showSilverReward(nValue)
	local toast = qy.tank.widget.Attribute.new({
            ["numType"] = 4,
            ["value"] = nValue,--支持正负
            ["hasMark"] = 1, --0没有加减号，1:有 默认为0
        })
        qy.hint:showImageToast(toast)
end

function RareMineCell:updateCell(index)
	self.index = index
	local entity = self.model:getMineList()[index]
	if entity then
		self.entity = entity
		self.mineBg:setVisible(true)
		if entity.owner.id > 0 then
			self.info:setVisible(true)
			-- print("entity:getProductPercent() ===" .. entity:getProductPercent())
			self.bar:setPercent(entity:getProductPercent())
			if entity.owner.id == qy.tank.model.UserInfoModel.userInfoEntity.kid then
				self.name:setString(qy.tank.model.UserInfoModel.userInfoEntity.name)
			else
				self.name:setString(entity.owner.nickname)
			end
		else
			self.info:setVisible(false)
		end
		if entity.type == 2 then
			--2:龙头
			self.mineBg:loadTexture("Resources/mine/lead_mine.png",1)
			self.mineBg:setContentSize(544, 388)
			self.mineBg:setPosition(-23,21)
		else
			--1:普通
			self.mineBg:loadTexture("Resources/mine/general_mine.png",1)
			self.mineBg:setContentSize(270, 200)
			self.mineBg:setPosition(-42,21)
		end
	else
		self.mineBg:setVisible(false)
		self.info:setVisible(false)
	end
end

function RareMineCell:onEnter()
	self:updateCell(self.index)
	if self.model:isSuccessfulPlunder() then
		self.model:updatePlunderResult()
		--print("============success")
		self.model:setSuccessfulPlunder(false)
		if self.model:isFullMineHarvest() then
			self:showSpecialEvent(2)
		else
			self.timer = qy.tank.utils.Timer.new(0.3,1,function()
				qy.tank.command.AwardCommand:show(self.model:getHarvestSilver())
			end)
			self.timer:start()
		end
	else
		--print("============not")
	end
end

return RareMineCell