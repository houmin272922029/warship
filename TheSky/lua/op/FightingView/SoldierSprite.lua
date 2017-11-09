

StandFramesCount = 4
MoveFramesCount = 6
AttackFramesCount = 6
AttackedFramesCount = 6
DeadFramesCount = 1
MainSkillFramesCount = 8

-- 动画类型
local kAniTypeStand = 0
local kAniTypeAttack = 1
local kAniTypeAttacked = 2
local kAniTypeDie = 3

-- 攻击动画的帧数
local StandFramesCount = 4
local AttackFramesCount = 6
local AttackedFramesCount = 1
local DeadFramesCount = 1
local MainSkillFramesCount = 8

FrameInterval = 0.5


AttackedDelay = 0.45
DieDelay = 0.25
DefUpDelay = 1.5
DamageDecDelay = 1.5
UndeadDelay = 1.1
AggSkillDelay = 0.6
ReboundDelay = 0.6

local KTAG_GHOST = 654

-- 阵营（左方/右方）
kLeftCamp = 1
kRightCamp = -1

soldierSkill = {
	skillId = nil,
	skillLevel = 1,
	skillType = "normal",
	atk = 0,
	per = 0,
	range = 0,
	skillName = nil,
}


SoldierSprite = class("SoldierSprite", function(fileName)
    return CCSprite:createWithSpriteFrameName(fileName)
end)

SoldierSprite.__index = SoldierSprite

-- 基础成员变量
SoldierSprite.m_state = kSoldierIdle
SoldierSprite.m_sId = nil
SoldierSprite.m_roleId = nil
SoldierSprite.m_resId = nil
SoldierSprite.m_name = nil
SoldierSprite.m_level = 1
SoldierSprite.m_rank = 1
SoldierSprite.m_side = 0
SoldierSprite.m_curHP = 0 				-- 当前的血量
SoldierSprite.m_maxHP = 0 				-- 最大的血量
SoldierSprite.m_posIndex = 0
SoldierSprite.m_range = 0
SoldierSprite.m_skills = {}

SoldierSprite.m_attackingRange = nil
SoldierSprite.m_attackingSkill = nil
SoldierSprite.m_attackedType = nil
SoldierSprite.m_dyingType = nil
SoldierSprite.m_isCounter = 0

SoldierSprite.m_defUp = 0
SoldierSprite.m_damageDec = 0
SoldierSprite.m_undead = 0
SoldierSprite.m_aggskill = 0
SoldierSprite.m_rebound = 0
SoldierSprite.m_reboundDamage = 0
SoldierSprite.m_waitDefUp = false
SoldierSprite.m_waitDamageDec = false
SoldierSprite.m_waitUndead = false
SoldierSprite.m_waitAggSkill = false
SoldierSprite.m_reboundType = nil

-- 速度控制器，将各动作包起来的对象
SoldierSprite.m_actionSpeed = nil 


-- 内部使用的序列帧播放动画函数
function SoldierSprite:_getAnimation(aniType)
	 CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(herodata:getHeroAnimationByResId(self.m_resId))
	if aniType == kAniTypeStand then
	    local animFrames = CCArray:create()
	    for j = 1, StandFramesCount do
	    	local frameName = string.format("%s_stand_000%d.png",self.m_resId, j)
	        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
		    animFrames:addObject(frame)
	    end
	    return CCAnimation:createWithSpriteFrames(animFrames, 0.1)
	-- 攻击
	elseif aniType == kAniTypeAttack then
	    local animFrames = CCArray:create()
	    for j = 1, 4 do
	    	local frameName = string.format("%s_attack_000%d.png",self.m_resId, j)
	        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
	        animFrames:addObject(frame)
	    end
	    local frameName5 = string.format("%s_attack_000%d.png",self.m_resId, 5)
	    animFrames:addObject(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName5))
	    animFrames:addObject(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName5))
	    animFrames:addObject(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName5))
	    animFrames:addObject(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName5))
	    local frameName6 = string.format("%s_attack_000%d.png",self.m_resId, 6)
	    animFrames:addObject(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName6))
	    return CCAnimation:createWithSpriteFrames(animFrames, 0.1)
	-- 被打
	elseif aniType == kAniTypeAttacked then
	    local animFrames = CCArray:create()
	    -- for j = 1, 1 do
	    	local frameName = string.format("%s_defend_000%d.png",self.m_resId, 1)
	        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
	        animFrames:addObject(frame)
	    -- end
	    return CCAnimation:createWithSpriteFrames(animFrames, AttackedDelay)
	-- 死亡
	elseif aniType == kAniTypeDie then
	    local animFrames = CCArray:create()
	    for j = 1, DeadFramesCount do
	    	local frameName = string.format("%s_dead_000%d.png",self.m_resId, j)
	        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
	        animFrames:addObject(frame)
	    end
	    return CCAnimation:createWithSpriteFrames(animFrames, 0.25)
	end
