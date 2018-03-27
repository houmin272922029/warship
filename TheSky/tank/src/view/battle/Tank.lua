--[[
	坦克avatar类
	Author: Aaron Wei
	Date: 2015-01-14 18:38:16
]]

--[[
	skill type
	1
	2:缴械
	3:吸血
	4
	5 削弱士气
	6 偷取士气
]]

--[[
	own skill type
	1:加士气
	2:治疗量
	3:增加护盾
	4:按攻击力给己方治疗
	5:解除己方攻击力最高的战车的负面状态使其代替自己进行攻击
	6:偷取对方士气
	7:增加伤害千分比持续一回合
	8:减士气
	9:掉伤害
	10:加命中
]]


local Tank = qy.class("Tank", qy.tank.view.BaseView)

function Tank:ctor(entity,index)
    Tank.super.ctor(self)

	self.entity = entity
	-- 坦克动作，坦克本身只有fire动作，其他动作均由特效产生
	self.PLAY = "play"
	self.STOP = "stop"
	self.SHOOT = "shoot"
	self.DEFENSE = "defense"
	self.HURT = "hurt"
	self.DIE = "die"

	self.dead = false
	self.isBloodUpdate = true

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
	self.tank,self.barrel = nil
	self.dust,self.fire,self.light = nil
	self.model = qy.tank.model.BattleModel

	self.tipSequence = {}

	-- 索引标签
	-- self.indexLabel = cc.Label:createWithSystemFont("","Helvetica", 18.0,cc.size(50,30))
	-- self.indexLabel:setTextColor(cc.c4b(255,255,0,255))
	-- self.indexLabel:setAnchorPoint(0,0)
	-- self.indexLabel:setPosition(0,10)
    -- self:addChild(self.indexLabel,1000)
end

function Tank:onEnter()
	self:create(self.entity)
end

function Tank:onExit()
end

function Tank:onCleanup()
end

-- 创建
function Tank:create(entity)
	-- self.entity = entity

	-- 坦克素材相关配置
	local pos = entity:getBuffPos()
	-- 血量标签
	-- self.bloodLabel = cc.Label:createWithSystemFont(qy.TextUtil:substitute(5007),"Helvetica", 12.0,cc.size(50,30))
    -- self.bloodLabel:setTextColor(cc.c4b(255,0,0,255))
    -- self.bloodLabel:setAnchorPoint(0,0)
    -- self.bloodLabel:setPosition(55,tonumber(pos.y)-7)
    -- self.top:addChild(self.bloodLabel)

    -- 士气标签
	self.moraleLabel = cc.Label:createWithSystemFont(qy.TextUtil:substitute(5008),"Helvetica", 12.0,cc.size(50,30))
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

	self:__createBody()
	self:__createBarrel()
	self:update(entity,1)
end

-- 销毁
function Tank:destroy()
	-- self.update_timer:stop()
	self:stop()
	self:removeBarrel()
	if self:getParent() then
		self:getParent():removeChild(self)
	end
	self = nil
end

-- 创建坦克机身
function Tank:__createBody()
	-- local spr = cc.SpriteFrameCache:getInstance():getSpriteFrame("t99.png")
	if cc.SpriteFrameCache:getInstance():getSpriteFrame(self.entity:getBodyRes()) == nil then
		qy.tank.utils.cache.CachePoolUtil.addPlist("tank/avatar/t"..self.entity:getResID())
	end
	self.tank = cc.Sprite:createWithSpriteFrameName(self.entity:getBodyRes())
	self.middle:addChild(self.tank)
	self.tank:setScale(1)

	-- local p = cc.DrawNode:create()
	-- p:drawDot({cc.p(0,0)},5,cc.c4b(1,0,0,1))
	-- self:addChild(p,999)
end

-- 创建炮管
function Tank:__createBarrel()
	if not tolua.cast(self.barrel,"cc.Node") then
		if cc.SpriteFrameCache:getInstance():getSpriteFrame(self.entity:getBarrelRes()) == nil then
			qy.tank.utils.cache.CachePoolUtil.addPlist("tank/avatar/t"..self.entity:getResID())
		end
		self.barrel = cc.Sprite:createWithSpriteFrameName(self.entity:getBarrelRes())
		self.middle:addChild(self.barrel)
	end
end

-- 播放炮管动画
function Tank:__playBarrel()
	if tolua.cast(self.barrel,"cc.Node") then
		self.middle:removeChild(self.barrel)
		self.barrel = nil
	end
	self.barrel = qy.tank.widget.FrameAnimation.new(self.entity:getResPrefix(),5,0.05,1,function()
		self.barrel:getParent():removeChild(self.barrel)
		self.barrel = nil
		self:__createBarrel()
	end)
	self.middle:addChild(self.barrel)
	self.barrel:play()
end

-- 停止炮管动画
function Tank:removeBarrel()
	if tolua.cast(self.barrel,"cc.Node") then
		self.middle:removeChild(self.barrel)
		self.barrel = nil
	end
end

-- ================================================== Action Start ==================================================
-- 启动坦克
function Tank:play()
	self:playWheel()
	self:playRandomMove()
	-- self:__showTrack()
end

-- 停止坦克
function Tank:stop()
	qy.Timer.remove("shoot_"..self.entity.direction.."_"..self.index)
	self:stopWheel()
	self:stopRandomMove()
	self:hideTrack()
