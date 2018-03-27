--[[
	战斗动作执行，包含一次完整的进攻（包括连击）防御（包括群上）回合
	Author: Aaron Wei
	Date: 2015-02-04 12:24:27
]]

local Action = class("Action")

Action.ACTION_START = "actionStart"
Action.ACTION_END = "actionEnd"

Action.PLAYING_STATE = "runningState"
Action.PAUSING_STATE = "pausingState"
Action.ENDING_STATE = "endingState"

function Action:ctor(data,round,index)
	self.data = data
	self.round = round
	self.index = index
	self.manager = qy.tank.manager.BattleRoundManager
	self.model = qy.tank.model.BattleModel
	self.attack_timer,self.pre_timer,self.end_timer = nil,nil
	self.defense_timer1,self.defense_timer2 = nil,nil
end

-- 执行总入口
function Action:excute()
	local len = #self.model.actionList[self.round]
	if self.index == 1 and self.index == len then
		self:pre(function()
			self:fight(function()
				self:ending()
			end)
		end)
	elseif self.index == 1 then
		self:pre(function()
			self:fight()
		end)
	elseif self.index == len then
		self:fight(function()
			self:ending()
		end)
	else
		self:fight()
	end
end

-- 回合预备动作
function Action:pre(callback)
	local data = self.model.battleData.fight[self.round].pre
	if data and data.supply then
		self.model:addTankListData(data.supply,1)
		self.model.formation1:addTanks(data.supply)

		local function _continue()
			self.pre_timer = qy.tank.utils.Timer.new(1,1,function()
				if callback then
					callback()
				end
			end)
			self.pre_timer:start()
		end

		if qy.isNoviceGuide then --||||||
			self.manager:breaking(function()
				_continue()
			end,0.2)
		else
			_continue()
		end

	else
		if callback then
			callback()
		end
	end
end

-- 回合结束动作
function Action:ending()
	local data = self.model.battleData.fight[self.round]["end"]
	-- 撤退
	if data then
		if data.retreat then
			self.model:removeTankListData(data.retreat,1)
			self.model.formation2:removeTanks(data.retreat)

		end

		-- 回合结束状态清理
		if data.clean then
			for i=1,#data.clean do
				local d = data.clean[i]
				local tank = self.model["tankList"..(d.from+1)][d.pos]
				tank:recover(d)
			end
		end 

		self.pre_timer = qy.tank.utils.Timer.new(1,1,function()
			qy.Event.dispatch("action_end")
		end)
		self.pre_timer:start()
	
	else
		qy.Event.dispatch("action_end")
	end
end