end


-- 死亡
function SoldierSprite:die(type)
	-- TODO 播放死亡音效
	self:stopAllActions()
	self.m_actionSpeed = nil
	local array = CCArray:create()
	local function deadFinished()
		self.m_state = "die"
		self:stopAllActions()
		self.m_actionSpeed = nil
		actionFinished(self,"die")
	end

	local function deadTemp2()
		self:stopAllActions()
		self.m_actionSpeed = nil

		local arr= CCArray:create()
		arr:addObject(CCDelayTime:create(DieDelay))
		arr:addObject(CCFadeOut:create(DieDelay))
		arr:addObject(CCCallFunc:create(deadFinished))

		-- renzhan
		self.m_actionSpeed = CCSpeed:create(CCSequence:create(arr),FightAniCtrl.aniSpeed)
		self:runAction(self.m_actionSpeed)
	end
	local function deadTemp1()
	    -- 如果死了，及时更新title上人员数字，但此时，还没有移除，所以数量提前减一
		if #FightAniCtrl.soldiersCountArray == 0 then
			initComputeSoldiersCountOfEachSide()      -- mdby cc
		end
		if self.m_side == "left" or self.m_side == 1 then
			FightAniCtrl.soldiersCountArray[1] = FightAniCtrl.soldiersCountArray[1] - 1
		else
			FightAniCtrl.soldiersCountArray[2] = FightAniCtrl.soldiersCountArray[2] - 1
		end

		FightingView.updateNumberOnTitle(FightAniCtrl.soldiersCountArray[1],FightAniCtrl.soldiersCountArray[2])   -- mdby cc
	end

	if self.m_defUp == 1 then
		self.m_defUp = 0
		local param = {}
		param["def"] = 0.1
		addOneBuff(self.m_sId,param)
		array:addObject(CCDelayTime:create(DefUpDelay))
	end

	if self.m_damageDec == 1 then
		self.m_damageDec = 0
		local function addResBuff()
			local param = {}
			param["res"] = 0.1
			addOneBuff(self.m_sId,param)
		end
		array:addObject(CCCallFunc:create(addResBuff))
		array:addObject(CCDelayTime:create(DamageDecDelay))
	end
	array:addObject(CCDelayTime:create(AttackedDelay))
	local animation = self:_getAnimation(kAniTypeDie)
	array:addObject(CCMoveBy:create(0.01,ccp(-self.m_side * 5 * retina,0)))
	array:addObject(CCAnimate:create(self:_getAnimation(kAniTypeAttacked)))
	array:addObject(CCCallFunc:create(deadTemp1))
	array:addObject(CCMoveBy:create(0.01,ccp(-self.m_side * 5 * retina,0)))
	array:addObject(CCAnimate:create(self:_getAnimation(kAniTypeAttacked)))
	array:addObject(CCMoveBy:create(0.01,ccp(-self.m_side * 15 * retina,0)))
	array:addObject(CCAnimate:create(animation))
	array:addObject(CCCallFunc:create(deadTemp2))

	-- renzhan
	local function ghostAnimation( )
		local ghost = CCSprite:createWithSpriteFrameName("ghostAni_1.png")
	    self:getParent():addChild(ghost,self:getZOrder()+1,KTAG_GHOST)
	    ghost:setAnchorPoint(ccp(0.5,0.2))
		ghost:setPosition(ccp(self:getPositionX(),self:getPositionY()))
		local ghostActions = CCArray:create()
	    local animFrames = CCArray:create()
	    for j = 1, 8 do
	        local frameName = string.format("ghostAni_%d.png",j)
	        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
	        animFrames:addObject(frame)
	    end
	    local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.1)
	    local animate = CCAnimate:create(animation)
	    ghostActions:addObject(animate)
		local function removeGhost( )
			ghost:removeFromParentAndCleanup(true)
		end
		ghostActions:addObject(CCCallFunc:create(removeGhost))
	    -- renzhan
	    local ghostSpeed = CCSpeed:create(CCSequence:create(ghostActions),FightAniCtrl.aniSpeed)
		ghost:runAction(ghostSpeed)
	end 
	array:addObject(CCCallFunc:create(ghostAnimation))
    -- renzhan
	self.m_actionSpeed = CCSpeed:create(CCSequence:create(array),FightAniCtrl.aniSpeed)
	self:runAction(self.m_actionSpeed)