end

-- 射击
function Tank:shoot(skillID,loop,isShoot)
	print("++++++++++++++++++++++++++++++ Tank:shoot")
	local function shootOnce(count)
		if tolua.cast(self,"cc.Node") then
			self:__recoil()
			self:__playBarrel()
			self:__playFire()
			-- self:__playShell()
			self:__playDust()
		end
	end
	self:playSkillBuffByID(skillID)
	if isShoot ~= 0 then
		qy.Timer.create("shoot_"..self.entity.direction.."_"..self.index,shootOnce,qy.BattleConfig.SHOOT_INTERVAL,loop)
	end
end

-- 中弹
function Tank:hurt(skillID)
	print("++++++++++++++++++++++++++++++ Tank:hurt",skillID,qy.Config.skill[tostring(skillID)])
	if skillID ~= 0 then
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
	else
		-- 分担伤害
	end
end

-- 阵亡
function Tank:die()
	self.dead = true
	self:removeBarrel()
	self:stop()
	self:removeMorale()
	self:removeHP()
	self:removeBlew()
	self:removeDefenseBuff()
	self:removeBaoHuZhao()--M48a1移除护盾技能
	self:removeDianRan()--点燃
	self:removeHuomiao()--火苗
	self:removeSanJiao()
	self:removeHurtBuff()
	self:removeConfusion()
	self:removeInvincible()
	if cc.SpriteFrameCache:getInstance():getSpriteFrame(self.entity:getDieRes()) == nil then
		qy.tank.utils.cache.CachePoolUtil.addPlist("tank/avatar/t"..self.entity:getResID())
	end
	self.tank:setSpriteFrame(self.entity:getDieRes())
	-- 从阵型中移除
	-- self:fadeOut(self.tank,nil)
	self:leave(self,function()
		self:destroy()
	end)
end

-- 遗骸留下，跟随地图，渐行渐远
function Tank:leave(target,callback)
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
function Tank:retreat()
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
function Tank:fadeOut(target,duration,callback)
	local act = cc.FadeOut:create(duration)
	if callback then
		local seq = cc.Sequence:create(act,cc.CallFunc:create(callback))
		target:runAction(seq)
	else
		target:runAction(act)
	end
end

-- 将目标添加到地面层
function Tank:addToGround(target)
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
function Tank:move(direction,duration,distance,callback)
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
function Tank:playRandomMove()
	local function randomMoveX(range)
		local dis = math.random(range)-0.5*range
		if math.abs(dis) >= 1 then
			local angle = qy.BattleConfig.FORMATION_ANGLE1
			local px,py = self.origin.x + dis*math.cos(angle),self.origin.y - dis*math.sin(angle)
			local act = cc.MoveTo:create(2,cc.p(px,py))
			self:runAction(act)
		end
	end

	local function randomMoveY(range)
		local dis = math.random(range)-0.5*range
		if math.abs(dis) >= 5 then
			local angle = math.pi - qy.BattleConfig.FORMATION_ANGLE1 - qy.BattleConfig.FORMATION_ANGLE2
			local px,py = self.origin.x + dis*math.cos(angle),self.origin.y + dis*math.sin(angle)
			local act = cc.MoveTo:create(2,cc.p(px,py))
			self:runAction(act)
		end
	end
	qy.Timer.create("tank"..self.entity.direction.."_"..self.index,function()
		if tolua.cast(self,"cc.Node") then
			if math.random() > 2/3 then
				-- 运动
				-- randomMoveX(10)
				randomMoveY(50)
			else
				-- 不动
			end
		end
	end,2,0)
end

-- 停止随机运动
function Tank:stopRandomMove()
	qy.Timer.remove("tank"..self.entity.direction.."_"..self.index)
	self:resetPosition()
end

-- 坐标复位
function Tank:resetPosition()
	if self.origin then
		self:setPosition(self.origin)
	end
	-- local act = cc.MoveTo:create(0.5,self.origin)
	-- self:runAction(act)
end

-- ================================================== Action End ==================================================

-- ================================================== Action Effect Start ==================================================
--[[
	播放履带尘土特效
	为优化性能，看不见一边的履带尘土不创建不显示
]]
function Tank:playWheel()
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
function Tank:stopWheel()
	if tolua.cast(self.dust,"cc.Node") then
		if self.dust:getAnimation().stop then
			self.dust:getAnimation():stop()
		end
		self.dust:getParent():removeChild(self.dust)
	end
end

-- 播放发射火花
function Tank:__playFire()
	qy.QYPlaySound.playEffect(qy.SoundType.T_FIRE)
	local name = "att_fx_"..self.entity:getAttID()
	local file = "fx/".. qy.language .."/skill/"..name
	qy.tank.utils.cache.CachePoolUtil.addArmatureFile(file)

	local pos = self.entity:getAttPos()
	local rotation = self.entity:getAttRotation()
	local scale = self.entity:getAttScale()
	if self.entity.direction == 1 then
		self:playFx(self.top,name,pos,rotation,scale,false,0)
	else
		self:playFx(self.top,name,pos,rotation,scale,true,0)
	end
end

