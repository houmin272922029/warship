--
-- Author: Your Name
-- Date: 2016-02-22 14:48:06
--

--[[
	世界boss
	Author: Aaron Wei
	Date: 2015-12-01 18:57:34
]]

local LegionBoss = qy.class("Tank", qy.tank.view.BaseView)

function LegionBoss:ctor(entity,index)
    LegionBoss.super.ctor(self)

	self.entity = entity 
	
	self.PLAY = "play"
	self.STOP = "stop"
	self.SHOOT = "shoot"
	self.DEFENSE = "defense"
	self.HURT = "hurt"
	self.DIE = "die"

	self.dead = false

	-- 底层
	self.bottom = cc.Node:create()
	self:addChild(self.bottom,0)
	-- 中间层
	self.middle = cc.Node:create()
	self:addChild(self.middle,10)
	-- 顶层
	self.top = cc.Node:create()
	self:addChild(self.top,100)

	self.index = index --阵型索引
	
	self.body,self.barrel = nil
	self.dust,self.fire = nil
	self.model = qy.tank.model.BattleModel

	self.tipSequence = {}

	self.offset = cc.p(100,100)
end

function LegionBoss:onEnter()
	self:setPosition(self:getOrigin())
	self:create(self.entity)
end

function LegionBoss:onExit()
end

function LegionBoss:onCleanup()
end

-- 创建
function LegionBoss:create(entity)
	-- self.entity = entity 
	
	-- 坦克素材相关配置
	local pos = entity:getBuffPos()
	-- 血量标签
	self.bloodLabel = cc.Label:createWithSystemFont(qy.TextUtil:substitute(5005),"Helvetica", 12.0,cc.size(50,30))
    self.bloodLabel:setTextColor(cc.c4b(255,255,255,255))
    self.bloodLabel:setAnchorPoint(0,0)
    self.bloodLabel:setPosition(55,tonumber(pos.y)-7)
    -- self.top:addChild(self.bloodLabel)

    -- 士气标签
	self.moraleLabel = cc.Label:createWithSystemFont(qy.TextUtil:substitute(5006),"Helvetica", 12.0,cc.size(50,30))
    self.moraleLabel:setTextColor(cc.c4b(255,255,255,255))
    self.moraleLabel:setAnchorPoint(0,0)
    self.moraleLabel:setPosition(55,tonumber(pos.y)-17)
    -- self.top:addChild(self.moraleLabel)

    -- 坦克名标签 
	self.nameLabel = cc.Label:createWithTTF(entity.name,qy.res.FONT_NAME, 20.0,cc.size(300,0),1)
	self.nameLabel:enableOutline(cc.c4b(0,0,0,255),1)
	-- self.nameLabel:enableGlow(cc.c4b(0,0,0,255))
    self.nameLabel:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(entity.quality))
    self.nameLabel:setAnchorPoint(0.5,0)
    self.nameLabel:setPosition(0,tonumber(pos.y)+25)
    self.top:addChild(self.nameLabel)
	
	self:update(entity,1)
	self:__createBody()
	-- self:__createBarrel()
end

-- 销毁
function LegionBoss:destroy()
	-- self.update_timer:stop()
	self:stop()
	self:removeBarrel()
	if self:getParent() then
		self:getParent():removeChild(self)
	end
	self = nil
end

-- 创建坦克机身
function LegionBoss:__createBody()
	cc.SpriteFrameCache:getInstance():addSpriteFrames("tank/avatar/t85.plist")
	self.tank = cc.Sprite:createWithSpriteFrameName("t85_b.png")
	self.middle:addChild(self.tank)
	self.tank:setScale(1)
	
	-- local p = cc.DrawNode:create()
	-- p:drawDot({cc.p(0,0)},5,cc.c4b(1,0,0,1))
	-- self:addChild(p,999)

	-- qy.tank.utils.cache.CachePoolUtil.addArmatureFile("tank/boss/tank_fx_boss1",".png")
	-- self.body = ccs.Armature:create("tank_fx_boss1")
	-- self.body:setPosition(-350,450)
	-- self.middle:addChild(self.body)
	-- self.body:getAnimation():playWithIndex(0)

	-- local p = cc.DrawNode:create()
	-- p:drawDot({cc.p(0,0)},5,cc.c4b(1,0,0,1))
	-- self:addChild(p,999)
end

-- 停止炮管动画
function LegionBoss:removeBarrel()
	if tolua.cast(self.barrel,"cc.Node") then
		self.middle:removeChild(self.barrel)
		self.barrel = nil
	end
end

-- ================================================== Action Start ==================================================
-- 启动坦克
function LegionBoss:play()
	self:playWheel()
	self:playRandomMove()
end