end


-- 被打
function SoldierSprite:attacked()
	self:stopAllActions()
	self.m_actionSpeed = nil
	local function attackedFinished()
		self:setPosition(ccp(self:getPositionX() + self.m_side * 5,self:getPositionY()))
		if self.m_undead == 0 and self.m_aggskill == 0 then
			self:idle()
		end
		actionFinished(self,"attacked")
	end
	local function undeadFinished()
		self.m_undead = 0
		if self.m_aggskill == 0 then
			self:idle()
		end
		actionFinished(self,"undead")
	end
	local function aggskillFinished()
		self.m_aggskill = 0
		self:idle()
		actionFinished(self,"aggskill")
	end
--------------------------------------加防和减伤----------------------------------------------
	local attackedActions = CCArray:create()

	if self.m_defUp == 1 then
		self.m_defUp = 0
		local param = {}
		param["def"] = 0.1
		addOneBuff(self.m_sId,param)
		attackedActions:addObject(CCDelayTime:create(DefUpDelay))
	end

	if self.m_damageDec == 1 then
		self.m_damageDec = 0
		local function addDamgeDecBuff()
			local param = {}
			param["res"] = 0.1
			addOneBuff(self.m_sId,param)
		end
		attackedActions:addObject(CCCallFunc:create(addDamgeDecBuff))
		attackedActions:addObject(CCDelayTime:create(DamageDecDelay))
	end
--------------------------------------闪避和格挡----------------------------------------------

	if self.m_attackedType == "dodge" then
		local function showDodge()
			self:showText("attacked_dodge",1)
		end
		attackedActions:addObject(CCCallFunc:create(showDodge))
		attackedActions:addObject(CCDelayTime:create(0.5))
		attackedActions:addObject(CCCallFunc:create(attackedFinished))
		self.m_actionSpeed = CCSpeed:create(CCSequence:create(attackedActions),FightAniCtrl.aniSpeed)
		self:runAction(self.m_actionSpeed)
		return
	elseif
		self.m_attackedType == "parry" then
		local function showParry()
			self:showText("attacked_parry",1)
		end
		attackedActions:addObject(CCCallFunc:create(showParry))
		attackedActions:addObject(CCDelayTime:create(0.5))
		attackedActions:addObject(CCCallFunc:create(attackedFinished))
		self.m_actionSpeed = CCSpeed:create(CCSequence:create(attackedActions),FightAniCtrl.aniSpeed)
		self:runAction(self.m_actionSpeed)
		return
	end