-- 播放光晕
function Tank:playLight(loop)
	-- function remove()
	-- 	if tolua.cast(self.light,"cc.Node") then
	-- 		self.light:remove()
	-- 	end
	-- end
	-- remove()
	-- if not tolua.cast(self.light,"cc.Node") then
	--     local frames = {}
	--     for i =1,2 do
	--         local frame = "light1_"..i..".png"
	--         table.insert(frames,frame)
	--    	end
	-- 	self.light = qy.tank.widget.FrameAnimation.new(frames,0)
	-- 	self.bottom:addChild(self.light)
	-- end
	-- self.light:play(0.1,loop,remove)
end

-- 后坐力
function Tank:__recoil(_offset)
	local offset = nil
	if _offset == nil then
		offset = 30
	else
		offset = 30
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

function Tank:__stopRecoil()
	if self.act then
		self:stopAction(self.act)
	end
end

-- 后坐力尘土
function Tank:__playDust()
	local effect = ccs.Armature:create("tank_fx_dust")
	effect:setScale(2)
	self:addToGround(effect)
	self:leave(effect)
	effect:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
	    if movementType == ccs.MovementEventType.complete then
	    	effect:getParent():removeChild(effect)
	    end
    end)
	effect:getAnimation():playWithIndex(0)
end

-- 发射后的弹壳
function Tank:__playShell()
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
function Tank:__showTrack()
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

function Tank:hideTrack()
	qy.Timer.remove("tank_track"..self.entity.direction.."_"..self.index)
end
-- ================================================== Action Effect End ==================================================
-- ================================================== Skill Effect Start ==================================================
function Tank:playFx(container,name,pos,rotation,scale,flipX,idx)
	print("++++++++++++++++++++++++++++++ Tank:playFx",name)
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
function Tank:update(data,_type)
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

function Tank:initUpdate(data)
	self.entity.blood = data.blood
	self.entity.morale = data.morale
	self.entity.hurt = nil
	self.entity.add = nil
	self.entity.add_m = nil
	self.entity.steal_m = nil
	self.entity.is_dodge = nil
	self.entity.not_move = 0--死亡后是否移除 1为不移除

	-- 士气
	if data.morale then
		self:updateMorale()
	end

	-- 血量
	if data.blood then
		self:updateHP(false)
	end

	if data.max_blood_shield then
		self:addBaoHuZhao()
	end
end

-- 出手更新
function Tank:fightUpdate(data)--attack中的数据

	self.entity.morale = data.morale

	self.entity.hurt = data.hurt
	self.entity.add = data.add
	self.entity.add_m = data.add_m
	self.entity.steal_m = data.steal_m
	self.entity.is_dodge = data.is_dodge

	if data.type and data.type == 2 then -- 缴械
		self:forbid()
	end

	if data.type and data.type == 8 then -- 命中
		self:mingzhong()
	end

	if data.type and data.type == 11 then -- 伤害
		self:addHurtBuff()
	end

	if data.type and data.type == 12 then -- 死亡伤害
		self:addDeadHornBuff()
	end	

	if data.type and data.type == 25 then -- 三角
		self:addSanJiao()
	end	

	if data.add_t and #data.add_t then -- 灭火
		for i=1,#data.add_t do
			if data.add_t[i] == 8 then
				self:addOutfire()
			end
		end
	end

	if data.death_horn then
		self:removeDeadHornBuff(data.death_horn.hurt)
	end

	if data.burning then
		self:showHPTip(-data.burning.hurt,true)
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
	elseif data.type == 5 or data.type == 6 or data.type == 15 then -- 5:削减士气 6:偷取士气 15:泯灭
		self:showMoraleTip(-1)
	end

	-- 血量
	if data.blood and self.isBloodUpdate then
		self.entity.blood = data.blood
		self:updateHP(true)
	else
		self.isBloodUpdate = true
	end

	-- if data.blood then
	-- 	self.entity.blood = data.blood
	-- 	self:updateHP(true)
	-- end

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

	-- 取消护盾
	if data.drop_t == 3 then
		self:removeDefenseBuff()
	end

	if data.drop_t == 20 and self.entity.blood > 0 then
		self:removeDefenseBuff()--普通移除护盾
		self:removeBaoHuZhao()--M48a1移除护盾技能
	end

	if data.drop_t == 6 then
		self:removeHurtBuff()
	end

	if data.drop_t == 19 then -- 三角
		self:removeSanJiao()
	end

	self:popupTipSequence()

	-- 进攻方主动清除状态
	if data.clean and #data.clean then
		for i=1,#data.clean do
			local d = data.clean[i]
			local tank = self.model["tankList"..(d.from+1)][d.pos]
			tank:recover(d)
		end
	end
end


function Tank:skipUpdate(data)
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
	elseif data.type == 5 or data.type == 6 or data.type == 15 then -- 5:削减士气 6:偷取士气 15:泯灭
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
function Tank:updateHP(smooth,delay)
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

		delay = (delay == nil) and true or delay
		print("Tank:updateHP smooth =",smooth,"delay =",delay,"blood =",self.entity.blood)
	    self.bloodBar:setPercent(self.entity.blood/self.entity.max_blood,delay,smooth)

		if (self.entity.blood == nil or self.entity.blood <= 0) and self.entity.not_move == 0 then
			self:die()
		end
	end
end

-- 移除血量条
function Tank:removeHP()
	if tolua.cast(self.bloodLabel,"cc.Node") then
		self.top:removeChild(self.bloodLabel)
	end
	if tolua.cast(self.bloodBar,"cc.Node") then
		self.bloodBar:destroy()
   		self.top:removeChild(self.bloodBar)
	end
