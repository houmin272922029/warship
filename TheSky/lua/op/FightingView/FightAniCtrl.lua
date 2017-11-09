Action = "action"

Action_Layout = "layout"
Action_Count = "count"
Action_Fame = "fame"
Action_Init = "init"
Action_Round = "round"
Action_End = "end"
Action_Finish = "finish"
Action_Buff = "buff"
Action_FieldBuff = "fieldBuff"
Action_Attack = "attack"
Action_Force = "force"
Action_Combo = "combo"

Action_Attack_Attack = "attack"
Action_Attack_Attacked = "attacked"
Action_Attack_Dead = "die"
Action_Attack_UnDead = "undead"
Action_Attack_AggSkill = "aggskill_000004"
Action_Attack_ReBound = "rebound"


zSuperSkillBlackBg = 1000
zSuperSkillParticle = 1001
zSuperSkillBust = 1011

KTAG_REBOUND = 2000

attackedType = {
	hit = 0,
	parry = 1,
}


-- 攻击类型（物攻/法攻）
attackRange = {
	closeRange = 0,
	longRange = 1,
}

battleCamp = {
	left = 1,
	right = -1,
}

NormalSpeed = 1.0

FightAniCtrl = {
	soldiers = {},
	nActionCount = 0,
	plistDic = {},
	aniSpeed = NormalSpeed,
	shouldRespondSpeed = true,

	leftTotalSoldiers = 1,
	rightTotalSoldiers = 1,

	leftFame = 0,
	rightFame = 0,
	vsNpc = true,

	headStrike = true,

	attackedSoldier = nil,

	buffCount = 0,

	clear = nil,
	speed = nil,
	setSpeed = nil,
	next = nil,
	soldiersCountArray = {},
}

-- 通过sid得到soldier
local function soldierBySid(sId)

	return FightAniCtrl.soldiers[sId]
end 

local function removeSoldier(s)
    if not FightAniCtrl.soldiers or not s then
    	return
    end
    s:stopAllActions()
	s.m_actionSpeed = nil
    s:removeAllChildrenWithCleanup(false)
    FightAniCtrl.soldiers[s.m_sId] = nil

    s:removeFromParentAndCleanup(false)
end


function FightAniCtrl.realPosition(side,posIndex)
	if side == 1 then
		local realX = FightingLayerOwner["referencePoint_left"].x - FightAniCtrl.arrangement[posIndex][1] * winSize.width * (0.43 - FightingLayerOwner["battleFieldCrack"])/retina
		local realY = FightingLayerOwner["referencePoint_left"].y + FightAniCtrl.arrangement[posIndex][2] * FightingLayerOwner["battleFieldHeight"]/retina
		return ccp(realX,realY)
	else
		local realX = FightingLayerOwner["referencePoint_right"].x + FightAniCtrl.arrangement[posIndex][1] * winSize.width * (0.43 - FightingLayerOwner["battleFieldCrack"])/retina
		local realY = FightingLayerOwner["referencePoint_right"].y + FightAniCtrl.arrangement[posIndex][2] * FightingLayerOwner["battleFieldHeight"]/retina
		return ccp(realX,realY)
	end
end

-- 清理战场
function FightAniCtrl.clear()
	for i,v in pairs(FightAniCtrl.soldiers) do
		if type(v) == "table" then
			return
		end
		if v then
			v:removeFromParentAndCleanup(true)
		end
	end
	FightAniCtrl.soldiers = {}
	FightAniCtrl.aniSpeed = NormalSpeed
	FightAniCtrl.nActionCount = 0
	FightAniCtrl.buffCount = 0
	FightAniCtrl.plistDic = {}
	FightAniCtrl.attackedSoldier = nil
	FightAniCtrl.vsNpc = false
	FightAniCtrl.soldiersCountArray = {}
	FightAniCtrl.shouldRespondSpeed = true
end

function computeSoldiersCountOfEachSide()

	local leftCount = 0
	local rightCount = 0
	for sid,v in pairs(FightAniCtrl.soldiers) do
		if v.m_side == "left" or v.m_side == 1 then
			leftCount = leftCount + 1
		    v.m_posIndex = leftCount
		else
			rightCount = rightCount + 1
		    v.m_posIndex = rightCount
		end
	end
	return {leftCount,rightCount}
end

function initComputeSoldiersCountOfEachSide(  )				-- add by cc
	local leftCount = 0
	local rightCount = 0
	for sid,v in pairs(FightAniCtrl.soldiers) do
		if v.m_side == "left" or v.m_side == 1 then
			leftCount = leftCount + 1
		    v.m_posIndex = leftCount
		else
			rightCount = rightCount + 1
		    v.m_posIndex = rightCount
		end
	end
	FightAniCtrl.soldiersCountArray = {leftCount,rightCount}
end

-- 根据左右人数计算要使用的排列方式
local function chooseArrangement( leftCount, rightCount)
	local maxCount = 8
	if leftCount >= rightCount then
		maxCount = leftCount
	else
		maxCount = rightCount
	end
	FightAniCtrl.arrangement = FightingLayerOwner["arrangement_"..maxCount]
end