-- 停止坦克 
function LegionBoss:stop()
	qy.Timer.remove("shoot_"..self.entity.direction.."_"..self.index)
	self:stopWheel()
	self:stopRandomMove()
	self:hideTrack()
end

-- 射击
function LegionBoss:shoot(skillID,loop)
	print("++++++++++++++++++++++++++++++ LegionBoss:shoot")
	local function shootOnce(count)
		if tolua.cast(self,"cc.Node") then
			self:__recoil()
			self:__playFire()
		end
	end
	self:playSkillBuffByID(skillID)
	qy.Timer.create("shoot_"..self.entity.direction.."_"..self.index,shootOnce,qy.BattleConfig.SHOOT_INTERVAL,loop)	
end

-- 中弹
function LegionBoss:hurt(skillID)
	print("++++++++++++++++++++++++++++++ LegionBoss:hurt",skillID,qy.Config.skill[tostring(skillID)])
	local id = qy.Config.skill[tostring(skillID)].defense_effect_id
	local name = "def_fx_"..tostring(id)
	local file = "fx/".. qy.language .."/skill/"..name
	qy.tank.utils.cache.CachePoolUtil.addArmatureFile(file)
	
	local pos = self.entity:getDefPos()
	local rotation = self.entity:getDefRotation()
	local scale = self.entity:getDefScale()
	if self.entity.direction == 1 then
    	self:playFx(self.top,name,pos,rotation,scale,false,0)
	else
    	self:playFx(self.top,name,pos,rotation,scale,false,1)
	end
	-- qy.QYPlaySound.playEffect(qy.SoundType.TANK_HIT) 
end

-- 阵亡
function LegionBoss:die()
	self.dead = true
	self:stop()
	self:removeMorale()
	self:removeHP()
	self:removeDefenseBuff()
	
	cc.SpriteFrameCache:getInstance():addSpriteFrames("tank/avatar/t85.plist")
	self.tank:setSpriteFrame("t85_b_die.png")
	
	-- 从阵型中移除
	-- self:fadeOut(self.tank,nil)
	self:leave(self,function()
		self:destroy()
	end)
end

-- 遗骸留下，跟随地图，渐行渐远
function LegionBoss:leave(target,callback)
	local distance = qy.BattleConfig.SPEED*qy.BattleConfig.TANK_DESTROY_TIME
	local px1,py1 = target:getPosition()
	local px2,py2
	-- local angle = math.pi - qy.BattleConfig.FORMATION_ANGLE1 - qy.BattleConfig.FORMATION_ANGLE2 - 0.03
	-- local angle = qy.BattleConfig.MAP_MOVE_ANGLE
	local angle = self.model:getMovementAngle(self.entity.direction)
	if self.entity.direction == 1 then
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

-- 撤退
function LegionBoss:retreat()
	-- self:stop()
	qy.Timer.remove("shoot_"..self.entity.direction.."_"..self.index)
	self:stopRandomMove()
	self:hideTrack()
	self:removeMorale()
	self:removeHP()
	-- 从阵型中移除
	self:move(2,2,350,function()
		self:destroy()
	end)
end

-- 遗骸消失，跟随地图，越来越淡
function LegionBoss:fadeOut(target,duration,callback)
	local act = cc.FadeOut:create(duration)
	if callback then
		local seq = cc.Sequence:create(act,cc.CallFunc:create(callback))
		target:runAction(seq)
	else
		target:runAction(act)
	end
end

-- 将目标添加到地面层
function LegionBoss:addToGround(target)
	local ground = self:getParent():getParent():getParent().ground
	local global_p
	local x,y = target:getPosition()
	if target:getParent() then
		global_p = target:getParent():convertToWorldSpace(cc.p(x,y))
		target:retain()
		target:getParent():removeChild(target)
		ground:addChild(target)
		target:release()	
	else
		global_p = self:convertToWorldSpace(cc.p(x,y))
		ground:addChild(target)
	end
	local local_p = ground:convertToNodeSpace(global_p)
	target:setPosition(local_p)
end