end

-- 改变血量&血量条&显示tip
function Tank:changeHP(value)
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
function Tank:showHPTip(value,delayShow)
	print("++++++++++++++++++++++++++++++ showHPTip",value)
	self:__createNumTip(value,20,delayShow)
	-- self:__createNumTip(-9999,20,delayShow)
end


function Tank:updateMorale()
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
	    -- self.moraleBar:setPercent(self.entity.morale/self.entity.maxMorale)
	    self.moraleBar:setPercent(self.entity.morale)
	end
end

function Tank:removeMorale()
	if tolua.cast(self.moraleLabel,"cc.Node") then
		self.top:removeChild(self.moraleLabel)
	end
	if tolua.cast(self.moraleBar,"cc.Node") then
   		self.top:removeChild(self.moraleBar)
	end
end

-- 改变士气&士气条&显示tip
function Tank:changeMorale(value)
	self.entity.morale = self.entity.morale + value
	self:updateMorale(true)
	self:showMoraleTip(value,false)
end

function Tank:showMoraleTip(value,show)
	if value then
		local t = nil
		cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/battle/battle.plist")
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
function Tank:crit()
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/battle/battle.plist")
	local t = cc.Sprite:createWithSpriteFrameName("Resources/battle/t_baoji.png")
	t.type = 2
	-- t:retain()
    table.insert(self.tipSequence,t)
end

-- 缴械
function Tank:forbid()
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/battle/battle.plist")
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
function Tank:unforbid()
	if tolua.cast(self.forbidIcon,"cc.Node") then
    	self.top:removeChild(self.forbidIcon)
    	self.forbidIcon = nil
    end
end

-- 减命中
function Tank:mingzhong()
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/battle/battle.plist")
	local t = cc.Sprite:createWithSpriteFrameName("Resources/battle/hit.png")
    table.insert(self.tipSequence,t)
end
-- 加命中
function Tank:mingzhongUp()
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/battle/battle.plist")
	local t = cc.Sprite:createWithSpriteFrameName("Resources/battle/mingzhong_up.png")
	self:popupTip(t,30,0,1)
end


-- 闪避
function Tank:dodge()
	if self.entity and self.entity.is_dodge and self.entity.is_dodge > 0 then
		cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/battle/battle.plist")
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

function Tank:__createNumTip(value,h,delayShow)
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
			valueStr = string.format("/%d", math.abs(value))
	    	label:setProperty(valueStr,param.numImg,param.width,param.height,".")
	    end
	elseif type(value) == "string" then
		if value == "+0" then
			param = qy.tank.utils.NumPicUtils.getNumPicInfoByType(3)
			valueStr = string.format(".%d", math.abs(value))
	    	label:setProperty(valueStr,param.numImg,param.width,param.height,".")
		elseif value == "-0" then
			param = qy.tank.utils.NumPicUtils.getNumPicInfoByType(2)
			valueStr = string.format("/%d", math.abs(value)) 
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

-- 弹出单个tip
function Tank:popupTip(target,h,delay,type)
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

-- 弹出tip序列
function Tank:popupTipSequence()
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
function Tank:recover(data)
	print("还hi我中单",data.status)
	if not data.op_type or data.op_type == 0 then -- 旧回合结束状态重置
		if data.drop_t and data.drop_t == 2 then
			-- 恢复缴械
			self:unforbid()
		elseif data.drop_t == 3 then
			self:removeDefenseBuff()
		elseif data.drop_t == 6 then
			self:removeHurtBuff()
		elseif data.drop_t == 7 then
			self:removeDeadHornBuff()
		elseif data.drop_t == 8 then
			self:removeOutfire()
		elseif data.drop_t == 9 then
			self:removeFanshang()
		elseif data.drop_t == 10 then
			self:removeConfusion() -- 清除混乱状态 
		elseif data.drop_t == 11 then -- 清除胆怯状态
			self:removeTimidity()
		elseif data.drop_t == 12 then -- 清除无敌状态
			self:removeInvincible()
		elseif data.drop_t == 13 then -- 清除嘲讽状态
			self:removeChaofeng()
		elseif data.drop_t == 14 then -- 清除嘲讽状态
			self:removeChaofeng1()
		elseif data.drop_t == 15 then -- 清除减疗状态
			self:removeJianliao()
		elseif data.drop_t == 16 then -- 清除无视防御
			self:removeIgnoredefense()
		elseif data.drop_t == 17 then -- 清除锁链状态
			self:removeBlockade()
		elseif data.drop_t == 18 then -- 清除锁链状态
			self:die()
		elseif data.drop_t == 19 then --清除生命链接
			self:removeSanJiao()
		elseif data.drop_t == 21 then --清除点燃
			print("下边drop")
			self:removeDianRan()
			self:removeHuomiao()
		elseif data.drop_t == 22 then --清除点燃
			self:removeHuomiao()
			self:removeDianRan()
		elseif data.drop_t == 23 then --清除点燃
			self:removeHuomiao()
			self:removeDianRan()
		end
	elseif data.op_type == 1 then -- 新回合结束状态重置
		if data.status == 8 then
			self:addOutfire()
		elseif data.status == 10 then
			self:removeConfusion() -- 清除混乱状态
		elseif data.status == 21 then
			self:addDianRan() 
			self:addHuomiao(data.pos,1) 
		end
	end