--------------------------------------防御----------------------------------------------

	attackedActions:addObject(CCDelayTime:create(AttackedDelay))

	local defend = CCAnimate:create(self:_getAnimation(kAniTypeAttacked))
	local moves = CCArray:create()
	moves:addObject(CCJumpBy:create(0.2,ccp(-self.m_side * 5,0),15,2))
	moves:addObject(CCDelayTime:create(AttackedDelay)) 
	local moveAndDefend = CCSpawn:createWithTwoActions(defend,CCSequence:create(moves))
	attackedActions:addObject(moveAndDefend)
	local function setStandUp()
	    local frameName = string.format("%s_stand_0001.png",self.m_resId)
		self:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName))
	end
	attackedActions:addObject(CCCallFunc:create(setStandUp))
	attackedActions:addObject(CCCallFunc:create(attackedFinished))
	if self.m_undead == 0 and self.m_aggskill == 0 then
		self.m_actionSpeed = CCSpeed:create(CCSequence:create(attackedActions),FightAniCtrl.aniSpeed)
		self:runAction(self.m_actionSpeed)
		return
	end
------------------------------------------不死和铁块------------------------------
	-- 不死
	if self.m_undead == 1 then
		local function reviveAnimation()

			CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("images/buffText.plist")
			local reviveSprite = CCSprite:createWithSpriteFrameName("revive_001.png")
		    self:getParent():addChild(reviveSprite,self:getZOrder()+1)
		    reviveSprite:setAnchorPoint(ccp(0.5,0.25))
			reviveSprite:setPosition(ccp(self:getPositionX(),self:getPositionY()))
			local reviveActions = CCArray:create()
		    local animFrames = CCArray:create()
		    for j = 1, 8 do
		        local frameName = string.format("revive_00%d.png",j)
		        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
		        animFrames:addObject(frame)
		    end
		    local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.1)
		    local animate = CCAnimate:create(animation)
		    reviveActions:addObject(animate)
			local function removeReviveSprite( )
				reviveSprite:removeFromParentAndCleanup(true)
			end
			reviveActions:addObject(CCCallFunc:create(removeReviveSprite))
		    local reviveSpeed = CCSpeed:create(CCSequence:create(reviveActions),FightAniCtrl.aniSpeed)
			reviveSprite:runAction(reviveSpeed)
		end 
		attackedActions:addObject(CCCallFunc:create(reviveAnimation))
		attackedActions:addObject(CCDelayTime:create(0.8))
		attackedActions:addObject(CCCallFunc:create(undeadFinished))
		if self.m_aggskill == 0 then
			self.m_actionSpeed = CCSpeed:create(CCSequence:create(attackedActions),FightAniCtrl.aniSpeed)
			self:runAction(self.m_actionSpeed)
			return
		end
	end
	---------------------------- 铁块-----------------------------------------

	local function reboundAnimation( )

		CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("images/buffText.plist")
		local reboundSprite = CCSprite:createWithSpriteFrameName("rebound_001.png")
	    self:getParent():addChild(reboundSprite,self:getZOrder()+1)
		reboundSprite:setAnchorPoint(ccp(0.4,0.4))
	    reboundSprite:setScaleX(self.m_side)
		reboundSprite:setPosition(ccp(self:getPositionX(),self:getPositionY()))
		local reboundActions = CCArray:create()
	    local animFrames = CCArray:create()
	    for j = 1, 6 do
	        local frameName = string.format("rebound_00%d.png",j)
	        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
	        animFrames:addObject(frame)
	    end
	    local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.1)
	    local animate = CCAnimate:create(animation)
	    reboundActions:addObject(animate)
		local function removeReboundSprite( )
			reboundSprite:removeFromParentAndCleanup(true)
		end
		reboundActions:addObject(CCCallFunc:create(removeReboundSprite))
	    local reboundSpeed = CCSpeed:create(CCSequence:create(reboundActions),FightAniCtrl.aniSpeed)
		reboundSprite:runAction(reboundSpeed)
	end 
	attackedActions:addObject(CCCallFunc:create(reboundAnimation))
	attackedActions:addObject(CCDelayTime:create(0.6))
	attackedActions:addObject(CCCallFunc:create(aggskillFinished))
	self.m_actionSpeed = CCSpeed:create(CCSequence:create(attackedActions),FightAniCtrl.aniSpeed)
	self:runAction(self.m_actionSpeed)
end