-- 回合进入战斗
function Action:fight(callback)
	local defense_num = #self.data.defense
	local attack_id,defense_id
	-------------------------20170926 新加字段post 坦克死亡不移除
	if self.data.post then
		local arr = self.data.post.die_not_move
		for i=1,#arr do
			local item = arr[i]
			local tank = self.model["tankList"..(item.from+1)][item.pos]
			if tolua.cast(tank,"cc.Node") then
				tank.entity.not_move = 1
			end
		end
	end
	if self.data.post then
		local arr = self.data.post.clean
		for i=1,#arr do
			local item = arr[i]
			local tank = self.model["tankList"..(item.from+1)][item.pos]
			if tolua.cast(tank,"cc.Node") then
				local times = self.data.attack.is_compat == 1 and 3.5 or 1.5
				qy.tank.utils.Timer.new(times,1,function()
            		tank:recover(item)
        		end):start()
				
			end
		end
	end
	-----------------------------------------结束
	-- 出手后（反作用效果，作用于己方）
	local function after()
		print("++++++++++++++++++++++++++++++ RoundAction:after",defense_id)
		if self.data.own then
			local arr = self.data.own
			for i=1,#arr do
				local item = arr[i]
				local tank = self.model["tankList"..(item.from+1)][item.pos]
				if tolua.cast(tank,"cc.Node") then
					tank:feedback(item)
				end
			end
		end
		if callback then
			callback()
		else
			qy.Event.dispatch("action_end")
		end
	end
	
	-- 防守方
	local function defense()
		print("++++++++++++++++++++++++++++++ RoundAction:defense",defense_id)
		local defense_list = {}
		if defense_num > 0 then
			for i=1,defense_num do
				local defense = self.model["tankList"..(self.data.defense[i].from+1)][self.data.defense[i].pos]
				if tolua.cast(defense,"cc.Node") then
					defense.updateData = self.data.defense[i]
					defense_list[i] = defense
				end
			end

			local field = self.model["field"..defense_id]
			if self.skill_target == 4 or self.skill_target == 6 then -- 群攻
				local function act1()
					for i=1,defense_num do
						local tank = defense_list[i]
						if tolua.cast(tank,"cc.Node") and tank.entity.blood > 0 then
							-- 击中坦克
							if not (tank.updateData.is_dodge and tank.updateData.is_dodge ~= 0) then -- 坦克闪避不播受击特效
								tank:hurt(tank.updateData.skill_id)
							end
						else
							-- 击中地面
							if tolua.cast(field,"cc.Node") then
								field:hurt(self.data.defense[i].pos,self.data.attack.skill_id)
							end
						end
					end
				end

				local function act2()
					for i=1,defense_num do
						local tank = defense_list[i]
						if tolua.cast(tank,"cc.Node") and tank.entity.blood > 0 then
							-- 击中坦克
							tank:update(tank.updateData,2)
						else
							-- 击中地面
							if tolua.cast(field,"cc.Node") then
								field:showCrater(self.data.defense[i].pos)
							end
						end
					end
					qy.QYPlaySound.playEffect(qy.SoundType.TANK_HIT)
					after()
					if tonumber(self.data.attack.is_compat) > 0 then
						qy.Event.dispatch("shake",defense_id)
					end
				end

				act1()
				self.delay_timer = qy.tank.utils.Timer.new(0.2,1,function()
					act2()
				end)
				self.delay_timer:start()
			else -- 单个攻击
				local delay = qy.BattleConfig.SHOOT_INTERVAL
				local function act1()
					self.defense_timer1 = qy.tank.utils.Timer.new(delay,defense_num,function()
						local count = self.defense_timer1.currentCount
						local tank = defense_list[count]
						if tolua.cast(tank,"cc.Node") and tank.entity.blood > 0 then
							-- 击中坦克
							if not (tank.updateData.is_dodge and tank.updateData.is_dodge ~= 0) then -- 坦克闪避不播受击特效
								tank:hurt(tank.updateData.skill_id)
							end
						else
							-- 击中地面
							if tolua.cast(field,"cc.Node") then
								field:hurt(self.data.defense[count].pos,self.data.attack.skill_id)
							end
						end
						if count >= defense_num then
							self.defense_timer1:stop()
						end
					end)
					self.defense_timer1:start()
				end

				local function act2()
					self.defense_timer2 = qy.tank.utils.Timer.new(delay,defense_num,function()
						local count = self.defense_timer2.currentCount
						local tank = defense_list[count]
						if tolua.cast(tank,"cc.Node") and tank.entity.blood > 0 then
							-- 击中坦克
							tank:update(tank.updateData,2)
						else
							-- 击中地面
							if tolua.cast(field,"cc.Node") then
								field:showCrater(self.data.defense[count].pos)
							end
						end
						qy.QYPlaySound.playEffect(qy.SoundType.TANK_HIT)

						if count >= defense_num then
							self.defense_timer2:stop()
							after()
							-- qy.Event.dispatch("action_end")
						end

						if tonumber(self.data.attack.is_compat) > 0 then
							qy.Event.dispatch("shake",defense_id)
						end
					end)
					self.defense_timer2:start()
				end

				act1()
				self.delay_timer = qy.tank.utils.Timer.new(0.3,1,function()
					act2()
				end)
				self.delay_timer:start()
			end
		else
			after()
			-- qy.Event.dispatch("action_end")
		end
	end

	local function attack()
		attack_id = self.data.attack.from+1
		print("++++++++++++++++++++++++++++++ RoundAction:attack",attack_id)
		defense_id = 3 - attack_id
		self.attack = self.model["tankList"..(self.data.attack.from+1)][self.data.attack.pos]
		self.attack.data = self.data.attack

		local function commonSkillAttack()
			if self.data.attack.skill_id > 0 then
				self.skill_target = qy.Config.skill[tostring(self.data.attack.skill_id)].enemy_target
				if self.skill_target == 4 or self.skill_target == 6 then
					-- 单发，发一炮，攻击多个，同时受击
					self.attack:shoot(self.data.attack.skill_id,1,self.data.attack.is_shot)
				else
					-- 连发，发多炮，攻击多个，顺序受击
					if defense_num > 0 then
						self.attack:shoot(self.data.attack.skill_id,defense_num,self.data.attack.is_shot)
					else
						self.attack:shoot(self.data.attack.skill_id,1,self.data.attack.is_shot)
					end
				end
				self.attack.updateData = self.data.attack
				-- self.attack:update(self.attack.updateData,2)
				self.attack_timer = qy.tank.utils.Timer.new(0.5,1,function()
					defense()
					self.attack:update(self.attack.updateData,2)
				end)
				self.attack_timer:start()
			else
				defense()
				self.attack.updateData = self.data.attack
				self.attack:update(self.attack.updateData,2)

				-- self.attack.updateData = self.data.attack
				-- self.attack_timer = qy.tank.utils.Timer.new(0.5,1,function()
				-- 	defense()
				-- 	self.attack:update(self.attack.updateData,2)
				-- end)
				-- self.attack_timer:start()
			end
		end

		-- assert(tolua.cast(self.attack,"cc.Node"),"attack is nil!")
		if tolua.cast(self.attack,"cc.Node") then
			if tonumber(self.data.attack.is_compat) > 0 then
				-- 饱和攻击
				-- assert(self.model.battleView,"battleView is nil!")
				local view = self.model.battleView
				if view then
					self.listener = qy.Event.add("battle_compatSkill_end",function(event)
						qy.Event.remove(self.listener)
						self.listener = nil
						commonSkillAttack()
					end)
					view:playCompatSkill(self.data.attack.skill_id,self.data.attack.from+1)
				end
				-- commonSkillAttack()
			else
				-- 普通技能攻击
				commonSkillAttack()
			end
		end
	end

	-- 出手前
	local function before()
		print("++++++++++++++++++++++++++++++ RoundAction:before")
		if self.data.pre then
			if self.data.pre.clean then
				for i=1,#self.data.pre.clean do
					local d = self.data.pre.clean[i]
					local tank = self.model["tankList"..(d.from+1)][d.pos]
					tank:recover(d)
				end	
			end
			
			if self.data.pre.own then
				local arr = self.data.pre.own
				for i=1,#arr do
					local item = arr[i]
					local tank = self.model["tankList"..(item.from+1)][item.pos]
					if tolua.cast(tank,"cc.Node") then
						tank:feedback(item)
					end
				end
			end
		end

		attack()
	end

	before()
end

function Action:replay()
end

function Action:stop()
	if self.pre_timer then
		self.pre_timer:stop()
		self.pre_timer = nil
	end

	if self.attack_timer then
		self.attack_timer:stop()
	end

	if self.defense_timer1 then
		self.defense_timer1:stop()
	end

	if self.defense_timer2 then
		self.defense_timer2:stop()
	end

	if self.delay_timer then
		self.delay_timer:stop()
	end

	if self.listener then
		qy.Event.remove(self.listener)
		self.listener = nil
	end
end

return Action
