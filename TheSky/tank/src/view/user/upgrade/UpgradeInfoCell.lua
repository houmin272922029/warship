--[[--
--角色升级infox
--Author: H.X.Sun
--Date: 2015-06-01
--]]--

local UpgradeInfoCell = qy.class("UpgradeInfoCell", qy.tank.view.BaseView, "view/user/upgrade/UpgradeInfoCell")

local desArr = {"Lv",qy.TextUtil:substitute(38002), qy.TextUtil:substitute(38003), qy.TextUtil:substitute(38004),qy.TextUtil:substitute(38005)}

function UpgradeInfoCell:ctor(delegate)
    UpgradeInfoCell.super.ctor(self)

	self.model = qy.tank.model.RoleUpgradeModel

	--初始化ui
	self:__initView()
	self:updateViewData()
	self:_initNumTable()
end

--[[--
--更新控件数据
--]]
function UpgradeInfoCell:updateViewData()
    self.roleLastLevel = self.model.curRoleLevel
	self.lastLevel:setString(desArr[1] .. self.model.curRoleLevel)
	self.lastEnergy:setString(desArr[2] .. qy.tank.model.UserInfoModel.userInfoEntity.energy-10)
	self.lastTankLevel:setString(desArr[3] .. qy.tank.model.UserInfoModel:getMaxTankLevelByUserLevel(self.model.curRoleLevel))
	self.lastEquip:setString(desArr[4] .. qy.tank.model.UserInfoModel:getMaxEquipLevelByUserLevel(self.model.curRoleLevel))
	self.lastTechnology:setString(desArr[5] .. qy.tank.model.UserInfoModel:getMaxTechnologyLevelByUserLevel(self.model.curRoleLevel))
end

--[[--
--初始化Numtable
--]]
function UpgradeInfoCell:_initNumTable()
	self.numT = {}
	for i = 1, 5 do
		self.numT[i] = {}
		self.numT[i].beginNum = 1
	end
end

function UpgradeInfoCell:__initView()
	for i = 1, 5 do
		self:InjectView("up_" .. i)
		self:InjectView("num_" .. i)
	end

	self:InjectView("lastLevel")
	self:InjectView("lastEnergy")
	self:InjectView("lastTankLevel")
	self:InjectView("lastEquip")
	self:InjectView("lastTechnology")
end

--[[--
--信息动画
--]]
function UpgradeInfoCell:upgradeInfoAnim()
	for i = 1, 5 do
        if i == 5 and self.roleLastLevel >= 119 then
            -- 用户登录大于或等于 119时，不显示科技有关提升
            self["up_"..i]:setVisible(false)
        else
            self["up_"..i]:setVisible(true)
		    self:moveOneInfo(i)
        end
	end
end

--[[--
--一条信息移动
--]]
function UpgradeInfoCell:moveOneInfo(index)
	self["up_"..index]:setPosition(-300, 275 - 47 * index)
	local delay = cc.DelayTime:create(0.1 * index)
	local move = cc.MoveTo:create(0.1, cc.p(273, 275 - 47 * index))
	local callFunc = cc.CallFunc:create(function ( )
		self:updateValue(index)
	end)
	self["up_"..index]:runAction(cc.Sequence:create(delay, move, callFunc))
end

--[[--
--数字刷新
--]]
function UpgradeInfoCell:updateValue(index)
	if index == 1 then
		self.numT[index].endNum = self.model.curRoleLevel
	elseif index == 2 then
		self.numT[index].endNum = qy.tank.model.UserInfoModel.userInfoEntity.energy
	elseif index == 3 then
		self.numT[index].endNum = qy.tank.model.UserInfoModel:getMaxTankLevelByUserLevel(self.model.curRoleLevel)
	elseif index == 4 then
		self.numT[index].endNum = qy.tank.model.UserInfoModel:getMaxEquipLevelByUserLevel(self.model.curRoleLevel)
	elseif index == 5 then
		self.numT[index].endNum = qy.tank.model.UserInfoModel:getMaxTechnologyLevelByUserLevel(self.model.curRoleLevel)
	end
	local callFunc = cc.CallFunc:create(function ( )
		self.numT[index].beginNum = math.ceil(self.numT[index].beginNum * 1.3)
		if self.numT[index].beginNum >= self.numT[index].endNum then
			self["num_" .. index]:setString(desArr[index] .. self.numT[index].endNum)
			self["num_" .. index]:stopAllActions()
			-- self["num_" .. index]:setPosition(self["num_" .. index]:getPositionX(), 0)
		else
			self["num_" .. index]:setString(desArr[index] .. self.numT[index].beginNum)
		end
	end)
	local seq = cc.Sequence:create(callFunc)
	self["num_" .. index]:runAction(cc.RepeatForever:create(seq))
end

function UpgradeInfoCell:onExit()
	for i = 1, 5 do
		self["num_" .. i]:stopAllActions()
	end
end

return UpgradeInfoCell