end


-- 反作用效果。作用于自身或己方
function Tank:feedback(data)
	if data then
		if not data.op_type or data.op_type == 0 then
			if data.type == 1 or data.type == 6 then
				self:showMoraleTip(1,true)
				self.entity.morale = data.value
				self:updateMorale()
			elseif data.type == 2 or data.type == 4 then -- 加血技能
				self:addHpBuffFrom(data.change,data.value)
			elseif data.type == 3 then -- 加护盾
				self:addDefenseBuff()
			elseif data.type == 5 then -- 替身
				self:addReplaceSkillFrom()
			elseif data.type == 7 then 
				self:skill_334_to(data.change,data.value)
			elseif data.type == 11 then
				self:addHurtBuff()
			elseif data.type == 8 then
				self:showMoraleTip(-1,true)
				self.entity.morale = data.value
				self:updateMorale()
			elseif data.type == 9 then
				qy.tank.utils.Timer.new(0.5,1,function()
            		self.entity.blood =  self.entity.blood - data.change
					self:updateHP(true)
					self:showHPTip(-data.change,false)
        		end):start()
			
				self:addBlew()
			elseif data.type == 12 then
				qy.tank.utils.Timer.new(0.3,1,function()
            		self.entity.blood =  self.entity.blood - data.change
					self:updateHP(true)
					self:showHPTip(-data.change,false)
				end):start()
			elseif data.type == 10 then
				self:mingzhongUp()
			elseif data.type == 25 then
				self:addSanJiao()
			end
		else
			if data.status == 9 then -- 反伤
				self:addFanshang() 
			elseif data.status == 10 then
				self:addConfusion() -- 混乱
			elseif data.status == 11 then -- 胆怯
				self:addTimidity()
			elseif data.status == 12 then -- 无敌状态
				self:addInvincible()
			elseif data.status == 13 then -- 嘲讽
				self:addChaofeng()
			elseif data.status == 14 then -- 嘲讽减伤
				self:addChaofeng1()
			elseif data.status == 15 then -- 减疗状态
				self:addJianliao()
			elseif data.status == 16 then -- 无视防御
				self:addIgnoredefense()
			elseif data.status == 17 then -- 锁链状态
				self:addBlockade()
			elseif data.status == 21 then -- 点燃
				self:addDianRan()
				self:addHuomiao(data.pos,1)
			elseif data.status == 22 then -- 点燃
				self:addDianRan()
				self:addHuomiao(data.pos,2)
			elseif data.status == 23 then -- 点燃
				self:addHuomiao(data.pos,3)
				self:addDianRan()
			end
		end
	end
end


-- 主动加血技能
function Tank:addHpBuffTo()
	print("Tank:addHpBuffTo")
	self:playBuff(self.top,self.entity:getDefPos(),"buff_fx_jiaxueqs",1,nil,nil)
end


-- 被动加血技能
function Tank:addHpBuffFrom(change,value)
	print("Tank:addHpBuffFrom",change,value)
	local x = self.entity:getDefPos().x
	local y = self.entity:getDefPos().y - 20
  	self:playBuff(self.bottom,cc.p(x,y),"buff_fx_jiaxue",0,nil,nil)
  	self:playBuff(self.top,self.entity:getDefPos(),"buff_fx_jiaxue",1,nil,nil)
  	if change ~= 0 then
		self:showHPTip(change,false)
	else
		self:showHPTip("+0",false)
	end
  	self.isBloodUpdate = false
  	self.entity.blood = value
	self:updateHP(false,true)
	self.isBloodUpdate = true
end

-- 添加护盾技能
function Tank:addDefenseBuff()
	local x = self.entity:getDefPos().x
	local y = self.entity:getDefPos().y - 20
	if not (self.defense_buff and tolua.cast(self.defense_buff,"cc.Node")) then 
  		self.defense_buff = self:playBuff(self.top,cc.p(x,y),"buff_fx_fangyu",1,-1,1)
  	end
end

-- 移除护盾技能
function Tank:removeDefenseBuff()
	if tolua.cast(self.defense_buff,"cc.Node") then
		if self.defense_buff:getAnimation().stop then
			self.defense_buff:getAnimation():stop()
		end
		self.defense_buff:getParent():removeChild(self.defense_buff)
	end
end

-- 施放替身技能
function Tank:addReplaceSkillTo()
	self:playBuff(self.top,self.entity:getDefPos(),"buff_ui_daitiqs",1,-1,0)
end

-- 接受替身技能
function Tank:addReplaceSkillFrom()
	-- 移除敌方之前作用在身上的技能
	self:unforbid()

	local x = self.entity:getDefPos().x
	local y = self.entity:getDefPos().y - 20
  	self:playBuff(self.bottom,cc.p(x,y),"buff_ui_daiti",1,-1,0)
  	-- self:playBuff(self.top,self.entity:getDefPos(),"buff_fx_jiaxue",1,nil,nil)
  	-- self:playBuff(self.top,self.entity:getDefPos(),"buff_ui_daiti",1,nil,nil)
end


function Tank:skill_334_from()
	self:playBuff(self.top,self.entity:getDefPos(),"buff_fx_allbaoji",1,nil,nil)
