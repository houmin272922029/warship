--[[
    红点
    Author: H.X.Sun
    Date: 2015-06-09
 --]]

 local RedDot = class("RedDot", function ()
	return cc.Sprite:create()
end)

 function RedDot:ctor(delegate)
 	cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/icon/common_icon.plist")
 	self:setSpriteFrame("Resources/common/icon/icon_hd.png")

    local model = qy.tank.model.RedDotModel

    local pos = model:getPositionByType(delegate.type)
    self:setPosition(pos)
 -- 	if delegate.type == qy.RedDotType.M_TECH then
 -- 		--科技
 -- 		self:setPosition(273, 45)
 -- 	elseif delegate.type == qy.RedDotType.M_SUPPLY then
 -- 		--补给
 -- 		self:setPosition(157, 32)
 -- 	elseif delegate.type == qy.RedDotType.M_TANK_FAC then
 -- 		--坦克工厂
 -- 		self:setPosition(291, 110)
 -- 	elseif delegate.type == qy.RedDotType.M_EX_CARD then
 -- 		--抽卡
 -- 		self:setPosition(264, 42)
 -- 	elseif delegate.type == qy.RedDotType.M_TRAIN then
 -- 		--训练场
 -- 		self:setPosition(235, 73)
 -- 	elseif delegate.type == qy.RedDotType.M_MINE then
 -- 		--矿区
 -- 		self:setPosition(98, 100)
 -- 	elseif delegate.type == qy.RedDotType.M_OP_ACTIVI then
 -- 		--运营活动
 -- 		self:setPosition(90, 62)
 -- 	elseif delegate.type == qy.RedDotType.G_CHANGE then
 -- 		--车库
	-- 	self:setPosition(200, 78)
 -- 	elseif delegate.type == qy.RedDotType.M_MAIL then
 -- 		--邮件
 -- 		self:setPosition(87, 83)
 -- 	elseif delegate.type == qy.RedDotType.M_TAB or
    --      delegate.type == qy.RedDotType.M_TAB_4 or
    --      delegate.type == qy.RedDotType.T_TAB_1 or
    --      delegate.type == qy.RedDotType.T_TAB_2 or
    --      delegate.type == qy.RedDotType.LE_T_APPLY --军团审核
    --      then
 -- 		--tab页
 -- 		self:setPosition(150,50)
    -- elseif  delegate.type == qy.RedDotType.TORCH_TAB_1 or
    --  delegate.type == qy.RedDotType.TORCH_TAB_2 or
    --  delegate.type == qy.RedDotType.TORCH_TAB_3 or
    --  delegate.type == qy.RedDotType.TORCH_TAB_4 then
    --      --火炬行动 tab
    --      self:setPosition(135,50)
 -- 	elseif delegate.type == qy.RedDotType.M_BATTLE_R then
 -- 		--作战室
 -- 		self:setPosition(150,80)
 -- 	elseif delegate.type == qy.RedDotType.G_LOAD then
 -- 		--一键装备
	-- 	self:setPosition(144, 55)
 -- 	elseif delegate.type == qy.RedDotType.TECH_TEMP_1 or
 -- 		delegate.type == qy.RedDotType.TECH_TEMP_2 or
 -- 		delegate.type == qy.RedDotType.TECH_TEMP_3 or
 -- 		delegate.type == qy.RedDotType.TECH_TEMP_4 then
	-- 	--科技模板
	-- 	self:setPosition(125, 46)
	-- elseif delegate.type == qy.RedDotType.M_EQUIP or
 -- 		delegate.type == qy.RedDotType.M_STOR or
 -- 		delegate.type == qy.RedDotType.M_EMBAT or
 -- 		delegate.type == qy.RedDotType.M_CAMPA or
    --     delegate.type == qy.RedDotType.M_LEGION or
 -- 		delegate.type == qy.RedDotType.M_GARAGE then
 -- 		--主城
 -- 		self:setPosition(93, 95)
 -- 	elseif delegate.type == qy.RedDotType.M_EQUIP or
 -- 		delegate.type == qy.RedDotType.G_EQUIP_1 or
 -- 		delegate.type == qy.RedDotType.G_EQUIP_2 or
 -- 		delegate.type == qy.RedDotType.G_EQUIP_3 or
 -- 		delegate.type == qy.RedDotType.G_EQUIP_4 then
 -- 		--车库装备
 -- 		self:setPosition(97, 99)
    -- elseif delegate.type == qy.RedDotType.M_TASK then
    --     --主界面任务
    --     self:setPosition(67, 30)
    -- elseif delegate.type == qy.RedDotType.LE_HALL then
    --     --军团大厅
    --     self:setPosition(220, 45)
    -- elseif delegate.type == qy.RedDotType.HER_RAC then
    --     --英勇竞速
    --     self:setPosition(76, 63)
    -- elseif delegate.type == qy.RedDotType.TORCH then
    --     --火炬行动
    --     self:setPosition(83, 63)
    -- elseif delegate.type == qy.RedDotType.TORCH_D_1 or
    --     delegate.type == qy.RedDotType.TORCH_D_2 or
    --     delegate.type == qy.RedDotType.TORCH_D_3 or
    --     delegate.type == qy.RedDotType.TORCH_D_4 or
    --     delegate.type == qy.RedDotType.TORCH_D_5 or
    --     delegate.type == qy.RedDotType.TORCH_D_6 then
    --     --火炬行动 1—6天
    --     self:setPosition(146, 105)
    -- elseif delegate.type == qy.RedDotType.TORCH_D_7 then
    --     --火炬行动 7天
    --     self:setPosition(306, 105)
 -- 	else
 -- 		--其他
	-- 	self:setPosition(83, 85)
 -- 	end
 end

 function RedDot:update(isNew)
 	cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/icon/common_icon.plist")
 	self:stopAllActions()
 	self.index = 1
 	if isNew then
 		self:setTexture("Resources/main_city/icon_new_1.png")
 		local delay = cc.DelayTime:create(0.5)
 		local callFunc = cc.CallFunc:create(function ()
 			self.index = self.index + 1
 			if self.index % 2 == 1 then
 				self:setTexture("Resources/main_city/icon_new_1.png")
 			else
 				self:setTexture("Resources/main_city/icon_new_2.png")
 			end
 		end)
 		self:runAction(cc.RepeatForever:create(cc.Sequence:create(delay, callFunc)))
 	else
 		self:setSpriteFrame("Resources/common/icon/icon_hd.png")
 	end
 end

 return RedDot
