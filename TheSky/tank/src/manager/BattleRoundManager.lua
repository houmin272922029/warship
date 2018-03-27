--[[
	战斗动作回合管理器
	Author: Aaron Wei
	Date: 2015-02-05 15:32:02
]]

local BattleRoundManager = class("BattleRoundManager")

BattleRoundManager.round = nil
BattleRoundManager.index = nil
BattleRoundManager.model = nil
BattleRoundManager.status = nil
BattleRoundManager.finished = nil
BattleRoundManager.running = false

-- 初始化战斗动作回合
function BattleRoundManager:init()
	print("BattleRoundManager:init")
	self.model = qy.tank.model.BattleModel
	self.finished = false
	self.round,self.index = 1,0
	-- self.running = false
end

function BattleRoundManager:skip()
	self:stop()
	if self.model.actionList then
		self.round = #self.model.actionList
		self.index = #self.model.actionList[self.round]
	end
	print("++++++++++++++++++++++++++++++ 所有回合结束!",self.round,self.index)
	self:endBattle()
end

function BattleRoundManager:play()
	print("++++++++++++++++++++++++++++++ BattleRoundManager:play!",self.round,self.index)
	if not self.running then
		self.running = true
		if self.listener then
			qy.Event.remove(self.listener)
		end
		self.listener = qy.Event.add("action_end",function(event)
			if self.finished then
				print("++++++++++++++++++++++++++++++ 所有攻防结束!",self.round,self.index)
				self.running = false
				qy.Event.remove(self.listener)
				self:endBattle()
				self.model:recover()
			else
				print("++++++++++++++++++++++++++++++ 一次攻防结束!",self.round,self.index,self.timer)
				self.timer = qy.tank.utils.Timer.new(1,1,function()
					self:next()
				end)
				self.timer:start()
			end
		end)
		self:next()
	else
		print("running==========")
	end
end

-- 战斗回合结束
function BattleRoundManager:stop()
	print("BattleRoundManager:stop")
	if self.running then
		self.running = false
		qy.Event.remove(self.listener)
		if self.timer then
			self.timer:stop()
			self.timer = nil
		end
		local action = self.model.actionList[self.round][self.index]
		if action then
			action:stop()
		end
	end
end

function BattleRoundManager:replay()
	print("replay replay replay replay replay replay")
	if not self.running then
		self.running = true
		if self.listener then
			qy.Event.remove(self.listener)
		end
		self.listener = qy.Event.add("action_end",function(event)
			if self.finished then
				print("++++++++++++++++++++++++++++++ 所有攻防结束!",self.round,self.index)
				self.running = false
				qy.Event.remove(self.listener)
				self:endBattle()
				self.model:recover()
			else
				print("++++++++++++++++++++++++++++++ 一次攻防结束!",self.round,self.index,self.timer)
				self.timer = qy.tank.utils.Timer.new(1,1,function()
					self:next()
				end)
				self.timer:start()
			end
		end)
		self:excute()
	end
end

function BattleRoundManager:breaking(callback,_delay)
	print("breaking ==========================================")
	self.continue_fun = callback
	if _delay ~= nil and _delay > 0 then
		local delay = qy.tank.utils.Timer.new(_delay,1,function()
			qy.GuideManager:next(16)
		end)
		delay:start()
	else
		qy.GuideManager:next(17)
	end
end

function BattleRoundManager:continue()
	print("continue =========================================1=")
	if self.continue_fun and type(self.continue_fun) == "function" then
		print("continue =========================================2=")
		local fun = self.continue_fun
		self.continue_fun = nil
		fun()
	end
end

function BattleRoundManager:excute()
	print("++++++++++++++++++++++++++++++ BattleRoundManager:excute",self.round,self.index,self.finished)
	if self.round and self.index then
		if self.round >= #self.model.actionList and self.index >= #self.model.actionList[self.round] then
			-- 战斗结束
	        self.finished = true
		else
			self.finished = false
		end

		local action = self.model.actionList[self.round][self.index]
		action:excute()
	end
end

-- 获取下一步数据
function BattleRoundManager:getNext(round,index)
	local _round,_index = round,index
	if round < #self.model.actionList then
		if index < #self.model.actionList[round] then
			_index = index + 1
		else
			self:endRound()
			_index = 1
			_round = round + 1
		end
	else
		if index < #self.model.actionList[round] then
			_index = index + 1
		else
			-- 最后一回合结束
			_index,_round = nil
		end
	end
	return _round,_index
end

-- 下一步
function BattleRoundManager:next()
	self.round,self.index = self:getNext(self.round,self.index)
	print("++++++++++++++++++++++++++++++ BattleRoundManager:next",self.round,self.index,self.finished)
    if qy.isNoviceGuide and self.index == 1 and self.round == 2 and qy.tank.model.GuideModel:getCurrentBigStep() == 1 then--||||||
		self:stop()
		self:breaking(function()
			self:replay()
		end)
		return
	else
		self:excute()
	end
end

-- 战斗回合暂停
function BattleRoundManager:pause()
	print("BattleRoundManager:pause")
	cc.Director:getInstance():pause()
end

function BattleRoundManager:resume()
	print("BattleRoundManager:pause")
	cc.Director:getInstance():resume()
end

-- 一次动作完成
function BattleRoundManager:endAction()
	print("BattleRoundManager:action end!")
	-- qy.Event.dispatch("action_end")
end

-- 一个回合完成
function BattleRoundManager:endRound()
	print("BattleRoundManager:round end!")
	local arr = self.model.battleData.fight[self.round]["end"]
	for i=1,#arr do
		local item = arr[i]
		local tank = self.model["tankList"..(item.from+1)][item.pos]
		if tolua.cast(tank,"cc.Node") then
			tank:recover(item)
		end
	end
	qy.Event.dispatch("round_end")
end

-- 所有回合完成
function BattleRoundManager:endBattle()
	print("BattleRoundManager:all end!")
	qy.Event.dispatch("battle_end")
end

return BattleRoundManager