-- 位移 1前 2后 3左 4右
function LegionBoss:move(direction,duration,distance,callback)
	local px1,py1 = self:getPosition()
	local px2,py2,angle
	if direction == 1 then 
		angle = math.pi - qy.BattleConfig.FORMATION_ANGLE1 - qy.BattleConfig.FORMATION_ANGLE2
		if self.entity.direction == 1 then
			px2,py2 = px1+math.cos(angle)*distance,py1+math.sin(angle)*distance
		else
			px2,py2 = px1-math.cos(angle)*distance,py1-math.sin(angle)*distance
		end
	elseif direction == 2 then
		angle = math.pi - qy.BattleConfig.FORMATION_ANGLE1 - qy.BattleConfig.FORMATION_ANGLE2
		if self.entity.direction == 1 then
			px2,py2 = px1-math.cos(angle)*distance,py1-math.sin(angle)*distance
		else
			px2,py2 = px1+math.cos(angle)*distance,py1+math.sin(angle)*distance
		end
	elseif direction == 3 then
		angle = qy.BattleConfig.FORMATION_ANGLE1
		if self.entity.direction == 1 then
			px2,py2 = px1-math.cos(angle)*distance,py1+math.sin(angle)*distance
		else
			px2,py2 = px1+math.cos(angle)*distance,py1-math.sin(angle)*distance
		end
	elseif direction == 4 then
		angle = qy.BattleConfig.FORMATION_ANGLE1
		if self.entity.direction == 1 then
			px2,py2 = px1+math.cos(angle)*distance,py1-math.sin(angle)*distance
		else
			px2,py2 = px1-math.cos(angle)*distance,py1+math.sin(angle)*distance
		end
	end

	local act = cc.MoveTo:create(duration,cc.p(px2,py2))
	if callback then
		local seq = cc.Sequence:create(act,cc.CallFunc:create(callback))
		self:runAction(seq)
	else
		self:runAction(act)
	end
end

-- 开始随机运动
function LegionBoss:playRandomMove()
	local function randomMoveX(range)
		local dis = math.random(range)-0.5*range
		if math.abs(dis) >= 5 then
			local angle = qy.BattleConfig.FORMATION_ANGLE1 
			local px,py = self:getOrigin().x + dis*math.cos(angle),self:getOrigin().y - dis*math.sin(angle)
			local act = cc.MoveTo:create(3,cc.p(px,py))
			self:runAction(act)
		end
	end

	local function randomMoveY(range)
		local dis = math.random(range)-0.5*range
		if math.abs(dis) >= 5 then
			local angle = math.pi - qy.BattleConfig.FORMATION_ANGLE1 - qy.BattleConfig.FORMATION_ANGLE2
			local px,py = self:getOrigin().x + dis*math.cos(angle),self:getOrigin().y + dis*math.sin(angle)
			local act = cc.MoveTo:create(3,cc.p(px,py))
			self:runAction(act)
		end
	end
	qy.Timer.create("tank"..self.entity.direction.."_"..self.index,function()
		if tolua.cast(self,"cc.Node") then
			if math.random() > 1/2 then
				-- 运动
				-- randomMoveX(10)
				randomMoveY(150)
			else
				-- 不动
			end
		end
	end,4,0)
end

-- 停止随机运动
function LegionBoss:stopRandomMove()
	qy.Timer.remove("tank"..self.entity.direction.."_"..self.index)
	self:resetPosition()
end

-- 坐标复位
function LegionBoss:resetPosition()
	if self:getOrigin() then
		self:setPosition(self:getOrigin())
	end
	-- local act = cc.MoveTo:create(0.5,self:getOrigin())
	-- self:runAction(act)
end 

-- ================================================== Action End ==================================================

-- ================================================== Action Effect Start ==================================================
--[[
	播放履带尘土特效
	为优化性能，看不见一边的履带尘土不创建不显示
]] 
function LegionBoss:playWheel()
	if not tolua.cast(self.dust,"cc.Node") then
		local effect = ccs.Armature:create("tank_fx_lvdaiyan")
		self.dust = effect
		effect:getAnimation():playWithIndex(0,-1,1)
		local pos = self.entity:getWheelPos()
		effect:setScale(self.entity:getWheelScale())
		effect:setPosition(pos.x,pos.y)
		self.top:addChild(effect)
	end
end

-- 停止履带尘土
function LegionBoss:stopWheel()
	if tolua.cast(self.dust,"cc.Node") then
		if self.dust:getAnimation().stop then
			self.dust:getAnimation():stop()
		end
		self.dust:getParent():removeChild(self.dust)
	end
end

-- 播放发射火花
function LegionBoss:__playFire()
	qy.QYPlaySound.playEffect(qy.SoundType.T_FIRE)  
	local name = "att_fx_"..self.entity:getAttID()
	local file = "fx/".. qy.language .."/skill/"..name
	qy.tank.utils.cache.CachePoolUtil.addArmatureFile(file)

	local pos = self.entity:getAttPos()
	local rotation = self.entity:getAttRotation()
	local scale = self.entity:getAttScale()
	if self.entity.direction == 1 then
		self:playFx(self.top,name,pos,rotation,scale,false,0)
		self:playFx(self.top,name,pos,rotation,scale,false,0)
	else
		self:playFx(self.top,name,{x=-200,y=50},rotation,1,true,0)
		self:playFx(self.top,name,{x=-100,y=-80},rotation,1,true,0)
	end