end

function Tank:skill_334_to(change,value)
	local x = self.entity:getDefPos().x
	local y = self.entity:getDefPos().y
  	self:playBuff(self.bottom,cc.p(x,y),"buff_fx_allbaoji",0,nil,nil)
  	self:playBuff(self.top,self.entity:getDefPos(),"buff_fx_allbaoji",1,nil,nil)

  	-- if change ~= 0 then
		-- self:showHPTip(change,false)
	-- else
		-- self:showHPTip("+0",false)
	-- end
  	-- self.isBloodUpdate = false
	-- self.entity.blood = value
	-- self:updateHP(false)
	-- self.isBloodUpdate = true
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/battle/battle.plist")
	t = cc.Sprite:createWithSpriteFrameName("Resources/battle/shanghai.png")
	self:popupTip(t,30,0,1)
end

-- 添加伤害技能
function Tank:addHurtBuff()
	local x = self.entity:getDefPos().x
	local y = self.entity:getDefPos().y - 20
  	self.hurt_buff = self:playBuff(self.top,cc.p(x,y),"fx_ui_zengjiashanghai",1,-1,1)
end

-- 移除伤害技能
function Tank:removeHurtBuff()
	if tolua.cast(self.hurt_buff,"cc.Node") then
		if self.hurt_buff:getAnimation().stop then
			self.hurt_buff:getAnimation():stop()
		end
		self.hurt_buff:getParent():removeChild(self.hurt_buff)
	end
end

-- 添加死亡号角buff
function Tank:addDeadHornBuff()
	self.dead_haojiao = self:playBuff(self.top,self.entity:getDefPos(),"ui_fx_siwanghaojiao",1,-1,1)
end

-- 移除死亡号角buff
function Tank:removeDeadHornBuff(change)
	if tolua.cast(self.dead_haojiao,"cc.Node") then
		if self.dead_haojiao:getAnimation().stop then
			self.dead_haojiao:getAnimation():stop()
		end
		self.dead_haojiao:getParent():removeChild(self.dead_haojiao)
	end

	if change ~= nil then
		if change ~= 0 then
			self:showHPTip(-change,false)
		else
			self:showHPTip("-0",false)
		end
	end
end


-- 添加灭火技能
function Tank:addOutfire()
	local x = self.entity:getDefPos().x
	local y = self.entity:getDefPos().y - 20
  	self.outfire_buff = self:playBuff(self.top,cc.p(x,y),"ui_fx_yahuo",1,-1,1)
end


-- 移除灭火技能
function Tank:removeOutfire()
	if tolua.cast(self.outfire_buff,"cc.Node") then
		if self.outfire_buff:getAnimation().stop then
			self.outfire_buff:getAnimation():stop()
		end
		self.outfire_buff:getParent():removeChild(self.outfire_buff)
	end
end

-- 添加自爆
function Tank:addBlew()
	local x = self.entity:getDefPos().x
	local y = self.entity:getDefPos().y - 20
  	self.blew_buff = self:playBuff(self.top,cc.p(x,y),"fx_zibao",1,-1,0)
end


-- 移除自爆
function Tank:removeBlew()
	if tolua.cast(self.blew_buff,"cc.Node") then
		if self.blew_buff:getAnimation().stop then
			self.blew_buff:getAnimation():stop()
		end
		self.blew_buff:getParent():removeChild(self.blew_buff)
	end
end

-- 添加无视防御技能
function Tank:addIgnoredefense()
	local x = self.entity:getDefPos().x
	local y = self.entity:getDefPos().y - 20
  	self.Ignoredefense_buff = self:playBuff(self.top,cc.p(x,y),"ui_fx_wushifangyu",1,-1,1)
end


-- 移除无视防御技能
function Tank:removeIgnoredefense()
	if tolua.cast(self.Ignoredefense_buff,"cc.Node") then
		if self.Ignoredefense_buff:getAnimation().stop then
			self.Ignoredefense_buff:getAnimation():stop()
		end
		self.Ignoredefense_buff:getParent():removeChild(self.Ignoredefense_buff)
	end
end

-- 添加封锁技能
function Tank:addBlockade()
	local x = self.entity:getDefPos().x
	local y = self.entity:getDefPos().y - 20
  	self.Blockade_buff = self:playBuff(self.top,cc.p(x,y),"fx_suolian",1,-1,1)
end


-- 移除封锁技能
function Tank:removeBlockade()
	if tolua.cast(self.Blockade_buff,"cc.Node") then
		if self.Blockade_buff:getAnimation().stop then
			self.Blockade_buff:getAnimation():stop()
		end
		self.Blockade_buff:getParent():removeChild(self.Blockade_buff)
	end
end

-- 添加反伤技能
function Tank:addFanshang()
	local x = self.entity:getDefPos().x
	local y = self.entity:getDefPos().y - 20
	self.fanshang = self:playBuff(self.top,self.entity:getDefPos(),"ui_fx_fantan",1,-1,1)
end

-- 移除反伤技能
function Tank:removeFanshang()
	if tolua.cast(self.fanshang,"cc.Node") then
		if self.fanshang:getAnimation().stop then
			self.fanshang:getAnimation():stop()
		end
		self.fanshang:getParent():removeChild(self.fanshang)
	end
