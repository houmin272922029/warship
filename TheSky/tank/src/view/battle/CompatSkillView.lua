--[[
	饱和攻击技能展示
	Author: Aaron Wei
	Date: 2015-03-05 18:36:47
]]

local CompatSkillView =  class("CompatSkillView",function()
	return cc.Node:create()
end)

function CompatSkillView:ctor(_skillID,_direction)
	self.direction = _direction
	self.fx_id = qy.Config.skill[tostring(_skillID)].compat_fx_id

	local listener = cc.EventListenerTouchOneByOne:create() 
	local function onTouchBegan(touch, event)
			listener:setSwallowTouches(true)
		return true
	end
	
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN) 
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
end

function CompatSkillView:play()        
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,170))
	self:addChild(self.bg)

	qy.tank.utils.cache.CachePoolUtil.addArmatureFile("fx/".. qy.language .."/skill/dz_fx_"..tostring(self.fx_id))
    self.skill_fx = ccs.Armature:create("dz_fx_"..tostring(self.fx_id))
    
    self.skill_fx:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
         	self:remove()
			qy.Event.dispatch("battle_compatSkill_end")
        end
    end)

    if self.direction == 1 then
    	self.skill_fx:getAnimation():playWithIndex(0)
    	self.skill_fx:setPosition(qy.winSize.width/2,300)
    else
    	self.skill_fx:getAnimation():playWithIndex(1)
    	self.skill_fx:setPosition(qy.winSize.width/2,300)
    end
    self:addChild(self.skill_fx)

    qy.QYPlaySound.playEffect(qy.SoundType["SKILL_"..self.fx_id])
end

function CompatSkillView:remove()
	if self.skill_fx and self.skill_fx:getParent() then
		self.skill_fx:getParent():removeChild(self.skill_fx)
		self.skill_fx = nil
	end

	if self.title and self.title:getParent() then
		self.title:getParent():removeChild(self.title)
		self.title = nil
	end

	if self and self:getParent() then
		self:getParent():removeChild(self)
		self = nil 
	end
end

return CompatSkillView