end

-- 后坐力
function LegionBoss:__recoil(_offset)
	local offset = nil
	if _offset == nil then
		offset = 100
	else
		offset = 100
	end

	local px1,py1 = self:getPosition()
	local px2,py2
	local angle = math.pi - qy.BattleConfig.FORMATION_ANGLE1 - qy.BattleConfig.FORMATION_ANGLE2
	if self.entity.direction == 1 then
		px2,py2 = px1-math.cos(angle)*offset,py1-math.sin(angle)*offset
	else
		px2,py2 = px1+math.cos(angle)*offset,py1+math.sin(angle)*offset
	end
	-- local act1 = cc.MoveTo:create(0.01,cc.p(px2,py2)) -- 匀速
	-- local act1 = cc.EaseElasticInOut:create(cc.MoveTo:create(0.2,cc.p(px2,py2))) -- 弹性缓冲
	local act1 = cc.EaseExponentialInOut:create(cc.MoveTo:create(0.05,cc.p(px2,py2))) -- 指数缓冲
	-- local act1 = cc.EaseSineInOut:create(cc.MoveTo:create(0.1,cc.p(px2,py2))) -- sine缓冲
	-- local act1 = cc.EaseBackInOut:create(cc.MoveTo:create(0.2,cc.p(px2,py2))) -- 回震缓冲
	-- local act1 = cc.EaseBounceInOut:create(cc.MoveTo:create(0.1,cc.p(px2,py2))) -- 跳跃缓冲

	-- local act2 = cc.MoveTo:create(0.5,cc.p(px1,py1)) -- 匀速
	-- local act2 = cc.EaseElasticInOut:create(cc.MoveTo:create(0.5,cc.p(px1,py1))) -- 弹性缓冲
	-- local act2 = cc.EaseExponentialInOut:create(cc.MoveTo:create(0.5,cc.p(px1,py1))) -- 指数缓冲
	local act2 = cc.EaseSineOut:create(cc.MoveTo:create(1,cc.p(px1,py1))) -- sine缓冲
	-- local act2 = cc.EaseBackInOut:create(cc.MoveTo:create(0.5,cc.p(px1,py1))) -- 回震缓冲
	-- local act2 = cc.EaseBounceInOut:create(cc.MoveTo:create(0.5,cc.p(px1,py1))) -- 跳跃缓冲
	local seq = cc.Sequence:create(act1,act2,nil)
    self.act = cc.Repeat:create(seq,1)
	self:runAction(self.act)
end

function LegionBoss:__stopRecoil()
	if self.act then
		self:stopAction(self.act)
	end
end

-- 发射后的弹壳
function LegionBoss:__playShell()
	local effect = ccs.Armature:create("shell")
	if self.entity.direction == 1 then
		effect:setPosition(-50,0)
		effect:setScaleX(-1)
		effect:setRotation(0)
	else
		effect:setPosition(50,0)
	end
	self.top:addChild(effect)
	effect:getAnimation():playWithIndex(0)
	effect:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
	    if movementType == ccs.MovementEventType.complete then
	    	effect:getParent():removeChild(effect)
	    end
    end)
end

-- 履带碾压轨迹
function LegionBoss:__showTrack()
	-- local angle = qy.BattleConfig.TFORMATION_ANGLE2
	local function create()
		if tolua.cast(self,"cc.Node") then
			for i=1,2 do
				local track = cc.Sprite:createWithSpriteFrameName("tankTrack.png") 
				if tolua.cast(track,"cc.Node") then
					track:setRotation(10)
					if i == 1 then
						track:setPosition(0,0)
					else
						track:setPosition(0,-23)
					end
					self:addToGround(track)
					self:leave(track,function()
							track:getParent():removeChild(track)
							track = nil
						end)
					self:fadeOut(track,3,nil)
				else
					qy.Timer.remove("tank_track"..self.entity.direction.."_"..self.index)
				end
			end
		end
	end
	qy.Timer.create("tank_track"..self.entity.direction.."_"..self.index,create,0.55,-1)
end

function LegionBoss:hideTrack()
	qy.Timer.remove("tank_track"..self.entity.direction.."_"..self.index)
end
-- ================================================== Action Effect End ==================================================
-- ================================================== Skill Effect Start ==================================================
function LegionBoss:playFx(container,name,pos,rotation,scale,flipX,idx)
	print("++++++++++++++++++++++++++++++ LegionBoss:playFx",name)
	local effect = ccs.Armature:create(name)
	effect:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
		    if movementType == ccs.MovementEventType.complete then
		    	effect:getParent():removeChild(effect)
		    end
	    end)
	effect:setScale(scale)
	if flipX == true then
		effect:setScaleX(-scale)
	end
	effect:setPosition(pos.x,pos.y)
	effect:setRotation(rotation)
	container:addChild(effect)
	if idx == nil then
		effect:getAnimation():playWithIndex(0)
	else
		effect:getAnimation():playWithIndex(idx)
	end
	return effect