end
--===================================================================M48a1坦克新加技能
-- M48a1添加护盾技能
function Tank:addBaoHuZhao()
	local x = self.entity:getDefPos().x
	local y = self.entity:getDefPos().y - 20
	--if not (self.BaoHuZhao and tolua.cast(self.BaoHuZhao,"cc.Node")) then 
  		self.BaoHuZhao = self:playBuff(self.top,cc.p(x,y),"ui_fx_baohuzhao",1,-1,1)
  	--end
end

-- M48a1移除护盾技能
function Tank:removeBaoHuZhao()
	if tolua.cast(self.BaoHuZhao,"cc.Node") then
		if self.BaoHuZhao:getAnimation().stop then
			self.BaoHuZhao:getAnimation():stop()
		end
		self.BaoHuZhao:getParent():removeChild(self.BaoHuZhao)
	end
end

function Tank:addHuomiao(_idx,_nums)
	if self.wenzi  then
	   self.wenzi:setString(_nums)
	else
		local x2 = self.entity:getDefPos().x 
		local y2 = self.entity:getDefPos().y 
	 	self.huomiao = ccui.ImageView:create()
	    self.huomiao:loadTexture("Resources/common/img/huomiao.png",1)
	    self.huomiao:setScaleX(1)
	    self.huomiao:setScaleY(1)
	    self.huomiao:setPosition(cc.p(x2,y2))
	    self.top:addChild(self.huomiao,1)

	    local x3 = self.entity:getDefPos().x + 20
		local y3 = self.entity:getDefPos().y 
	 	self.wenzi = ccui.Text:create()
	 	self.wenzi:setString(tostring(_nums))
	 	self.wenzi:setColor(cc.c3b(255, 120, 0))
	 	self.wenzi:setFontSize(24)
	    self.wenzi:setPosition(cc.p(x3,y3))
	    self.top:addChild(self.wenzi,1)
	end
end

function Tank:removeHuomiao()
	if self.wenzi then
		self.top:removeChild(self.wenzi)
		self.wenzi = nil
		self.top:removeChild(self.huomiao)
		self.huomiao = nil
	end
end

--添加点燃
function Tank:addDianRan()
	if self.DianRan  then
	else
		local is_fu = 0
		if self.entity:getWheelScale() < 0 then
			is_fu = -1

			local x1 = self.entity:getDefPos().x + 20
			local y1 = self.entity:getDefPos().y + 30
		  	self.Yan = cc.ParticleSystemQuad:create("fx/cn/buff/battlefire2.plist")
		  	self.Yan:setPosition(cc.p(x1,y1))
			self.Yan:setScale(is_fu)
		  	self.top:addChild(self.Yan)

			local x = self.entity:getDefPos().x + 20
			local y = self.entity:getDefPos().y + 30
		  	self.DianRan = cc.ParticleSystemQuad:create("fx/cn/buff/battlefire1.plist")
		  	self.DianRan:setPosition(cc.p(x,y))
			self.DianRan:setScale(is_fu)
		  	self.top:addChild(self.DianRan)
		else
			is_fu = 1

			local x1 = self.entity:getDefPos().x - 30
			local y1 = self.entity:getDefPos().y + 25
		  	self.Yan = cc.ParticleSystemQuad:create("fx/cn/buff/battlefire2.plist")
		  	self.Yan:setPosition(cc.p(x1,y1))
			self.Yan:setScale(is_fu)
		  	self.top:addChild(self.Yan)

			local x = self.entity:getDefPos().x - 30
			local y = self.entity:getDefPos().y + 25
		  	self.DianRan = cc.ParticleSystemQuad:create("fx/cn/buff/battlefire1.plist")
		  	self.DianRan:setPosition(cc.p(x,y))
			self.DianRan:setScale(is_fu)
		  	self.top:addChild(self.DianRan)
		end
	end
end

-- 移除点燃
function Tank:removeDianRan()
	if self.DianRan then
		self.top:removeChild(self.DianRan)
		self.DianRan = nil
		self.top:removeChild(self.Yan)
		self.Yan = nil
	end
end

-- 添加三角标记
function Tank:addSanJiao()
	local x = self.entity:getDefPos().x 
	local y = self.entity:getDefPos().y + 60
 --  	self.LifeConnection = self:playBuff(self.top,cc.p(x,y),"ui_fx_lianjie",1,-1,1)
 	self.image = ccui.ImageView:create()
    self.image:loadTexture("Resources/common/img/sanjiao.png",1)
    self.image:setScaleX(1.5)
    self.image:setScaleY(1.5)
    self.image:setPosition(cc.p(x,y))
    self.top:addChild(self.image,1)
    local moveUp = cc.FadeTo:create(1, 10)
    local moveDown = cc.FadeTo:create(1, 1000)
    local seq = cc.Sequence:create(callFunc, moveUp, moveDown)
    self.image:runAction(cc.RepeatForever:create(seq))
end

-- 移除三角标记
function Tank:removeSanJiao()
	if self.image then
		self.top:removeChild(self.image)
	end
end

--===================================================================M48a1坦克新加技能
-- 添加混乱技能
function Tank:addConfusion()
	local x = self.entity:getDefPos().x
	local y = self.entity:getDefPos().y - 20
  	self.confusion_buff = self:playBuff(self.top,cc.p(x,y),"ui_fx_hunluan",1,-1,1)
end

