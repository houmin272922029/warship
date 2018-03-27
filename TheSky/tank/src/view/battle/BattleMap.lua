--[[
	战斗场景循环地图
	Author: Aaron Wei
	Date: 2015-03-07 20:51:07
]]

local BattleMap = class("BattleMap",function()
	return cc.Node:create()
end)

function BattleMap:ctor(direction)
	self.model = qy.tank.model.BattleModel
	self.direction = direction
	self.map = nil
	self.mask = nil
	self.act = nil
	self:create(direction)
end

function BattleMap:create(direction)
	local p1 = cc.p(0,0)
	local p2 = cc.p(0,qy.winSize.height)
	local p3 = cc.p(qy.winSize.width,qy.winSize.height)
	local p4 = cc.p(qy.winSize.width,0)
	local p5 = cc.p(qy.winSize.width/2-qy.winSize.height/2*math.tan(qy.BattleConfig.FORMATION_ANGLE1),qy.winSize.height)
	local p6 = cc.p(qy.winSize.width/2+qy.winSize.height/2*math.tan(qy.BattleConfig.FORMATION_ANGLE1),0)

	-- map // 指定jpg的渲染格式
    qy.Utils.preloadJPG(self.model:getBgURL())

	self.map = cc.Sprite:create(self.model:getBgURL())
	print("BattleMap111",self.map)
	self.map:setAnchorPoint(0,0)

	local p1_1 = self.model:getBgPosition(1)["start"]
	local p1_2 = self.model:getBgPosition(1)["end"]
	local p2_1 = self.model:getBgPosition(2)["start"]
	local p2_2 = self.model:getBgPosition(2)["end"]
	local distance = math.sqrt(math.pow(p1_1.x-p1_2.x,2)+math.pow(p1_1.y-p1_2.y,2))
	local duration = distance/qy.BattleConfig.SPEED

	if direction == 1 then
		self.map:setPosition(p1_1)
		self:addChild(self.map)

	    local act1 = cc.MoveTo:create(duration,p1_2)
	    -- local act2 = cc.MoveTo:create(0,p1_1)
	    local seq = cc.Sequence:create(act1,cc.CallFunc:create(function()
	    	self.map:setPosition(p1_1)
	    end),nil)
	    self.act = cc.RepeatForever:create(seq)
	else
		self.map:setPosition(p2_1)
		self:addChild(self.map)

	    local act1 = cc.MoveTo:create(duration,p2_2)
	    -- local act2 = cc.MoveTo:create(0,p2_1)
	    local seq = cc.Sequence:create(act1,cc.CallFunc:create(function()
	    	self.map:setPosition(p2_1)
	    end),nil)
	    self.act = cc.RepeatForever:create(seq)
	end
end

function BattleMap:play()
	self.map:runAction(self.act)
end

function BattleMap:stop()
	self.map:stopAction(self.act)
end

function BattleMap:destroy()
	self:stop()
	local function remove(target)
		if tolua.cast(target,"cc.Node") and target:getParent() then
			target:getParent():removeChild(target)
			target = nil
		end
	end
	remove(self.map)
	if tolua.cast(self.formation,"cc.Node") then
		self.formation:destroy()
	end
	remove(self)
end

return BattleMap