end
-- ================================================== Skill Effect End ==================================================
-- ==================================================  Buff&Tip Start ==================================================
function LegionBoss:update(data,_type)
	if _type == 1 then -- 初始化更新
		self:initUpdate(data)
	elseif _type == 2 then -- 战斗回合更新
		-- self.update_timer = qy.tank.utils.Timer.new(0.3,1,function()
		-- end)
		-- self.update_timer:start()
		self:fightUpdate(data)
	elseif _type == 3 then -- 跳过战斗更新
		self:skipUpdate(data)
	end	
end

function LegionBoss:initUpdate(data)
	self.entity.blood = data.blood
	self.entity.morale = data.morale
	self.entity.hurt = nil
	self.entity.add = nil
	self.entity.add_m = nil
	self.entity.steal_m = nil
	self.entity.is_dodge = nil

	-- 士气
	if data.morale then
		self:updateMorale()
	end

	-- 血量
	if data.blood then
		self:updateHP(false)
	end
end

function LegionBoss:fightUpdate(data)
	self.entity.blood = data.blood
	self.entity.morale = data.morale

	self.entity.hurt = data.hurt
	self.entity.add = data.add
	self.entity.add_m = data.add_m
	self.entity.steal_m = data.steal_m
	self.entity.is_dodge = data.is_dodge

	-- 缴械
	if data.type and data.type == 2 then
		self:forbid()
	end

	-- 闪避
	if data.is_dodge and data.is_dodge ~= 0 then
		self:dodge()
	end

	-- 士气
	if data.morale then
		self:updateMorale()
	end

	-- 士气变化
	if data.add_m ~= nil and data.add_m ~= 0 then
		-- self:showMoraleTip(self.entity.add_m)
	elseif data.type == 5 or data.type == 6 then -- 5:削减士气 6:偷取士气
		self:showMoraleTip(-1)
	end

	-- 血量
	if data.blood then
		self:updateHP(true)
	end

	-- 血量变化
	if data.hurt ~= nil then
		if data.hurt ~= 0 then
			self:showHPTip(-self.entity.hurt,true)
		end
	end

	if data.add ~= nil then
		if data.add ~= 0 then
			self:showHPTip(self.entity.add,true)
		else
			if data.type == 3 then -- 吸血
				self:showHPTip("+0",true)
			end
		end
	end
	
	-- 暴击
	if data.is_crit ~= nil and data.is_crit > 0 then
		self.isCrit = true
		self:crit()
	end

	self:popupTipSequence()
end

function LegionBoss:skipUpdate(data)
	self.entity.blood = data.blood
	self.entity.morale = data.morale
	self.entity.hurt = data.hurt
	self.entity.add = data.add
	self.entity.add_m = data.add_m
	self.entity.steal_m = data.steal_m
	self.entity.is_dodge = data.is_dodge

	-- 士气
	if data.morale then
		self:updateMorale()
	end

	-- 士气变化
	if data.add_m ~= nil and data.add_m ~= 0 then
		-- self:showMoraleTip(self.entity.add_m)
	elseif data.type == 5 or data.type == 6 then -- 5:削减士气 6:偷取士气
		self:showMoraleTip(-1)
	end

	-- 血量
	if data.blood then
		self:updateHP(true)
	end

	-- 血量变化
	if data.hurt ~= nil then
		if data.hurt ~= 0 then
			self:showHPTip(-self.entity.hurt,true)
		end
	end

	if data.add ~= nil then
		if data.add ~= 0 then
			self:showHPTip(self.entity.add,true)
		else
			if data.type == 3 then
				self:showHPTip("+0",true)
			end
		end
	end
	
	-- 暴击
	if data.is_crit and data.is_crit > 0 then
		self.isCrit = true
		self:crit()
	end

	self:popupTipSequence()
end

-- 更新血量条状态
function LegionBoss:updateHP(smooth)
	if self.entity and self.entity.blood then
		if tolua.cast(self.bloodLabel,"cc.Node") then
			self.bloodLabel:setString(tostring(self.entity.blood))
		end
		if not tolua.cast(self.bloodBar,"cc.Node") then
			self.bloodBar = qy.tank.widget.progress.BattleBloodBar.new()
			local pos = self.entity:getBuffPos()
	    	self.bloodBar:setPosition(tonumber(pos.x),tonumber(pos.y)+10)
	   		self.top:addChild(self.bloodBar)
		end
		if smooth then
	    	self.bloodBar:setPercent(self.entity.blood/self.entity.max_blood,true,true)
		else
	    	self.bloodBar:setPercent(self.entity.blood/self.entity.max_blood,true,false)
		end
	end