function SoldierSprite:attack()
	self:stopAllActions()
	self.m_actionSpeed = nil

	local soundActions = CCArray:create()
	soundActions:addObject(CCDelayTime:create(0.5))
	local function playAttackingSound()
		if herodata:getHeroConfig(self.m_resId) and herodata:getHeroConfig(self.m_resId).atk_mp3 then
			local attackingSound = herodata:getHeroConfig(self.m_resId).atk_mp3

			playEffect("audio/"..attackingSound..".mp3")
		end
	end
	soundActions:addObject(CCCallFunc:create(playAttackingSound))
	-- renzhan
	local soundSpeed = CCSpeed:create(CCSequence:create(soundActions),FightAniCtrl.aniSpeed)
	self:runAction(soundSpeed)

    if self.m_isCounter == 1 then
    	self:showText("attack_counter",1)
    end

	local function attackAniFinished()
		if self.m_rebound == 0 then
			self:idle()
		end
		actionFinished(self,"attack")
	end

	local oriz = self:getZOrder()
	local function  resetZ1()
		FightingView.getSailorsLayer():reorderChild(self,oriz + 1)
	end

	local function  resetZ2()
		FightingView.getSailorsLayer():reorderChild(self,oriz)
	end

	local function standUp()
	    local frameName = string.format("%s_stand_0001.png",self.m_resId)
		self:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName))
	end

	local function reboundAniFinished()
		self.m_rebound = 0
		self:idle()
		actionFinished(self,"rebound")
	end
---------------------------------------------------------------

	local attackActions = CCArray:create()
	if self.m_waitDefUp then
		attackActions:addObject(CCDelayTime:create(DefUpDelay))
		self.m_waitDefUp = false
	end
	if self.m_waitDamageDec then
		attackActions:addObject(CCDelayTime:create(DamageDecDelay))
		self.m_waitDamageDec = false
	end

	local animation = self:_getAnimation(kAniTypeAttack)
	if self.m_attackingRange == attackRange.closeRange then
		attackActions:addObject(CCCallFunc:create(resetZ1))
		local oriPos = ccp(self:getPositionX(),self:getPositionY())
		local targetPos = ccp(FightAniCtrl.attackedSoldier:getPositionX() - 40 * self.m_side,FightAniCtrl.attackedSoldier:getPositionY())
		attackActions:addObject(CCMoveTo:create(0.05,targetPos))
		attackActions:addObject(CCRepeat:create(CCAnimate:create(animation), 1))
		attackActions:addObject(CCCallFunc:create(standUp))
		attackActions:addObject(CCMoveTo:create(0.1,oriPos))
		attackActions:addObject(CCCallFunc:create(resetZ2))
	else
		attackActions:addObject(CCDelayTime:create(0.05))
		attackActions:addObject(CCRepeat:create(CCAnimate:create(animation), 1))
		attackActions:addObject(CCCallFunc:create(standUp))
		attackActions:addObject(CCDelayTime:create(0.1))
	end
	attackActions:addObject(CCCallFunc:create(attackAniFinished))
	-- 如果没有被反伤，则return
	if self.m_rebound == 0 then
	    self.m_actionSpeed = CCSpeed:create(CCSequence:create(attackActions),FightAniCtrl.aniSpeed)
		self:runAction(self.m_actionSpeed)
		return
	end