-- 移除混乱技能
function Tank:removeConfusion()
	if tolua.cast(self.confusion_buff,"cc.Node") then
		if self.confusion_buff:getAnimation().stop then
			self.confusion_buff:getAnimation():stop()
		end
		self.confusion_buff:getParent():removeChild(self.confusion_buff)
	end
end

-- 添加胆怯状态
function Tank:addTimidity()
	if not tolua.cast(self.timidity,"cc.Node") then 
		local x = self.entity:getDefPos().x
		local y = self.entity:getDefPos().y
	  	self.timidity = self:playBuff(self.top,cc.p(x,y),"ui_fx_shiqibuneng",1,-1,1)
  	end	
end

-- 移除胆怯状态
function Tank:removeTimidity()
	if tolua.cast(self.timidity,"cc.Node") then
		if self.timidity:getAnimation().stop then
			self.timidity:getAnimation():stop()
		end
		self.timidity:getParent():removeChild(self.timidity)
	end
end

-- 添加无敌状态
function Tank:addInvincible()
	if not tolua.cast(self.timidity,"cc.Node") then 
		local x = self.entity:getDefPos().x
		local y = self.entity:getDefPos().y - 20
	  	self.invincible = self:playBuff(self.top,cc.p(x,y),"ui_fx_wudi",1,-1,1)
  	end
end

-- 移除无敌状态
function Tank:removeInvincible()
	if tolua.cast(self.invincible,"cc.Node") then
		if self.invincible:getAnimation().stop then
			self.invincible:getAnimation():stop()
		end
		self.invincible:getParent():removeChild(self.invincible)
	end
end

-- 添加嘲讽技能
function Tank:addChaofeng()
	if not tolua.cast(self.chaofeng,"cc.Node") then 
		local x = self.entity:getDefPos().x
		local y = self.entity:getDefPos().y - 20
	  	self.chaofeng = self:playBuff(self.top,cc.p(x,y),"ui_fx_chaofeng",1,-1,1)
  	end
end

-- 移除嘲讽技能
function Tank:removeChaofeng()
	if tolua.cast(self.chaofeng,"cc.Node") then
		if self.chaofeng:getAnimation().stop then
			self.chaofeng:getAnimation():stop()
		end
		self.chaofeng:getParent():removeChild(self.chaofeng)
	end
end

-- 添加嘲讽减伤技能
function Tank:addChaofeng1()
	if not tolua.cast(self.chaofeng1,"cc.Node") then 
		local x = self.entity:getDefPos().x
		local y = self.entity:getDefPos().y - 20
	  	self.chaofeng1 = self:playBuff(self.top,cc.p(x,y),"ui_fx_chaofeng1",1,-1,1)
  	end
end

-- 移除嘲讽减伤技能
function Tank:removeChaofeng1()
	if tolua.cast(self.chaofeng1,"cc.Node") then
		if self.chaofeng1:getAnimation().stop then
			self.chaofeng1:getAnimation():stop()
		end
		self.chaofeng1:getParent():removeChild(self.chaofeng1)
	end
end

-- 添加嘲讽减伤技能
function Tank:addChaofeng1()
	if not tolua.cast(self.chaofeng1,"cc.Node") then 
		local x = self.entity:getDefPos().x
		local y = self.entity:getDefPos().y - 20
	  	self.chaofeng1 = self:playBuff(self.top,cc.p(x,y),"ui_fx_chaofeng1",1,-1,1)
  	end
end

-- 移除嘲讽减伤技能
function Tank:removeChaofeng1()
	if tolua.cast(self.chaofeng1,"cc.Node") then
		if self.chaofeng1:getAnimation().stop then
			self.chaofeng1:getAnimation():stop()
		end
		self.chaofeng1:getParent():removeChild(self.chaofeng1)
	end
end


-- 添加减疗技能
function Tank:addJianliao()
	if not tolua.cast(self.jianliao,"cc.Node") then 
		local x = self.entity:getDefPos().x
		local y = self.entity:getDefPos().y - 20
	  	self.jianliao = self:playBuff(self.top,cc.p(x,y),"ui_fx_jianzhiliao",1,-1,1)
  	end
end

-- 移除减疗技能
function Tank:removeJianliao()
	if tolua.cast(self.jianliao,"cc.Node") then
		if self.jianliao:getAnimation().stop then
			self.jianliao:getAnimation():stop()
		end
		self.jianliao:getParent():removeChild(self.jianliao)
	end
end



function Tank:playSkillBuffByID(id)
	local skill_type = qy.Config.skill[tostring(id)].own_type
	print("Tank.playSkillBuffByID",id,skill_type)
	if skill_type == 2 or skill_type == 4 and self.data.is_confusion ~= 1 then -- 加血
		self:addHpBuffTo()
	elseif skill_type == 3 then -- 护盾
	elseif skill_type == 5 then -- 替身
		self:addReplaceSkillTo()
	elseif skill_type == 7 then
		-- self:skill_334_from()
	end
end

function Tank:playBuff(container,pos,name,idx,duration,loop)
	print("++++++++++++++++++++++++++++++ Tank:playBuff",name,idx,duration,loop)
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

function Tank:setIndex(idx)
	self.index = idx
	-- self.indexLabel:setString(tostring(idx))
end

function Tank:runCustomizeAction(actions)
end

-- ==================================================  Buff End ==================================================

return Tank