end

-- 移除血量条
function LegionBoss:removeHP()
	if tolua.cast(self.bloodLabel,"cc.Node") then
		self.top:removeChild(self.bloodLabel)
	end
	if tolua.cast(self.bloodBar,"cc.Node") then
		self.bloodBar:destroy()
   		self.top:removeChild(self.bloodBar)
	end
end

-- 改变血量&血量条&显示tip
function LegionBoss:changeHP(value)
	self.entity.blood = self.entity.blood + value
	self:updateHP(true)
	self:showHPTip(value,true)
end

--[[
	显示血量tip
	value:血量值
	delayShow:是否延时显示
	-- isCrit:是否暴击
]] 
function LegionBoss:showHPTip(value,delayShow)
	self:__createNumTip(value,20,delayShow)
end

function LegionBoss:updateMorale()
	if self.entity and self.entity.morale then
		if tolua.cast(self.moraleLabel,"cc.Node") then
			self.moraleLabel:setString(tostring(self.entity.morale))
		end
		if not tolua.cast(self.moraleBar,"cc.Node") then
			self.moraleBar = qy.tank.widget.progress.BattleMoraleBar.new()
			local pos = self.entity:getBuffPos()
	    	self.moraleBar:setPosition(tonumber(pos.x),tonumber(pos.y)+1)
	   		self.top:addChild(self.moraleBar)
		end
	    self.moraleBar:setPercent(self.entity.morale/self.entity.maxMorale)
	end
end

function LegionBoss:removeMorale()
	if tolua.cast(self.moraleLabel,"cc.Node") then
		self.top:removeChild(self.moraleLabel)
	end
	if tolua.cast(self.moraleBar,"cc.Node") then
   		self.top:removeChild(self.moraleBar)
	end
end

-- 改变士气&士气条&显示tip
function LegionBoss:changeMorale(value)
	self.entity.morale = self.entity.morale + value
	self:updateMorale(true)
	self:showMoraleTip(value,false)
end

function LegionBoss:showMoraleTip(value,show)
	if value then 
		local t = nil 
		if value > 0 then
			t = cc.Sprite:createWithSpriteFrameName("Resources/battle/t_shiqi_up.png")
		elseif value < 0 then
			t = cc.Sprite:createWithSpriteFrameName("Resources/battle/t_shiqi_down.png")
   		end
   		if show then
   			self:popupTip(t,30,0,1)
   		else
   			-- t:retain()
			table.insert(self.tipSequence,t)
   		end
   end
end

-- 暴击
function LegionBoss:crit()
	local t = cc.Sprite:createWithSpriteFrameName("Resources/battle/t_baoji.png")
	t.type = 2
	-- t:retain()
    table.insert(self.tipSequence,t)
end

-- 缴械
function LegionBoss:forbid()
	local t = cc.Sprite:createWithSpriteFrameName("Resources/battle/jx_0001.png")
	t.type = 2
	-- t:retain()
    table.insert(self.tipSequence,t)
    if not tolua.cast(self.forbidIcon,"cc.Node") then
    	self.forbidIcon = cc.Sprite:createWithSpriteFrameName("Resources/battle/jx_0002.png")
    	self.top:addChild(self.forbidIcon)
    	self.forbidIcon:setPosition(0,0)
    end
end

-- 取消缴械
function LegionBoss:unforbid()
	if tolua.cast(self.forbidIcon,"cc.Node") then
    	self.top:removeChild(self.forbidIcon)
    	self.forbidIcon = nil
    end
end

-- 闪避
function LegionBoss:dodge()
	if self.entity and self.entity.is_dodge and self.entity.is_dodge > 0 then
		t = cc.Sprite:createWithSpriteFrameName("Resources/battle/t_shanbi_blue.png")
		t.type = 2
		-- t:retain()
		t:setAnchorPoint(0.5,0.5)
	    table.insert(self.tipSequence,t)

		local px1,py1 = self:getPosition()
		-- local angle = qy.BattleConfig.FORMATION_ANGLE1
		local angle = math.pi - qy.BattleConfig.FORMATION_ANGLE1 - qy.BattleConfig.FORMATION_ANGLE2
		local distance = 30
		local px2,py2,px3,py3

		if self.entity.direction == 1 then
			px2,py2 = px1+math.cos(angle)*distance,py1+math.sin(angle)*distance
			px3,py3 = px1-math.cos(angle)*distance,py1-math.sin(angle)*distance
		else
			px2,py2 = px1-math.cos(angle)*distance,py1-math.sin(angle)*distance
			px3,py3 = px1+math.cos(angle)*distance,py1+math.sin(angle)*distance
		end

		local mov1 = cc.MoveTo:create(0.05,cc.p(px2,py2))
		local mov2 = cc.MoveTo:create(0.05,cc.p(px3,py3))
		local mov3 = cc.MoveTo:create(0.05,cc.p(px1,py1))
		local act = cc.Repeat:create(cc.Sequence:create(mov1,mov2,mov3),1)
		self:runAction(act)
   	end