----------------------------------被反伤---------------------------------

	
	local function looseBlood()			
		self:showDamage(self.m_reboundDamage,self.m_reboundType,1)
	end
	if self.m_waitUndead then
		attackActions:addObject(CCDelayTime:create(UndeadDelay - 0.3))
		attackActions:addObject(CCCallFunc:create(looseBlood))
		attackActions:addObject(CCDelayTime:create(0.3))
		self.m_waitUndead = false
	else
		attackActions:addObject(CCDelayTime:create(UndeadDelay - 0.9))
		attackActions:addObject(CCCallFunc:create(looseBlood))
		attackActions:addObject(CCDelayTime:create(0.3))	
	end
	-- 掉血
	-- 受伤没死
	if self.m_curHP > 0  then

		local defend = CCAnimate:create(self:_getAnimation(kAniTypeAttacked))
		local moves = CCArray:create()
		moves:addObject(CCJumpBy:create(0.2,ccp(-self.m_side * 5,0),15,2))
		moves:addObject(CCDelayTime:create(AttackedDelay))
		local moveAndDefend = CCSpawn:createWithTwoActions(defend,CCSequence:create(moves))
		
		attackActions:addObject(moveAndDefend)
		attackActions:addObject(CCCallFunc:create(standUp))
		attackActions:addObject(CCDelayTime:create(ReboundDelay))
		attackActions:addObject(CCCallFunc:create(reboundAniFinished))

	    self.m_actionSpeed = CCSpeed:create(CCSequence:create(attackActions),FightAniCtrl.aniSpeed)
		self:runAction(self.m_actionSpeed)
	    return
	else
		-- 受伤死了
		local function deadFinished()
			self.m_state = "die"
			self:stopAllActions()
			self.m_actionSpeed = nil
			actionFinished(self,"rebound")
			actionFinished(self,"rebound-die")
		end

		local function deadTemp2()
			self:stopAllActions()
			self.m_actionSpeed = nil

			local arr= CCArray:create()
			arr:addObject(CCDelayTime:create(DieDelay))
			arr:addObject(CCFadeOut:create(DieDelay))
			arr:addObject(CCCallFunc:create(deadFinished))

			-- renzhan
			self.m_actionSpeed = CCSpeed:create(CCSequence:create(arr),FightAniCtrl.aniSpeed)
			self:runAction(self.m_actionSpeed)
		end
		local function deadTemp1()
		    -- 如果死了，及时更新title上人员数字，但此时，还没有移除，所以数量提前减一
			if #FightAniCtrl.soldiersCountArray == 0 then
				initComputeSoldiersCountOfEachSide()      -- mdby cc
			end
			if self.m_side == "left" or self.m_side == 1 then
				FightAniCtrl.soldiersCountArray[1] = FightAniCtrl.soldiersCountArray[1] - 1
			else
				FightAniCtrl.soldiersCountArray[2] = FightAniCtrl.soldiersCountArray[2] - 1
			end

			FightingView.updateNumberOnTitle(FightAniCtrl.soldiersCountArray[1],FightAniCtrl.soldiersCountArray[2])   -- mdby cc
		end
		local dieAnimation = self:_getAnimation(kAniTypeDie)
		attackActions:addObject(CCMoveBy:create(0.01,ccp(-self.m_side * 5 * retina,0)))
		attackActions:addObject(CCAnimate:create(self:_getAnimation(kAniTypeAttacked)))
		attackActions:addObject(CCCallFunc:create(deadTemp1))
		attackActions:addObject(CCMoveBy:create(0.01,ccp(-self.m_side * 5 * retina,0)))
		attackActions:addObject(CCAnimate:create(self:_getAnimation(kAniTypeAttacked)))
		attackActions:addObject(CCMoveBy:create(0.01,ccp(-self.m_side * 15 * retina,0)))
		attackActions:addObject(CCAnimate:create(dieAnimation))
		attackActions:addObject(CCCallFunc:create(deadTemp2))

		-- renzhan
		local function ghostAnimation( )
			local ghost = CCSprite:createWithSpriteFrameName("ghostAni_1.png")
		    self:getParent():addChild(ghost,self:getZOrder()+1,KTAG_GHOST)
		    ghost:setAnchorPoint(ccp(0.5,0.2))
			ghost:setPosition(ccp(self:getPositionX(),self:getPositionY()))
			local ghostActions = CCArray:create()
		    local animFrames = CCArray:create()
		    for j = 1, 8 do
		        local frameName = string.format("ghostAni_%d.png",j)
		        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
		        animFrames:addObject(frame)
		    end
		    local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.1)
		    local animate = CCAnimate:create(animation)
		    ghostActions:addObject(animate)
			local function removeGhost( )
				ghost:removeFromParentAndCleanup(true)
			end
			ghostActions:addObject(CCCallFunc:create(removeGhost))
		    -- renzhan
		    local ghostSpeed = CCSpeed:create(CCSequence:create(ghostActions),FightAniCtrl.aniSpeed)
			ghost:runAction(ghostSpeed)
		end 
		attackActions:addObject(CCCallFunc:create(ghostAnimation))
	end
    -- renzhan
    self.m_actionSpeed = CCSpeed:create(CCSequence:create(attackActions),FightAniCtrl.aniSpeed)
	self:runAction(self.m_actionSpeed)
