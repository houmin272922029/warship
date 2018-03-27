--[[
	战场地图，分敌我双方两种类型
	Author: Aaron Wei
	Date: 2015-01-21 15:21:51
]]
local BattleField = class("BattleField",function(direction)
	if direction == 1 then
		return cc.Node:create()
	else
		return cc.ClippingNode:create()
	end
end)

function BattleField:ctor(direction)
	self.direction = direction
	self.model = qy.tank.model.BattleModel
	self.model["field"..direction] = self
	self.container = nil
	self.map = nil
	self.ground = nil
	self.formation = nil
	self.sky = nil
	self.mask = nil
	self:create(direction)
	if direction == 2 then
		self:setInverted(false)
		self:setAlphaThreshold(0)
	end
end

function BattleField:create(direction)
	-- container
	self.container = cc.Node:create()
	self:addChild(self.container)

	-- map
	self.map = qy.tank.view.battle.BattleMap.new(direction)
	self.map:play()
	self.container:addChild(self.map) 

	-- ground
	self.ground = cc.Sprite:create()
	self.container:addChild(self.ground)

	-- formation
	self.formation = qy.tank.view.battle.TankFormation.new(self.direction)
    self.model["formation"..self.direction] = self.formation
    self.formation:moveToStage()
    self.container:addChild(self.formation)
    self.formation:play()

	-- sky
	self.sky = cc.Sprite:create()
	self:addChild(self.sky)

	-- mask
	if direction == 2 then
		-- local p1 = cc.p(0,0)
		-- local p2 = cc.p(0,qy.winSize.height)
		-- local p3 = cc.p(qy.winSize.width,qy.winSize.height)
		-- local p4 = cc.p(qy.winSize.width,0)
		local p5 = cc.p(qy.winSize.width/2-qy.winSize.height/2*math.tan(qy.BattleConfig.FORMATION_ANGLE1),qy.winSize.height)
		local p6 = cc.p(qy.winSize.width/2+qy.winSize.height/2*math.tan(qy.BattleConfig.FORMATION_ANGLE1),0)
		self.mask = cc.Sprite:create("Resources/battle/mask_1280_720.png")
		self.mask:setAnchorPoint(1,0)	
		if direction == 1 then
			self.mask:setRotation(0)
			self.mask:setPosition(p6)
		else
			self.mask:setRotation(180)
			self.mask:setPosition(p5)
		end
		-- self:addChild(self.mask)
		self:setStencil(self.mask)
	end
end

-- 击中地面
function BattleField:hurt(pos,skillID)
	if tolua.cast(self.formation,"cc.Node") then
		-- self:showCrater(pos)

		if self.direction == 1 then
			self:playSkillFX(self.formation.nodeList[pos],skillID,pos,0)
		else
			self:playSkillFX(self.formation.nodeList[pos],skillID,pos,1)
		end
	end
end

-- 地面播放技能特效
function BattleField:playSkillFX(container,skillID,pos,idx)
	print("++++++++++++++++++++++++++++++ BattleField:playSkillFX",skillID)
	local fx_id = qy.Config.skill[tostring(skillID)].defense_effect_id
	print("++++++++++++++++++++++++++++++ BattleField:playSkillFX",fx_id)
	local file = "fx/".. qy.language .."/skill/def_fx_"..fx_id
	qy.tank.utils.cache.CachePoolUtil.addArmatureFile(file)

	local fx = ccs.Armature:create("def_fx_"..fx_id)
	local global_p = self.formation:convertToWorldSpace(cc.p(self.formation.nodeList[pos].origin))
	local local_p = container:convertToNodeSpace(global_p)
	fx:setPosition(local_p)
	container:addChild(fx)
	fx:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
		    if movementType == ccs.MovementEventType.complete then
		    	fx:getParent():removeChild(fx)
		    end
	    end)
	self:leave(fx)
	fx:getAnimation():playWithIndex(idx)
end

function BattleField:showCrater(pos)
	if tolua.cast(self.formation,"cc.Node") then
		if cc.SpriteFrameCache:getInstance():getSpriteFrame("keng_2.png") == nil then
			qy.tank.utils.cache.CachePoolUtil.addPlist("fx/".. qy.language .."/tank/crater")
		end
		local crater = cc.Sprite:createWithSpriteFrameName("keng_2.png")
		crater:setScale(0.5)
		local global_p = self.formation:convertToWorldSpace(cc.p(self.formation.nodeList[pos].origin))
		local local_p = self.ground:convertToNodeSpace(global_p)
		crater:setPosition(local_p)
		self.ground:addChild(crater)
		self:leave(crater,function()
			crater:getParent():removeChild(crater)
			crater = nil
		end)
		-- self:fadeOut(crater,3,nil)
	end
end

-- 跟随地图，渐行渐远
function BattleField:leave(target,callback)
	local distance = qy.BattleConfig.SPEED*qy.BattleConfig.TANK_DESTROY_TIME
	local px1,py1 = target:getPosition()
	local px2,py2
	-- local angle = math.pi - qy.BattleConfig.FORMATION_ANGLE1 - qy.BattleConfig.FORMATION_ANGLE2-0.03
	local angle = self.model:getMovementAngle(self.direction)
	if self.direction == 1 then
		px2,py2 = px1-math.cos(angle)*distance,py1-math.sin(angle)*distance
	else
		px2,py2 = px1+math.cos(angle)*distance,py1+math.sin(angle)*distance
	end
	local act = cc.MoveTo:create(qy.BattleConfig.TANK_DESTROY_TIME,cc.p(px2,py2))
	if callback then
		local seq = cc.Sequence:create(act,cc.CallFunc:create(callback))
		target:runAction(seq)
	else
		target:runAction(act)
	end
end

function BattleField:skip()
	-- self.formation:destroy()
	-- self.formation = qy.tank.view.battle.TankFormation.new(self.direction)
    -- self.model["formation"..self.direction] = self.formation
    -- self:addChild(self.formation)
    -- self.formation:play()
end

function BattleField:shake()
	self.container:setPosition(0,0)
	qy.Utils.shake(self.container,7)
end

function BattleField:play()
	self.formation:play()
end

function BattleField:stop()
	self.formation:stop()
end

function BattleField:destroy()
	self:stop()
	local function remove(target)
		if tolua.cast(target,"cc.Node") and target:getParent() then
			target:getParent():removeChild(target)
			target = nil
		end
	end
	remove(self.ground)
	remove(self.sky)
	remove(self.mask)
	if tolua.cast(self.formation,"cc.Node") then
		self.formation:destroy()
	end
	remove(self)
end

function BattleField:clear()
	self.container:removeChild(self.ground)
	if tolua.cast(self.formation,"cc.Node") then
		self.formation:destroy()
	end
end

function BattleField:reset()
	-- ground
	self.ground = cc.Sprite:create()
	self.container:addChild(self.ground)

	-- formation
	self.formation = qy.tank.view.battle.TankFormation.new(self.direction)
    self.model["formation"..self.direction] = self.formation
    self.formation:moveToStage()
    self.container:addChild(self.formation)
    self.formation:play()
end

return BattleField