end

function LegionBoss:__createNumTip(value,h,delayShow)
	local valueStr = nil
	local label = ccui.TextAtlas:create()
	local param = nil
	if type(value) == "number" then
		if value > 0 then
			param = qy.tank.utils.NumPicUtils.getNumPicInfoByType(3)
			valueStr = string.format(".%d", math.abs(value))
	    	label:setProperty(valueStr,param.numImg,param.width,param.height,".")
		elseif value < 0 then
			if self.isCrit then
				param = qy.tank.utils.NumPicUtils.getNumPicInfoByType(13)
			else
				param = qy.tank.utils.NumPicUtils.getNumPicInfoByType(2)
			end
			valueStr = string.format("/%d", math.abs(value))
	    	label:setProperty(valueStr,param.numImg,param.width,param.height,".")
	    else
	    	param = qy.tank.utils.NumPicUtils.getNumPicInfoByType(2)
			valueStr = string.format("%d", math.abs(value))
	    	label:setProperty(valueStr,param.numImg,param.width,param.height,".")
	    end
	elseif type(value) == "string" then
		if value == "+0" then
			param = qy.tank.utils.NumPicUtils.getNumPicInfoByType(3)
			valueStr = string.format(".%d", math.abs(value))
	    	label:setProperty(valueStr,param.numImg,param.width,param.height,".")
		elseif value == "-0" then
			param = qy.tank.utils.NumPicUtils.getNumPicInfoByType(2)
			valueStr = string.format(".%d", math.abs(value))
	    	label:setProperty(valueStr,param.numImg,param.width,param.height,".")
		end
	end

    if delayShow then
    	label:retain()
    	table.insert(self.tipSequence,label)
    else
    	self:popupTip(label,h,0,1)
    end
end

function LegionBoss:popupTip(target,h,delay,type)
	if target then
		target:setAnchorPoint(0.5, 0.5)
		target:setPosition(0,h)
		target:setScale(0)
		target:setOpacity(0)
		self.top:addChild(target)

		if type == 1 or type == nil then -- 普通弹出
			local act1_1 = cc.FadeIn:create(0.2)
			-- local act1_1 = cc.MoveTo:create(0.2, cc.p(target:getPositionX(), target:getPositionY()+h))
			-- local act1_2 = cc.EaseElasticInOut:create(cc.ScaleTo:create(0.5,1)) -- 弹性缓冲
			local act1_2 = cc.ScaleTo:create(0.2,1.5) -- 回震缓冲
			local act1_3 = cc.ScaleTo:create(0.1,1) -- 回震缓冲
			-- local act2 = cc.EaseBounceInOut:create(cc.ScaleTo:create(0.5,1)) -- 跳跃缓冲
			local seq1 = cc.Sequence:create(act1_2,act1_3)
			local spawn1 = cc.Spawn:create(act1_1,seq1)

			local act2_1 = cc.MoveTo:create(0.3, cc.p(target:getPositionX(), target:getPositionY()+60+h))
			local act2_2 = cc.FadeOut:create(0.3)
			local spawn2 = cc.Spawn:create(act2_1,act2_2)

			target:runAction(cc.Sequence:create(cc.DelayTime:create(delay),spawn1,cc.DelayTime:create(1),spawn2,cc.CallFunc:create(function()
				self.top:removeChild(target)
				target = nil
			end)))	
		elseif type == 2 then -- 夸张弹出
			local act1_1 = cc.FadeIn:create(0.2)
			-- local act1_1 = cc.MoveTo:create(0.2, cc.p(target:getPositionX(), target:getPositionY()+h))
			-- local act1_2 = cc.EaseElasticInOut:create(cc.ScaleTo:create(0.5,1)) -- 弹性缓冲
			local act1_2 = cc.ScaleTo:create(0.2,3) -- 回震缓冲
			local act1_3 = cc.ScaleTo:create(0.1,1) -- 回震缓冲
			-- local act2 = cc.EaseBounceInOut:create(cc.ScaleTo:create(0.5,1)) -- 跳跃缓冲
			local seq1 = cc.Sequence:create(act1_2,act1_3)
			local spawn1 = cc.Spawn:create(act1_1,seq1)

			local act2_1 = cc.MoveTo:create(0.3, cc.p(target:getPositionX(), target:getPositionY()+60+h))
			local act2_2 = cc.FadeOut:create(0.3)
			local spawn2 = cc.Spawn:create(act2_1,act2_2)

			target:runAction(cc.Sequence:create(cc.DelayTime:create(delay),spawn1,cc.DelayTime:create(1),spawn2,cc.CallFunc:create(function()
				self.top:removeChild(target)
				target = nil
			end)))	
		end
	end