end

-- 站立
function SoldierSprite:idle()
	if self.m_state == "idle" then
		return
	end
	self.m_state = "idle"
	self:stopAllActions()
	self.m_actionSpeed = nil
	local animation = self:_getAnimation(kAniTypeStand)
    -- renzhan
    self.m_actionSpeed = CCSpeed:create(CCRepeatForever:create(CCAnimate:create(animation)),FightAniCtrl.aniSpeed)
    self:runAction(self.m_actionSpeed)
end

-- 启动
function SoldierSprite:start()
	local function startAniFinished()
		self:idle()
		actionFinished(self,"start")	
	end
	local animation = self:_getAnimation(kAniTypeStand)
	local array = CCArray:create()
	array:addObject(CCRepeat:create(CCAnimate:create(animation), 1))
	array:addObject(CCCallFunc:create(startAniFinished))
    -- renzhan
    self.m_actionSpeed = CCSpeed:create(CCSequence:create(array),FightAniCtrl.aniSpeed)
    self:runAction(self.m_actionSpeed)
end

function SoldierSprite:combo()
	local function comboAniFinished()
		self:idle()
		actionFinished(self,"combo")
	end

	local animation = self:_getAnimation(kAniTypeStand)
	local array = CCArray:create()
	array:addObject(CCRepeat:create(CCAnimate:create(animation), 4))
	array:addObject(CCCallFunc:create(comboAniFinished))
    -- renzhan
    self.m_actionSpeed = CCSpeed:create(CCSequence:create(array),FightAniCtrl.aniSpeed)
    self:runAction(self.m_actionSpeed)
end

function SoldierSprite:showHeadStartIcon( side )
	local icon = CCSprite:createWithSpriteFrameName("headStartIcon.png")
	FightingView.getSailorsLayer():addChild(icon,1000)
	icon:setPosition(ccp(self:getPositionX() + 32 * self.m_side,self:getPositionY() + 64))
	icon:setScale(5)
	icon:setOpacity(0)
	-- renzhan
	local iconSpeed = CCSpeed:create(CCEaseIn:create(CCScaleBy:create(0.25,0.2),5),FightAniCtrl.aniSpeed)
	icon:runAction(iconSpeed)

	-- renzhan
	local iconSpeed = CCSpeed:create(CCEaseIn:create(CCFadeIn:create(0.25),5),FightAniCtrl.aniSpeed)
	icon:runAction(iconSpeed)
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.5))
	array:addObject(CCFadeOut:create(0.25))
	local function removeIcon()
		icon:removeFromParentAndCleanup(true)
	end
	-- renzhan
	local iconSpeed = CCSpeed:create(CCSequence:create(array),FightAniCtrl.aniSpeed)
	icon:runAction(iconSpeed)
end



function SoldierSprite:showText(fileName,scaleSize)

	local pic = CCSprite:createWithSpriteFrameName(fileName..".png")

	self:getParent():addChild(pic,self:getZOrder() + 1)
	pic:setAnchorPoint(ccp(0.5,0))
	if fileName == "attacked_cri" then
		pic:setPosition(ccp(self:getPositionX() - 80 * retina * self.m_side,self:getPositionY() + self:getContentSize().height * 0.3))
	else
		pic:setPosition(ccp(self:getPositionX() ,self:getPositionY() + self:getContentSize().height * 0.3))
	end
	pic:setScale(0.01)

	local function removeLabel()
        pic:removeFromParentAndCleanup(true)
	end

	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.5))
	array:addObject(CCScaleBy:create(0.1,75 * scaleSize))
	array:addObject(CCScaleBy:create(0.1,0.8))
	array:addObject(CCDelayTime:create(0.25))
	array:addObject(CCFadeOut:create(0.25))
	array:addObject(CCCallFunc:create(removeLabel))
	-- renzhan
	local textSpeed = CCSpeed:create(CCSequence:create(array),FightAniCtrl.aniSpeed)
	pic:runAction(textSpeed)