-- 显示气势值
local function showFame()
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("images/fightingNumber.plist")
	local pics = {}
	local leftFameText = CCSprite:createWithSpriteFrameName("vigour.png")
	FightingLayerOwner["fightEffectLayer"]:addChild(leftFameText,1000)
	leftFameText:setAnchorPoint(ccp(0,0.5))
	leftFameText:setPosition(ccp(winSize.width * 0.1,winSize.height - 730 * 0.3 * retina))
	leftFameText:setScale(retina)
	leftFameText:setOpacity(0)

	table.insert(pics,leftFameText)


	local leftFameNumbers = string.allCharsOfString(tostring(FightAniCtrl.leftFame))
	local startPosX1 = winSize.width * 0.1 + leftFameText:getContentSize().width * retina * 0.8

	if isPlatform(ANDROID_VIETNAM_VI) 
		or isPlatform(ANDROID_VIETNAM_EN)
		or isPlatform(ANDROID_VIETNAM_EN_ALL)
		or isPlatform(ANDROID_VIETNAM_MOB_THAI)
		or isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA) 
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_INFIPLAY_RUS)
        or isPlatform(ANDROID_INFIPLAY_RUS)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN)
        or isPlatform(WP_VIETNAM_EN) then

		startPosX1 = winSize.width * 0.1 + leftFameText:getContentSize().width * retina
		
	end
	for i,number in ipairs(leftFameNumbers) do
		local numberPic = CCSprite:createWithSpriteFrameName("vigour_"..number..".png")
		FightingLayerOwner["fightEffectLayer"]:addChild(numberPic,1000)
		numberPic:setAnchorPoint(ccp(0,0.5))
		numberPic:setPosition(ccp(startPosX1,winSize.height - 730 * 0.3 * retina))
		startPosX1 = startPosX1 + numberPic:getContentSize().width * retina * 0.8
		numberPic:setScale(retina)
		numberPic:setOpacity(0)

		table.insert(pics,numberPic)
	end




	local startPosX2 = winSize.width * 0.9
	if FightAniCtrl.vsNpc then
		for i = 1,3 do
			local numberPic = CCSprite:createWithSpriteFrameName("vigour_unknown.png")
			FightingLayerOwner["fightEffectLayer"]:addChild(numberPic,1000)
			numberPic:setAnchorPoint(ccp(1,0.5))
			numberPic:setPosition(ccp(startPosX2,winSize.height - 730 * 0.3 * retina))
			startPosX2 = startPosX2 - numberPic:getContentSize().width * retina * 0.8
			numberPic:setScale(retina)
			numberPic:setOpacity(0)

			table.insert(pics,numberPic)
		end
	else
		local rightFameNumbers = string.allCharsOfString(tostring(FightAniCtrl.rightFame))
		for i=1,#rightFameNumbers do
			local numberPic = CCSprite:createWithSpriteFrameName("vigour_"..rightFameNumbers[#rightFameNumbers - i + 1]..".png")
			FightingLayerOwner["fightEffectLayer"]:addChild(numberPic,1000)
			numberPic:setAnchorPoint(ccp(1,0.5))
			numberPic:setPosition(ccp(startPosX2,winSize.height - 730 * 0.3 * retina))
			
			
			if isPlatform(ANDROID_VIETNAM_VI) 
				or isPlatform(ANDROID_VIETNAM_EN)
				or isPlatform(ANDROID_VIETNAM_EN_ALL) 
				or isPlatform(ANDROID_VIETNAM_MOB_THAI)
				or isPlatform(IOS_VIETNAM_VI) 
		        or isPlatform(IOS_VIETNAM_EN) 
                or isPlatform(IOS_VIETNAM_ENSAGA) 
		        or isPlatform(IOS_MOB_THAI)
		        or isPlatform(IOS_MOBNAPPLE_EN)
                or isPlatform(IOS_INFIPLAY_RUS)
                or isPlatform(ANDROID_INFIPLAY_RUS)
       		or isPlatform(IOS_MOBGAME_SPAIN)
        	or isPlatform(ANDROID_MOBGAME_SPAIN)
                or isPlatform(WP_VIETNAM_EN) then

				startPosX2 = startPosX2 - numberPic:getContentSize().width * retina
			else
				startPosX2 = startPosX2 - numberPic:getContentSize().width * retina * 0.8
				
			end
			numberPic:setScale(retina)
			numberPic:setOpacity(0)

			table.insert(pics,numberPic)
		end
	end

	local rightFameText = CCSprite:createWithSpriteFrameName("vigour.png")
	FightingLayerOwner["fightEffectLayer"]:addChild(rightFameText,1000)
	rightFameText:setAnchorPoint(ccp(1,0.5))
	rightFameText:setPosition(ccp(startPosX2,winSize.height - 730 * 0.3 * retina))
	rightFameText:setScale(retina)
	rightFameText:setOpacity(0)

	table.insert(pics,rightFameText)


	for i,pic in ipairs(pics) do
		pic:runAction(CCFadeIn:create(0.25))
		local fameActions = CCArray:create()
		fameActions:addObject(CCDelayTime:create(0.5))
		local function moveAndFadeOut()
			pic:runAction(CCMoveBy:create(0.5,ccp(0,100 * retina)))
			pic:runAction(CCFadeOut:create(0.5))
		end
		fameActions:addObject(CCCallFunc:create(moveAndFadeOut))
		fameActions:addObject(CCDelayTime:create(0.5))
		local function removeFame()
			pic:removeFromParentAndCleanup(true)
		end
		fameActions:addObject(CCCallFunc:create(removeFame))
		pic:runAction(CCSequence:create(fameActions))
	end
end

-- 
local function ac_layout( result )
	if not result then
		FightAniCtrl.next()
		return
	end
	FightAniCtrl.clear()
	FightAniCtrl.headStrike = true

	for i,one in ipairs(result) do
		if one then
			--人物动画资源
		    -- 初始化设置参数
		    local posIndex = one.x
		    local sid = one.sid
		    local side = 0
		    local level = one.level
		    local resId = one.resId
		    local roleId = one.id
		    local rank = one.rank
		    local name = one.name

		    if one.side == "left" then
		    	side = battleCamp.left
		    elseif one.side == "right" then
		    	side = battleCamp.right
		    	if string.find(roleId,"npc_") then
		    		FightAniCtrl.vsNpc = true
		    	end
		    else
		    	side = battleCamp.left
		    end

		    if not resId or not herodata:getHeroAnimationByResId(resId) or not CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(herodata:getHeroAnimationByResId(resId)) then
		    	resId = "hero_000342"
				CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(herodata:getHeroAnimationByResId(resId))
			end

			local plistCount = FightAniCtrl.plistDic[resId]
			if plistCount then
				FightAniCtrl.plistDic[resId] = plistCount + 1
			else
				FightAniCtrl.plistDic[resId] = 1
			end

		    local aniRes = string.format("%s_stand_0001.png",resId)
		    local _soldier = SoldierSprite.soldierWithFileName(aniRes)
		    _soldier:setAttr(sid, roleId, resId, name, level,rank, side, posIndex)
		    
		    --以sid为key加入soldiers中
		    FightAniCtrl.soldiers[one.sid] = _soldier
		end
	end

	local soldiersCount = computeSoldiersCountOfEachSide()
	chooseArrangement(soldiersCount[1],soldiersCount[2])

	for k,_soldier in pairs(FightAniCtrl.soldiers) do

		local dstPosition = FightAniCtrl.realPosition(_soldier.m_side,_soldier.m_posIndex)
		_soldier:setPosition(ccp(dstPosition.x - winSize.width * 0.5 / retina * _soldier.m_side,dstPosition.y))
	    FightingView.getSailorsLayer():addChild(_soldier)
	    _soldier:setAnchorPoint(ccp(0.5,0.5))
		_soldier:setScaleX(_soldier.m_side*1.25)
		_soldier:setScaleY(1.25)
	end

	FightAniCtrl.next()
end

-- 根据左右人数计算要使用的排列方式
local function ac_count(result)
	FightAniCtrl.leftTotalSoldiers = result[1].left
	FightAniCtrl.rightTotalSoldiers = result[1].right
	FightingView.updateNumberOnTitle(result[1].left,result[1].right)
	FightAniCtrl.next()
end

-- 气势
local function ac_fame(result)
	FightAniCtrl.leftFame = result[1].left
	FightAniCtrl.rightFame = result[1].right
	FightAniCtrl.next()
end

-- 群体buff
local function ac_fieldBuff( result )
	if not result or table.getTableCount(result) <= 0 then
		FightAniCtrl.next()
		return
	end

	FightAniCtrl.buffCount = 1

	local buffSide = -1
	local param = {}
	local textArray = {}

	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("images/buffText.plist")

	local function addDeuff()

		playEffect(MUSIC_SOUND_FIGHT_BUFF)

		for attr,v in pairs(param) do
        if isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
				textArray[1] = tostring(attr)
			else
				textArray = string.allCharsOfString(attr)
			end
		end
		for sid,soldier in pairs(FightAniCtrl.soldiers) do
			if soldier.m_side == buffSide then
				local dstPosition = FightAniCtrl.realPosition(soldier.m_side,soldier.m_posIndex)
				HLAddParticleScale( "images/debuff.plist", FightingView.getSailorsLayer(), dstPosition, soldier:getZOrder(), soldier:getZOrder(), 100,buffSide/retina,1/retina)

				local icon = CCSprite:createWithSpriteFrameName("debuffIcon.png")
				FightingView.getSailorsLayer():addChild(icon,100)
				icon:setAnchorPoint(ccp(0,0.5))
				local iconActions = CCArray:create()
				for i=1,3 do
					iconActions:addObject(CCMoveBy:create(0.25,ccp(0,15)))
					iconActions:addObject(CCMoveBy:create(0.25,ccp(0,-15)))
				end
				iconActions:addObject(CCFadeOut:create(0.25))
				local function removeIcon()
					icon:removeFromParentAndCleanup(true)
				end
				iconActions:addObject(CCCallFunc:create(removeIcon))
				icon:runAction(CCSequence:create(iconActions))

				local startPosX = dstPosition.x - 30
				for i,char in ipairs(textArray) do
					local text = CCSprite:createWithSpriteFrameName("debuff_"..char..".png")
					FightingView.getSailorsLayer():addChild(text,100)
					text:setAnchorPoint(ccp(0,0.5))
					text:setPosition(ccp(startPosX,dstPosition.y + 60 ))
					startPosX = startPosX + text:getContentSize().width * 0.7
					local tActions = CCArray:create()
					for i=1,3 do
						tActions:addObject(CCMoveBy:create(0.25,ccp(0,15)))
						tActions:addObject(CCMoveBy:create(0.25,ccp(0,-15)))
					end
					tActions:addObject(CCFadeOut:create(0.25))
					local function removeT()
						text:removeFromParentAndCleanup(true)
					end
					tActions:addObject(CCCallFunc:create(removeT))
					text:runAction(CCSequence:create(tActions))
				end

				icon:setPosition(ccp(startPosX,dstPosition.y + 60))
			end
		end
	end

	for i,debuff in ipairs(result) do
		if debuff.from then
			skill = debuff.skill
			if debuff.from.side == "left" then
				buffSide = -1
			else
				buffSide = 1
			end
		end
		if debuff.to then
			param = debuff.param
			break
		end
	end

	local actions = CCArray:create()
	actions:addObject(CCDelayTime:create(3 + 1.5 * FightAniCtrl.buffCount))
	actions:addObject(CCCallFunc:create(addDeuff))
	FightingView.getSailorsLayer():runAction(CCSequence:create(actions))

	FightAniCtrl.next()
end

function addOneBuff(sid,param)
	local isDamageDec = param.isDamageDec
	local soldier = soldierBySid(sid)
	local pos = FightAniCtrl.realPosition(soldier.m_side,soldier.m_posIndex)
	HLAddParticleScale( "images/buff.plist", FightingView.getSailorsLayer(), ccp(pos.x,pos.y - 64), soldier:getZOrder(), soldier:getZOrder(), 100,soldier.m_side/retina,1/retina)
	

	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("images/buffText.plist")
	local startPosX = pos.x - 30 * retina
	local textArray = {}
	for attr,v in pairs(param) do
        if isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
				textArray[1] = tostring(attr)
			else
				textArray = string.allCharsOfString(attr)
			end
		end
		for i,char in ipairs(textArray) do
			local text
			text = CCSprite:createWithSpriteFrameName("buff_"..char..".png")
			FightingView.getSailorsLayer():addChild(text,100)
			text:setAnchorPoint(ccp(0,0.5))
			text:setPosition(ccp(startPosX,pos.y + 60))
			startPosX = startPosX + text:getContentSize().width * 0.7
			local tActions = CCArray:create()
			for i=1,3 do
				tActions:addObject(CCMoveBy:create(0.25,ccp(0,15)))
				tActions:addObject(CCMoveBy:create(0.25,ccp(0,-15)))
			end
			tActions:addObject(CCFadeOut:create(0.25))
			local function removeT()
				text:removeFromParentAndCleanup(true)
			end
			tActions:addObject(CCCallFunc:create(removeT))
			text:runAction(CCSequence:create(tActions))
		end

	local icon = CCSprite:createWithSpriteFrameName("buffIcon.png")
	FightingView.getSailorsLayer():addChild(icon,100)
	icon:setAnchorPoint(ccp(0,0.5))
	icon:setPosition(ccp(startPosX,pos.y + 60))
	local iconActions = CCArray:create()
	for i=1,3 do
		iconActions:addObject(CCMoveBy:create(0.25,ccp(0,15)))
		iconActions:addObject(CCMoveBy:create(0.25,ccp(0,-15)))
	end
	iconActions:addObject(CCFadeOut:create(0.25))
	local function removeIcon()
		icon:removeFromParentAndCleanup(true)
	end
	iconActions:addObject(CCCallFunc:create(removeIcon))
	icon:runAction(CCSequence:create(iconActions))
end

local function ac_buff( result )
	if not result or table.getTableCount(result) <= 0 then
		FightAniCtrl.next()
		return
	end

	FightAniCtrl.buffCount = FightAniCtrl.buffCount + 1

	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("images/buffText.plist")

	local function AdddBuff()

		playEffect(MUSIC_SOUND_FIGHT_BUFF)

		for i,oneBuff in ipairs(result) do
			addOneBuff(oneBuff.sid,oneBuff.param)
		end
	end

	local actions = CCArray:create()
	actions:addObject(CCDelayTime:create(3 + 1.5 * FightAniCtrl.buffCount))
	actions:addObject(CCCallFunc:create(AdddBuff))
	FightingView.getSailorsLayer():runAction(CCSequence:create(actions))

	FightAniCtrl.next()
end


-- 初始化所有角色
local function ac_init(result)
	if not result then
		FightAniCtrl.next()
		return
	end
	FightingView.initHeadIcons()

	local soldiersCount = computeSoldiersCountOfEachSide()
	chooseArrangement(soldiersCount[1],soldiersCount[2])
	
	for i,one in ipairs(result) do
		if one then
			--人物动画资源
		    -- 初始化设置参数
		    local hp = one.hp
		    local maxHp = one.baseHp
		    local range = one.range
		    local skill = one.skill
		    local side = one.side
		    local posIndex = one.x

		    if one.side == "left" then
		    	side = battleCamp.left
		    elseif one.side == "right" then
		    	side = battleCamp.right
		    else
		    	side = battleCamp.left
		    end

		    local soldier = soldierBySid(one.sid)
		    soldier.m_curHP = hp
		    soldier.m_maxHP = maxHp
		    soldier.m_rang = range
		    soldier.m_skills = skill
		    -- 要重新设置位置
		    soldier.m_side = side
		    soldier.m_posIndex = posIndex

		    -- 设置头像细节，如：头像，背景颜色，等级，名字，HP等
		    FightingView.showHeadIcon(soldier.m_side,soldier.m_posIndex,true)

		    FightingView.setHeadIconImageAndName(soldier.m_side,soldier.m_posIndex,soldier.m_resId,soldier.m_name)
		    FightingView.setHeadIconColor(soldier.m_side,soldier.m_posIndex,soldier.m_rank)
		    FightingView.setHeadIconLevel(soldier.m_side,soldier.m_posIndex,soldier.m_level)
		    FightingView.setHeadIconHp(soldier.m_side, soldier.m_posIndex, soldier.m_curHP, soldier.m_maxHP)

			local dstPosition = FightAniCtrl.realPosition(soldier.m_side,soldier.m_posIndex)

			local array = CCArray:create()
			array:addObject(CCDelayTime:create(0.75 - soldier.m_side * 0.25))
			array:addObject(CCMoveTo:create(RandomManager.randomRange(1, 3) * 0.075,dstPosition))
			local function moveFinished()
				soldier:setZOrder(FightAniCtrl.arrangement[soldier.m_posIndex][3] * 10)
			    soldier.m_state = "start"
				soldier:updateState()
			end
			array:addObject(CCCallFunc:create(moveFinished))
			soldier:runAction(CCSequence:create(array))
		end
	end	
	FightAniCtrl.nActionCount = table.getTableCount(result)
end


-- move action
local function ac_force( result )
	if not result then
		return
	end

	FightAniCtrl.shouldRespondSpeed = false

	FightingView.initHeadIcons()

	local soldiersCount = computeSoldiersCountOfEachSide()
	chooseArrangement(soldiersCount[1],soldiersCount[2])
	
	for sid,soldier in pairs(FightAniCtrl.soldiers) do
		
	    -- 设置头像细节，如：头像，背景颜色，等级，名字，HP等
	    FightingView.showHeadIcon(soldier.m_side,soldier.m_posIndex,true)

	    FightingView.setHeadIconImageAndName(soldier.m_side,soldier.m_posIndex,soldier.m_resId,soldier.m_name)
	    FightingView.setHeadIconColor(soldier.m_side,soldier.m_posIndex,soldier.m_rank)
	    FightingView.setHeadIconLevel(soldier.m_side,soldier.m_posIndex,soldier.m_level)
	    FightingView.setHeadIconHp(soldier.m_side, soldier.m_posIndex, soldier.m_curHP, soldier.m_maxHP)

		local dstPosition = FightAniCtrl.realPosition(soldier.m_side,soldier.m_posIndex)
		soldier:setPosition(dstPosition)
	end	

	local r_hp = result[1].rightHP
	local l_hp = result[1].leftHP
	local r_int = result[1].rightInt
	local l_int = result[1].leftInt

	FightingView.forceAnimation(l_int,r_int,l_hp,r_hp)
end



-- 攻击回合
local function ac_attack( result )
	if not result then
		return
	end

---------------------------------------------------------------------------------------------------

	-- 计算有几个动作完成后执行next()
	FightAniCtrl.nActionCount = table.getTableCount(result)
	-- 攻击者
	local heroAttacking = nil
	-- 被攻击者们
	local herosAttacked = {}
	-- 是否有技能触发
	local hasSkill = false
	-- 触发技能者
	local heroPlayingSkill = nil
	-- 攻击特效
	local attackingEffect = nil
	-- 攻击特效位置偏移
	local attackingEffectOffset = {0,0}
	-- 是否有加防特效
	local isDefUp = false
	-- 是否有减伤特效
	local isDamageDec = false

---------------------------------------------------------------------------------------------------

	-- 遍历每一条log,分别处理，更新任务的各项状态属性：状态、血量、攻击技能、伤害类型等
	for i,one in ipairs(result) do
		local s = soldierBySid(one.sid)
		-- 位置序号：在几号位置
		s.m_posIndex = one.from.x

		if one.action == Action_Attack_Attack then
			s.m_state = "attack"

			heroAttacking = s
			-- 是先手吗？
			if FightAniCtrl.headStrike then
				s:showHeadStartIcon(one.side)
				-- 显示气势
				showFame()
				FightAniCtrl.headStrike = false
			end
			-- 攻击特效和位置偏移
			attackingEffect = herodata:getHeroAttackingEffectByResId(s.m_resId)
			attackingEffectOffset = herodata:getHeroAttackingEffectOffsetByResId(s.m_resId)
			-- 远程还是近身攻击
			if one.range and one.range == attackRange.longRange then
				s.m_attackingRange = attackRange.longRange
			else
				s.m_attackingRange = attackRange.closeRange
			end
			-- 是否使用了技能，是个table，其中有id和rank
			s.m_attackingSkill = one.skill
			
			if one.isCounter and one.isCounter == 1 then
				s.m_isCounter = 1
			else
				s.m_isCounter = 0
			end
			-- 如果释放技能，得到关于技能效果的配置
			if s.m_attackingSkill then
				hasSkill = true
				heroPlayingSkill = s
			end
		end

		-- 近距离攻击要记下被打的小兵，攻击的一方要跳到这个人的位置进行攻击，所以需要得到他的位置
		-- 而远距离攻击，则记下的小兵是最后读到的那个记录，其实是不合理的，因为可能几个人同时被打，
		-- 但是远距离攻击时，用不到这个小兵，其实是无意义的。
		-- 而且，攻击角色的攻击效果要加在被攻击角色的身上
		if one.action == Action_Attack_Attacked then

			s.m_state = "attacked"
			-- 把人物加入被攻击者们的table中
			table.insert(herosAttacked,s)

			-- 被攻击的类型，格挡parry、闪避dodge还是普通挨打hit
			s.m_attackedType = one.attackType
			-- 加防吗？
			s.m_defUp = one.def_up
			-- 减伤吗？
			s.m_damageDec = one.damage_dec

			-- 如果被攻击方加防，增加一个加防buff效果
			if s.m_defUp == 1 then
				heroAttacking.m_waitDefUp = true
				isDefUp = true
			end

			-- 如果被攻击方减伤，增加一个减伤buff效果
			if s.m_damageDec == 1 then
				heroAttacking.m_waitDamageDec = true
				isDamageDec = true
			end

			-- 如果有伤害效果，减血
			if one.hp and one.effect and one.effect.hp and one.effect.hp < 0 then
				s.m_curHP = (one.hp + one.effect.hp) > 0 and (one.hp + one.effect.hp) or 0
				-- 伤害效果
				local actionsArray = CCArray:create()
				-- 如果攻击的一方施放3级及以上的技能，需要展示半身像，战场全部人物冻住不动，所以需要暂停2.5秒
				if heroPlayingSkill and heroPlayingSkill.m_attackingSkill.rank > 2 then
					actionsArray:addObject(CCDelayTime:create(2.5))
				end

				-- 如果有加防，等一下特效时间
				if isDefUp then
					actionsArray:addObject(CCDelayTime:create(DefUpDelay))
				end

				-- 如果有减伤，等一下特效时间
				if isDamageDec then
					actionsArray:addObject(CCDelayTime:create(DamageDecDelay))
				end
				local function showDamageAndText()
					if s.m_attackedType == "cri" then
						s:showText("attacked_cri",1.5)
						s:showDamage(one.effect.hp,s.m_attackedType,1.5)
					else
						s:showDamage(one.effect.hp,s.m_attackedType,1)
					end
				end
				actionsArray:addObject(CCCallFunc:create(showDamageAndText))
				local FightingViewSpeed = CCSpeed:create(CCSequence:create(actionsArray),FightAniCtrl.aniSpeed)
				FightingView:getSailorsLayer():runAction(FightingViewSpeed)
			end
		end
		-- 触发不死
		if one.action == Action_Attack_UnDead then		
			s.m_state = "attacked"
			s.m_undead = 1	
			heroAttacking.m_waitUndead = true
			s.m_curHP = one.hp
		end

		-- 铁块：效果是另攻击自己的人受到伤害
		if one.action == Action_Attack_AggSkill then		
			s.m_state = "attacked"
			s.m_aggskill = 1
			heroAttacking.m_waitAggSkill = true
		end
		-- 被铁块反伤
		if one.action == Action_Attack_ReBound then	
			s.m_state = "attack"
			s.m_rebound = 1	
			s.m_reboundDamage = one.effect.hp
			s.m_curHP = (one.hp + one.effect.hp) > 0 and (one.hp + one.effect.hp) or 0
			s.m_reboundType = one.attackType
		end
		-- die
		if one.action == Action_Attack_Dead then
			-- 被反伤而死，状态依然是攻击，要播放攻击动画
			if s.m_rebound == 1 then
				s.m_state = "attack"
			else
			-- 如果正常死亡，则因为死亡的人有两条log：attacked和die，但是动画只播放die，所以动作计数器减1
				s.m_state = "die"				
				s.m_curHP = 0
				-- 死亡类型，是否秒杀等
				s.m_dyingType = one.type
				FightAniCtrl.nActionCount = FightAniCtrl.nActionCount - 1
			end
		end
	end
	-- 近身攻击时，被攻击者们的table中只有一条记录，找到之，记录其位置序号，因为攻击者需要跳过去攻击，需要目标位置
	for i,v in ipairs(herosAttacked) do
		if v.m_posIndex == heroAttacking.m_posIndex then
			FightAniCtrl.attackedSoldier = v
			break
		end
	end

---------------------------------------------------------------------------------------------------
	-- 下方头像和血条区域的状态更新
	local function updateAction()

		-- 根据以上更新的状态属性，每个人分别执行相应的动作
		for sid,soldier in pairs(FightAniCtrl.soldiers) do
			-- 攻击的一方
			if soldier.m_state == "attack" then	
				-- 头像播放攻击的时间轴动画
				local attackingHeadActions = CCArray:create()
				if isDefUp then
					attackingHeadActions:addObject(CCDelayTime:create(DefUpDelay))
				end
				if isDamageDec then
					attackingHeadActions:addObject(CCDelayTime:create(DamageDecDelay))
				end
				local function attackHeadAni()
					FightingView.showHeadIconAnimation(soldier.m_side,soldier.m_posIndex,"attackAnimation")
				end
				attackingHeadActions:addObject(CCCallFunc:create(attackHeadAni))

				local function attackBloodAni()
					FightingView.updateBloodBar(soldier.m_side,soldier.m_posIndex,soldier.m_curHP/soldier.m_maxHP)
				end
				local function setReboundHp()
				    FightingView.setHeadIconHp(soldier.m_side,soldier.m_posIndex,soldier.m_curHP, soldier.m_maxHP)
				end
				-- 受到铁块技能
				if soldier.m_rebound == 1 then
					attackingHeadActions:addObject(CCDelayTime:create(0.7))
					if soldier.m_waitUndead then
						attackingHeadActions:addObject(CCDelayTime:create(UndeadDelay))
					end
					attackingHeadActions:addObject(CCCallFunc:create(attackBloodAni))
					attackingHeadActions:addObject(CCDelayTime:create(0.7))
					attackingHeadActions:addObject(CCCallFunc:create(setReboundHp))
				end
				local attackHeadSpeed = CCSpeed:create(CCSequence:create(attackingHeadActions),FightAniCtrl.aniSpeed)
				FightingView.getSailorsLayer():runAction(attackHeadSpeed)

			elseif soldier.m_state == "attacked" or soldier.m_state == "die" then	
				-- 被攻击或者致死
				local attackedHeadActions = CCArray:create()
				if isDefUp then
					attackedHeadActions:addObject(CCDelayTime:create(DefUpDelay))
				end
				if isDamageDec then
					attackedHeadActions:addObject(CCDelayTime:create(DamageDecDelay))
				end
				local function attackedHeadAni()
					-- 头像播放被攻击的时间轴动画
					FightingView.showHeadIconAnimation(soldier.m_side,soldier.m_posIndex,"attackedAnimation")
					-- 头像更新血条（血条动画）
					FightingView.updateBloodBar(soldier.m_side,soldier.m_posIndex,soldier.m_curHP/soldier.m_maxHP)
				end
				attackedHeadActions:addObject(CCCallFunc:create(attackedHeadAni))
				attackedHeadActions:addObject(CCDelayTime:create(0.7))
				-- 头像更新血量值（label显示）
				local function setHp()
				    FightingView.setHeadIconHp(soldier.m_side,soldier.m_posIndex,soldier.m_curHP, soldier.m_maxHP)
				end
				attackedHeadActions:addObject(CCCallFunc:create(setHp))
				-- renzhan
				local attackedHeadSpeed = CCSpeed:create(CCSequence:create(attackedHeadActions),FightAniCtrl.aniSpeed)
				FightingView.getSailorsLayer():runAction(attackedHeadSpeed)

			    -- 对于挨打或者死亡的，要在其身上添加技能效果
			    -- 必须在此处stopAllActions()，而在做attacked或者die动画时不再stopAllActions()
			    -- 否则这里的动作将被取消不再执行，添加不上粒子效果
				-- 如果释放了技能的话，添加技能效果
			    if hasSkill then
					-- 技能效果的粒子文件、延时等
					local skillEffects = {}
					local skillConf = skilldata:getSkillConfig(heroPlayingSkill.m_attackingSkill.id)
					skillEffects = skillConf.eff
					if skillEffects then
						-- 根据技能配置中的数组，组成动作数组
						for effsk,effAttr in pairs(skillEffects) do
							-- action数组
							local effectsArray = CCArray:create()
							if isDefUp then					
								effectsArray:addObject(CCDelayTime:create(DefUpDelay))
							end
							if isDamageDec then					
								effectsArray:addObject(CCDelayTime:create(DamageDecDelay))
							end
					    	-- 先延时0.5s
							effectsArray:addObject(CCDelayTime:create(0.5))
							-- 如果有延时
							if effAttr.delay > 0 then
								effectsArray:addObject(CCDelayTime:create(effAttr.delay))
							end
							-- 调用一次添加粒子效果的function
							local function addEffects()
								-- 20150106 by zhaoyanqiu
								if effAttr.forField and effAttr.forField == 1 then
									-- 粒子效果不是加在每个被打的人身上，加在整个战场上，偏移数据以整个场景中心为原点计算

								    HLAddParticleScale( "images/"..effsk..".plist", FightingView.getSailorsLayer(), 
								    	ccp(winSize.width * ( 0.5 - effAttr.offsetX * soldier.m_side * retina ) , 
								    		winSize.height - 730 * 0.4 * retina - FightingLayerOwner["battleFieldHeight"] * (0.5 - effAttr.offsetY)), 
								    	100, 100, 100,-1*soldier.m_side/retina,1/retina)

								    effAttr.forField = 2
								else
									-- 粒子效果加在每个被打的人身上
								    HLAddParticleScale( "images/"..effsk..".plist", FightingView.getSailorsLayer(), ccp(soldier:getPositionX()-(175*effAttr.offsetX+30)*soldier.m_side*retina, soldier:getPositionY()+(128*effAttr.offsetY-16)*retina), 100, 100, 100,-1*soldier.m_side/retina,1/retina)
								end
							end
							effectsArray:addObject(CCCallFunc:create(addEffects))
							-- 执行动作序列
					    	-- renzhan
							local effectsSpeed = CCSpeed:create(CCSequence:create(effectsArray),FightAniCtrl.aniSpeed)
							FightingView.getSailorsLayer():runAction(effectsSpeed)
						end
				    end
			    else
			    	if attackingEffect then
			    		local waitAndPlayParticle = CCArray:create()
						if isDefUp then					
							waitAndPlayParticle:addObject(CCDelayTime:create(DefUpDelay))
						end
						if isDamageDec then		
							waitAndPlayParticle:addObject(CCDelayTime:create(DamageDecDelay))
						end
			    		waitAndPlayParticle:addObject(CCDelayTime:create(0.5))
			    		local function playSkillParticle()
							HLAddParticleScale(attackingEffect, FightingView.getSailorsLayer(), ccp(soldier:getPositionX()-(175*attackingEffectOffset[1]+30)*soldier.m_side*retina, soldier:getPositionY()+(128*attackingEffectOffset[2]-16)*retina), 100, 100, 100,-1*soldier.m_side/retina,1/retina)
			    		end
			    		waitAndPlayParticle:addObject(CCCallFunc:create(playSkillParticle))
			    		-- renzhan
						local attackingEffectSpeed = CCSpeed:create(CCSequence:create(waitAndPlayParticle),FightAniCtrl.aniSpeed)
						FightingView.getSailorsLayer():runAction(attackingEffectSpeed)
					end
				end
			end	
			-- 统一更新状态，根据状态去执行动作（即播放动画）
			soldier:updateState()
		end
	end

	local function playSkill()

		if herodata:getHeroConfig(heroPlayingSkill.m_resId) then

			local atkRoar = herodata:getHeroConfig(heroPlayingSkill.m_resId).maxAtkRoar_mp3
			local atkSound = herodata:getHeroConfig(heroPlayingSkill.m_resId).maxAtk_mp3
			if atkRoar then
				local skillSoundActions = CCArray:create()
				playEffect("audio/"..atkRoar..".mp3")
				skillSoundActions:addObject(CCDelayTime:create(0.5))
				local function playMaxAtk()
					playEffect("audio/"..atkSound..".mp3")
				end
				skillSoundActions:addObject(CCCallFunc:create(playMaxAtk))
				FightingView.getSailorsLayer():runAction(CCSequence:create(skillSoundActions))
			else
				playEffect("audio/"..atkSound..".mp3")
			end
		end

	    -- 技能名字
		local skillConf = skilldata:getSkillConfig(heroPlayingSkill.m_attackingSkill.id)
	    local skillName = skillConf.name
	    local skillImageName = string.gsub(heroPlayingSkill.m_attackingSkill.id,"book","skillname")

		if heroPlayingSkill.m_attackingSkill.rank <= 2 then
			playEffect(MUSIC_SOUND_FIGHT_SMALLSKILL)
			local enemySkillNameBg = CCSprite:create("images/EnemySkillNameBg.png")
			enemySkillNameBg:setPosition(ccp(winSize.width / 2, (winSize.height - 150 * retina - winSize.height / 2 * (1 - retina)) / retina))
			FightingView.getSailorsLayer():addChild(enemySkillNameBg,zSuperSkillBlackBg)
			enemySkillNameBg:setScaleY(0.1)
			enemySkillNameBg:setAnchorPoint(ccp(0.5,0.5))
			HLAddParticleScale( "images/enemySkillnamebg.plist", enemySkillNameBg, ccp(enemySkillNameBg:getContentSize().width / 2,enemySkillNameBg:getContentSize().height / 2), 1, 1, 1,1/retina,1/retina)
			local enemySkillNameLabel = CCSprite:create("images/"..skillImageName..".png")
			if not enemySkillNameLabel then
				enemySkillNameLabel = CCLabelTTF:create(skillName, "AmericanTypewriter", 50, CCSizeMake(enemySkillNameBg:getContentSize().width,0), kCCTextAlignmentCenter)
			else
				enemySkillNameLabel:setScale(0.7)
			end
			enemySkillNameBg:addChild(enemySkillNameLabel,1)
			enemySkillNameLabel:setAnchorPoint(ccp(0.5,0.5))
			enemySkillNameLabel:setPosition(ccp(enemySkillNameBg:getContentSize().width / 2,enemySkillNameBg:getContentSize().height / 2))
			local enemySkillNameActions = CCArray:create()
			enemySkillNameActions:addObject(CCScaleBy:create(0.25,1,10))
			enemySkillNameActions:addObject(CCDelayTime:create(1.2))
			local function enemySkillNameFadeOut()
				enemySkillNameBg:runAction(CCFadeOut:create(0.25))
				enemySkillNameLabel:runAction(CCFadeOut:create(0.25))
			end
			enemySkillNameActions:addObject(CCCallFunc:create(enemySkillNameFadeOut))
			local function enemySkillNameRemove()
				enemySkillNameBg:removeFromParentAndCleanup(true)
			end
			enemySkillNameActions:addObject(CCCallFunc:create(enemySkillNameRemove))
			-- renzhan
			local enemySkillNameBgSpeed = CCSpeed:create(CCSequence:create(enemySkillNameActions),FightAniCtrl.aniSpeed)
			enemySkillNameBg:runAction(enemySkillNameBgSpeed)

		else
			-- 半透明的黑色层
		    local blackLayerBg = CCLayerColor:create(ccc4(0, 0, 0, 155),winSize.width / retina,winSize.height / retina - 412 + 101)
		    FightingView.getSailorsLayer():addChild(blackLayerBg,zSuperSkillBlackBg) 
		    blackLayerBg:setPosition(ccp(winSize.width / 2 / retina * (retina - 1),(412 * retina - winSize.height / 2 * (1 - retina)) / retina))
		    blackLayerBg:setScaleX(-heroPlayingSkill.m_side)
			-- 背景粒子			
	        HLAddParticleScale( "images/eff_page_504.plist", blackLayerBg, ccp(0,blackLayerBg:getContentSize().height / 2), 5, 102, 100,1/retina,1/retina )
			-- 半身像
			local bust = CCSprite:create(herodata:getHeroBust1ByHeroId(heroPlayingSkill.m_resId))
			blackLayerBg:addChild(bust,zSuperSkillBust)
			bust:setAnchorPoint(ccp(0.5,0))
			local h = 65
		    bust:setPosition(ccp(blackLayerBg:getContentSize().width + bust:getContentSize().width ,h))
		    local bustActions = CCArray:create()
		    bustActions:addObject(CCMoveTo:create(0.25,ccp(blackLayerBg:getContentSize().width - bust:getContentSize().width * 0.4,h)))
		    bustActions:addObject(CCMoveTo:create(1,ccp(blackLayerBg:getContentSize().width - bust:getContentSize().width * 0.5,h)))
		    bustActions:addObject(CCMoveTo:create(0.25,ccp(-bust:getContentSize().width * 0.5,h)))
		    bust:runAction(CCSequence:create(bustActions))
			-- 三角
			local skillTriangle = CCSprite:create("images/skillTriangle.png")
			blackLayerBg:addChild(skillTriangle,zSuperSkillBust)
			skillTriangle:setAnchorPoint(ccp(0,0.5))
		    skillTriangle:setPosition(ccp(0,skillTriangle:getContentSize().height / 2))
		    skillTriangle:setScaleY(0.1)
		    skillTriangle:setScaleX(1)

		    local nameLabel = CCSprite:create("images/"..skillImageName..".png")
			if not nameLabel then
				if heroPlayingSkill.m_side == 1 then
					nameLabel = CCLabelTTF:create(skillName, "AmericanTypewriter", 75, CCSizeMake(skillTriangle:getContentSize().width,0), kCCTextAlignmentLeft)
				else
					nameLabel = CCLabelTTF:create(skillName, "AmericanTypewriter", 75, CCSizeMake(skillTriangle:getContentSize().width,0), kCCTextAlignmentRight)
				end
			end
			skillTriangle:addChild(nameLabel)
			nameLabel:setAnchorPoint(ccp(1,0.5))
            if opPCL == IOS_VIETNAM_EN or opPCL == IOS_GAMEVIEW_ENSAGA or opPCL == IOS_MOBNAPPLE_EN or opPCL == IOS_GAMEVIEW_EN or opPCL == ANDROID_GV_MFACE_EN 
            	or opPCL == ANDROID_GV_MFACE_EN_OUMEI or opPCL == ANDROID_GV_MFACE_EN_OUMEINEW or opPCL == ANDROID_VIETNAM_EN or opPCL == ANDROID_VIETNAM_EN_ALL 
            	or opPCL == IOS_MOBGAME_SPAIN or opPCL == ANDROID_MOBGAME_SPAIN or opPCL == WP_VIETNAM_EN or opPCL == IOS_GVEN_BREAK then
				nameLabel:setScale(1.25)
				nameLabel:setPosition(ccp(0 ,skillTriangle:getContentSize().height * 0.55))
				nameLabel:runAction(CCMoveTo:create(0.25,ccp(skillTriangle:getContentSize().width * 0.4,skillTriangle:getContentSize().height * 0.55)))
			else
				nameLabel:setScale(1.6)
				nameLabel:setPosition(ccp(0 ,skillTriangle:getContentSize().height * 0.46))
				nameLabel:runAction(CCMoveTo:create(0.25,ccp(skillTriangle:getContentSize().width * 0.4,skillTriangle:getContentSize().height * 0.46)))
			end

			if heroPlayingSkill.m_side == 1 then
				nameLabel:setFlipX(true)
			end

		    local triangleActions = CCArray:create()
		    triangleActions:addObject(CCScaleBy:create(0.25,1,10))
		    triangleActions:addObject(CCDelayTime:create(1.0))
		    local function allFadeOut()
		    	skillTriangle:runAction(CCFadeOut:create(0.25))
		    	nameLabel:runAction(CCFadeOut:create(0.25))
		    end
		    triangleActions:addObject(CCCallFunc:create(allFadeOut))
		    skillTriangle:runAction(CCSequence:create(triangleActions))
			-- 善后清除
			local layerActions = CCArray:create()
			layerActions:addObject(CCDelayTime:create(1.5))
			layerActions:addObject(CCFadeOut:create(0.5))
			local function layerFadeOut()
				blackLayerBg:removeFromParentAndCleanup(true)
			end
			layerActions:addObject(CCCallFunc:create(layerFadeOut))
			-- renzhan
			local blackLayerBgSpeed = CCSpeed:create(CCSequence:create(layerActions),FightAniCtrl.aniSpeed)
			blackLayerBg:runAction(blackLayerBgSpeed)

		end
	end
	if hasSkill then
	--如果有技能触发
		if heroPlayingSkill.m_attackingSkill.rank > 2 then
			-- 如果本轮技能等级大于2，是大技能，则pause2.5秒钟，播放无双动画再继续战斗
			local function pauseAndPlaySkill()
				for sid,s in pairs(FightAniCtrl.soldiers) do
			        CCDirector:sharedDirector():getActionManager():pauseTarget(s)
				end
				playSkill()
			end
			local function resumeAndUpdate()
				for sid,s in pairs(FightAniCtrl.soldiers) do
			        CCDirector:sharedDirector():getActionManager():resumeTarget(s)
				end
				updateAction()
			end
			local skillActions = CCArray:create()
			-- 为配合人物动作，先等待0.2秒
			skillActions:addObject(CCDelayTime:create(0.2))
			if isDefUp then
				skillActions:addObject(CCDelayTime:create(DefUpDelay))
			end
			if isDamageDec then
				skillActions:addObject(CCDelayTime:create(DamageDecDelay))
			end
			-- 冻住所有场上人物，播放大技能动画
			skillActions:addObject(CCCallFunc:create(pauseAndPlaySkill))
			-- 等待动画播放2秒
			skillActions:addObject(CCDelayTime:create(2.0))
			-- 解冻场上人物，并更新动作
			skillActions:addObject(CCCallFunc:create(resumeAndUpdate))
			-- renzhan
			local FightingViewSpeed = CCSpeed:create(CCSequence:create(skillActions),FightAniCtrl.aniSpeed)
			FightingView.getSailorsLayer():runAction(FightingViewSpeed)
		else
			-- 如果是小技能（无双）则不需要暂停
			-- 播放小技能动画（屏幕上方）
			local smallSkillActions = CCArray:create()
			if isDefUp then
				smallSkillActions:addObject(CCDelayTime:create(DefUpDelay))
			end
			if isDamageDec then
				smallSkillActions:addObject(CCDelayTime:create(DamageDecDelay))
			end
			local function playSmallSkill()
				playSkill()
			end
			smallSkillActions:addObject(CCCallFunc:create(playSmallSkill))
			local FightingViewSpeed = CCSpeed:create(CCSequence:create(smallSkillActions),FightAniCtrl.aniSpeed)
			FightingView.getSailorsLayer():runAction(FightingViewSpeed)
			-- 人物根据状态属性更新动作
			updateAction()
		end
	else
	-- 没有技能触发，人物根据状态属性更新动作
		updateAction()
	end
end

-- combo action
local function ac_combo( result )
	if not result then
		return
	end

	FightAniCtrl.nActionCount = 1

	for i,comboData in ipairs(result) do		
		local comboSoldier = soldierBySid(comboData.sid)
		comboSoldier.m_state = "combo"	
		comboSoldier:updateState()
		local param ={}
		param["2hit"] = 0.1
		addOneBuff(comboData.sid,param)
	end

end

-- round action
local function ac_round( result )
	if not result then
		return
	end

	local roundCount = result[1]
	if roundCount == 3 then
		FightAniCtrl.next()
	else
		FightingView.roundFightAnimation(roundCount)
	end
end

-- end action
local function ac_end( result )
	FightAniCtrl.next()
end

-- finish action
local function ac_finish( result )
	FightingView.fightEnd()
end


-- 加速
function FightAniCtrl.speed()

	if FightAniCtrl.aniSpeed + 0.2 < 10 then
		FightAniCtrl.aniSpeed = FightAniCtrl.aniSpeed + 0.2
	end
	if not FightAniCtrl.shouldRespondSpeed then
		FightAniCtrl.aniSpeed = NormalSpeed
	end
	for i,v in pairs(FightAniCtrl.soldiers) do
		if v and v.m_actionSpeed then
			v:setSpeed(FightAniCtrl.aniSpeed)
		end
	end
end

-- 加速
function FightAniCtrl.setTheSpeed(v)
	FightAniCtrl.aniSpeed = v
	for i,v in pairs(FightAniCtrl.soldiers) do
		if v and v.m_actionSpeed then
			v:setSpeed(FightAniCtrl.aniSpeed)
		end
	end
end

-- 取下一条log来画动画
function FightAniCtrl.next()
	local fa = BattleLog.nextLog()
	if not fa.result or table.getTableCount(fa.result) < 0 then
		FightAniCtrl.next()
		return
	end
	if fa.action == Action_Init then 
		-- 初始化
		ac_init(fa.result)
	elseif fa.action == Action_Layout then
		-- Buff
		ac_layout(fa.result)
	elseif fa.action == Action_Count then
		-- Buff
		ac_count(fa.result)
	elseif fa.action == Action_Fame then
		-- 结束
		ac_fame(fa.result)
	elseif fa.action == Action_Buff then
		-- Buff
		ac_buff(fa.result)
	elseif fa.action == Action_FieldBuff then
		-- Buff
		ac_fieldBuff(fa.result)
	elseif fa.action == Action_Attack then
		--攻击
		ac_attack(fa.result)
	elseif fa.action == Action_Combo then
		--攻击
		ac_combo(fa.result)
	elseif fa.action == Action_Round then
		--回合
		ac_round(fa.result) 
	elseif fa.action == Action_End then
		-- 结束
		ac_end(fa.result)
	elseif fa.action == Action_Force then
		-- 比内力
		ac_force(fa.result)
	elseif fa.action == Action_Finish then
		-- 结束
		ac_finish(fa.result)
	end
end


-- 动作结束
function actionFinished( soldier,actionStr )
	if soldier and soldier.m_state == "die" then
		local aniRes = soldier.m_resId
		local count = FightAniCtrl.plistDic[aniRes]
		if count > 0 then
			FightAniCtrl.plistDic[aniRes] = count - 1
		end
		removeSoldier(soldier)

		if count <= 1 then
			CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(herodata:getHeroAnimationByResId(aniRes))
			CCTextureCache:sharedTextureCache():removeUnusedTextures()
		end
	end
	FightAniCtrl.nActionCount = FightAniCtrl.nActionCount - 1
	if FightAniCtrl.nActionCount == 0 then
		FightAniCtrl.next()
	end
end