end

function LegionBoss:popupTipSequence()
	local arr,idx = self.tipSequence,1
	-- self.tipSequence_timer = qy.tank.utils.Timer.new(0.1,#arr,function()
	-- 	if idx <= #arr then
	-- 		local target = arr[idx]
	-- 		print("++++++++++++++kkkkk",target,tolua.cast(target,"cc.Node"),idx)
	-- 		self:popupTip(target,0+idx*30,0.2)
	-- 		idx = idx + 1
	-- 	else
	-- 		self.tipSequence_timer:stop()
	-- 		self.tipSequence_timer = nil
	-- 		self.tipSequence = {}
	--      self.arr = {}
	-- 	end
	-- end)
	-- self.tipSequence_timer:start() 

	for i=1,#arr do
		local target = arr[i]
		self:popupTip(target,0+i*30,0.2,target.type)
	end
	self.tipSequence = {}
end

-- 状态复原
function LegionBoss:recover(data)
	if data.drop_t and data.drop_t == 2 then
		-- 恢复缴械
		self:unforbid()
	elseif data.drop_t == 3 then
		self:removeDefenseBuff()
	end
end

-- 反作用效果。作用于自身或己方
function LegionBoss:feedback(data)
	if data then
		if data.type == 1 or data.type == 6 then
			self:showMoraleTip(1,true)
			self.entity.morale = data.value
			self:updateMorale()
		elseif data.type == 2 then -- 加血技能
			self:addHpBuffFrom(data.change,data.value)			
		elseif data.type == 3 then -- 加护盾
			self:addDefenseBuff()
		end
	end
end

-- 主动加血技能
function LegionBoss:addHpBuffTo()
	self:playBuff(self.top,self.entity:getDefPos(),"buff_fx_jiaxueqs",1,nil,nil)
end

-- 被动加血技能
function LegionBoss:addHpBuffFrom(change,value)
	local x = self.entity:getDefPos().x
	local y = self.entity:getDefPos().y - 20
  	self:playBuff(self.bottom,cc.p(x,y),"buff_fx_jiaxue",0,nil,nil)
  	self:playBuff(self.top,self.entity:getDefPos(),"buff_fx_jiaxue",1,nil,nil)
  	if change ~= 0 then
		self:showHPTip(change,false)
	else
		self:showHPTip("+0",false)
	end
	self.entity.blood = value
	self:updateHP(false)
end

-- 添加护盾技能
function LegionBoss:addDefenseBuff()
	local x = self.entity:getDefPos().x
	local y = self.entity:getDefPos().y - 20
  	self.defense_buff = self:playBuff(self.top,cc.p(x,y),"buff_fx_fangyu",1,-1,1)
end

-- 移除护盾技能
function LegionBoss:removeDefenseBuff()
	if tolua.cast(self.defense_buff,"cc.Node") then
		if self.defense_buff:getAnimation().stop then
			self.defense_buff:getAnimation():stop()
		end
		self.defense_buff:getParent():removeChild(self.defense_buff)
	end
end

function LegionBoss:playSkillBuffByID(id)
	local skill_type = qy.Config.skill[tostring(id)].own_type
	if skill_type == 2 then -- 加血
		self:addHpBuffTo()
	elseif skill_type == 3 then -- 护盾
	end
end

function LegionBoss:playBuff(container,pos,name,idx,duration,loop)
	print("++++++++++++++++++++++++++++++ LegionBoss:playBuff",name,idx,duration,loop)
	qy.tank.utils.cache.CachePoolUtil.addArmatureFile("fx/".. qy.language .."/buff/"..name)
	local buff = ccs.Armature:create(name)
	buff:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
		    if movementType == ccs.MovementEventType.complete then
		    	buff:getParent():removeChild(buff)
		    end
	    end)
	buff:setPosition(pos)
	container:addChild(buff)
	buff:getAnimation():playWithIndex(idx,duration,loop)
	return buff
end

function LegionBoss:setIndex(idx)
	self.index = idx
	-- self.indexLabel:setString(tostring(idx))
end

function LegionBoss:runCustomizeAction(actions)
end

function LegionBoss:getOrigin()
	return cc.p(self.origin.x+self.offset.x,self.origin.y+self.offset.y)
end

-- ==================================================  Buff End ==================================================

return LegionBoss