end

function SoldierSprite:showDamage( damage,attackedType,scaleSize)
	if attackedType == "dodge" or attackedType == "parry" then
		return
	end

	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("images/fightingNumber.plist")
	
	local strings = string.allCharsOfString(damage)
	local pics = {}

	local startPosX = 0

	if self.m_side == 1 then
		startPosX = self:getPositionX() - 176 * retina * self.m_side * scaleSize
	else
		startPosX = self:getPositionX() + 44 * retina * scaleSize
	end

	-- 显示伤害字是在被打后仰的过程中，此时起始位置有可能出左边界，因此校正一下
	if startPosX < -(1 - retina) * winSize.width / 2 / retina then
		startPosX = -(1 - retina) * winSize.width / 2 / retina
	end

	for i,char in ipairs(strings) do
		local pic = CCSprite:createWithSpriteFrameName(attackedType.."_"..char..".png")
		self:getParent():addChild(pic,144)
		pic:setAnchorPoint(ccp(0,0.5))
		pic:setPosition(ccp(startPosX,self:getPositionY() + self:getContentSize().height * 0.2))
		startPosX = startPosX + pic:getContentSize().width / 2 * scaleSize
		pic:setScale(0.01)
		table.insert(pics,pic)
	end

	--右边的伤害字有可能超出右边界，如果超出，需要校正一下
	if startPosX > winSize.width  + (1 - retina) * winSize.width / 2 / retina then
		local outD = startPosX - (winSize.width  + (1 - retina) * winSize.width / 2 / retina)
		for i,pic in ipairs(pics) do
		 	pic:setPosition(ccp(pic:getPositionX() - outD,pic:getPositionY()))
		end 
	end

	-- 校正完位置，再做动作
	for i,pic in ipairs(pics) do

		local function removeLabel()
	        pic:removeFromParentAndCleanup(true)
		end

		local array = CCArray:create()
		array:addObject(CCDelayTime:create(0.5))
		array:addObject(CCScaleBy:create(0.1,75 * scaleSize))
		array:addObject(CCScaleBy:create(0.1,0.8))
		array:addObject(CCDelayTime:create(0.25))
		array:addObject(CCFadeOut:create(0.25))
		array:addObject(CCCallFunc:create(removeLabel))
		-- renzhan
		local picSpeed = CCSpeed:create(CCSequence:create(array),FightAniCtrl.aniSpeed)
		pic:runAction(picSpeed)
	end
end


function SoldierSprite:setSpeed(v)
	if self.m_state == "die" then
		return
	end
		-- 动作：站立、走路、攻击、被打、死、闪避
	if self.m_actionSpeed then
		self.m_actionSpeed:setSpeed(FightAniCtrl.aniSpeed)
	end
end

-- 状态机
function SoldierSprite:updateState()
	if self.m_state == "start" then
		self:start()
	elseif self.m_state == "attack" then
		self:attack()
	elseif self.m_state == "combo" then
		self:combo()
	elseif self.m_state == "attacked" then
		self:attacked()
	elseif self.m_state == "die" then
		self:die()
	else
		self:idle()
	end

end

-- 初始化设置参数
-- (one.sid, one.id, one.name, one.side, one.hp, one.x, one.range, one.skill)
function SoldierSprite:setAttr(sId, roleId, resId, name, level, rank, side, posIndex)
	self.m_sId = sId
	self.m_roleId = roleId
	self.m_resId = resId
	self.m_name = name
	self.m_level = level
	self.m_rank = rank
	self.m_side = side
	self.m_posIndex = posIndex
end


-- 初始化创建Sprite
function SoldierSprite.soldierWithFileName(fileName)
    local soldier = SoldierSprite.new(fileName)
    return soldier
end
