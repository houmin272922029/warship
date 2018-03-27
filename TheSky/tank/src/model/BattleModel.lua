--[[
	战斗数据
	Author: Aaron Wei
	Date: 2015-01-30 15:10:01
]]

local BattleModel = qy.class("BattleModel", qy.tank.model.BaseModel)
-- 视图
BattleModel.battleView = nil

-- 阵地
BattleModel.field1 = nil
BattleModel.field2 = nil

-- 阵型
BattleModel.formation1 = nil
BattleModel.formation2 = nil

-- 坦克数据列表
BattleModel.tankDataList1 = nil
BattleModel.tankDataList2 = nil

-- 坦克列表
BattleModel.tankList1 = nil
BattleModel.tankList2 = nil

-- 战斗总数据
BattleModel.totalBattleData = nil
BattleModel.totalBattleDataClone = nil
BattleModel.battleData = nil

-- 动作序列
BattleModel.actionList = nil

-- 0 失败  1胜利  2平局
BattleModel.isWin = nil

-- 战斗玩家名称
BattleModel.leftPlayerName = nil
BattleModel.rightPlayerName = nil

-- BattleModel.PreAction = qy.tank.view.battle.actions.PreAction
BattleModel.RoundAction = qy.tank.view.battle.actions.RoundAction
-- BattleModel.EndAction = qy.tank.view.battle.actions.EndAction

-- BattleModel.background =

-- BattleModel.tips = {
--     {min=1,max=14,name1="强化装备",name2="排兵布阵",name3="战车升级",link1=4,link2=58,link3=6},
--     {min=15,max=39,name1="研发科技",name2="强化装备",name3="战车升级",link1=18,link2=4,link3=6},
--     {min=40,max=49,name1="战车进阶",name2="研发科技",name3="强化装备",link1=2,link2=18,link3=4},
--     {min=50,max=59,name1="合金升级",name2="获取合金",name3="战车进阶",link1=59,link2=55,link3=2},
--     {min=60,max=119,name1="军魂升级",name2="高级军魂",name3="合金升级",link1=56,link2=57,link3=59}
-- }

-- 2016.07.23 新增 extendData 目的：为了将士之战中能通过关卡 ID 获得头像
function BattleModel:init(data, extendData)
	-- qy.Event.dispatch(qy.Event.SERVICE_LOADING_HIDE)
	-- 坦克数据
	BattleModel.tankDataList1 = {}
	BattleModel.tankDataList2 = {}
	-- 坦克列表
	BattleModel.tankList1 = {}
	BattleModel.tankList2 = {}
	-- 动作序列
	BattleModel.actionList = {}
	-- 阵地
	BattleModel.field1 = nil
	BattleModel.field2 = nil
	-- 阵型
	BattleModel.formation1 = nil
	BattleModel.formation2 = nil
	-- 战斗背景
	-- assert(data.ext.bg_id ~= nil,"战斗背景为空")
	if data.ext.bg_id ~= nil then
		self.bg_id = data.ext.bg_id
	else
		self.bg_id = 1
	end

	self.totalBattleData = data
	self.totalBattleDataClone = clone(data)
	self.currentIdx,self.len = 1,1
	-- 0失败 1胜利 2平局
    self.isWin = data["end"].is_win

    self.fight_type = data.fight_type

	local passenger_data = qy.Config.passenger
	if data.ext.att_passenger and data.ext.att_passenger ~= 0 then
		data.ext.att_passenger_data = passenger_data[tostring(data.ext.att_passenger)]
	end
	

	if data.fight_type == 2 then -- 经典战役
		if data.ext then
			if data.ext.type == 1 then -- 闪电战
				self:initOne(data)
			elseif data.ext.type == 2 then -- 突破重围
				self.len = #data.fight
				self:initSubBattle(self.currentIdx)
			elseif data.ext.type == 3 then -- 保卫战
				self:initOne(data)
			elseif data.ext.type == 4 then -- 坚盾之战
				self:initOne(data)
			elseif data.ext.type == 5 then -- BOSS战
				self:initOne(data)
			end
		end
	elseif data.fight_type == 10 then -- 世界boss
		self:initOne(data)
	elseif data.fight_type == 32 then -- 圣诞boss
		self:initOne(data)
	else
		-- 关卡，竞技场，矿区，远征，伞兵入侵
		if data.fight_type == 18 then
			-- 将士之战，读表取 防守方 将士头像
			local soldier_data = qy.Config.soldier_battle_checkpoint
			if extendData and tostring(extendData.checkpoint_id) and soldier_data and soldier_data[tostring(extendData.checkpoint_id)] then
				data.ext.def_passenger = soldier_data[tostring(extendData.checkpoint_id)].image_id
				data.ext.def_passenger_data = passenger_data[tostring(data.ext.def_passenger)]
			end
		else
			if data.ext.def_passenger and data.ext.def_passenger ~= 0 then
				data.ext.def_passenger_data = passenger_data[tostring(data.ext.def_passenger)]
			end
		end
		self:initOne(data)
	end
end
function BattleModel:initserver( data ,type)
	self:init(data.fight_result)
	if type == 1 then
		self.dimond = data.diamond
		self.integral = data.integral
	else
		self.dimond = -1
		self.integral = -1
	end
end
function BattleModel:getSubBattle(idx)
	local _data = {
		["fight_type"] = self.totalBattleData.fight_type,
		["ext"] = self.totalBattleData.ext,
		["start"] = self.totalBattleData.fight[idx]["start"],
		["fight"] = self.totalBattleData.fight[idx]["fight"],
		["end"] = self.totalBattleData.fight[idx]["end"]}
	return _data
end

function BattleModel:getNextBattle()
	if self.currentIdx < self.len then
		self.currentIdx = self.currentIdx + 1
	end
	return self:getSubBattle(self.currentIdx)
end

function BattleModel:initSubBattle(idx)
	local _data = self:getSubBattle(idx)
	self:initOne(_data)
end


function BattleModel:initNextBattle()
	if self.currentIdx < self.len then
		self.currentIdx = self.currentIdx + 1
	end
	return self:initSubBattle(self.currentIdx)
end

function BattleModel:initOne(data)
	self:clear()

	-- 战斗总数据克隆
	self.battleData = data

	-- 战斗玩家名称
    self.leftPlayerName = "LV."..data.start.left.user.level.."   "..data.start.left.user.nickname
    self.rightPlayerName = "LV."..data.start.right.user.level.."   "..data.start.right.user.nickname
    self.leftPlayerLevel = data.start.left.user.level

    local arr = {"left","right"}
    for m=1,2 do
    	self.monster_type = nil
		for i=1,6 do
			local d = data.start[arr[m]].tank[tostring(i)]
			if d then
		    	if m == 1 then -- 左方
					if self.fight_type == 7 then
						self.monster_type = 7 --怪物表 新手引导特例
					else
						self.monster_type = 0 --坦克表
					end
				else -- 右方
					if data.ext.special == 4 then
						self.monster_type = 7 --关卡9 新手引导特例(白虎)
					else
						if d.kid <= 10000 then
							self.monster_type = self.fight_type --怪物表
						else
							self.monster_type = 0 --坦克表
						end
			    	end
				end

				self["tankDataList"..m][i] = qy.tank.entity.BattleTankEntity.new(d,m,self.monster_type)
				-- self["tankDataList"..m][i].maxBlood = d.blood
				self["tankDataList"..m][i].maxMorale = 4
			else
				self["tankDataList"..m][i] = nil
			end
		end
    end

	for i=1,#data.fight do
		self.actionList[i] = {}
		-- self.preList[i] = self.PreAction.new(data.fight[i].pre)
		-- self.endList[i] = self.EndAction.new(data.fight[i]["end"])
		local round = data.fight[i].battle
		for j=1,#round do
			local act = self.RoundAction.new(round[j],i,j)
			self.actionList[i][j] = act
		end
	end
end

function BattleModel:skip()
	local data = clone(self.battleData)
	local arr = {"left","right"}
	for m=1,2 do
		for i=1,6 do
			local tank = self["tankList"..m][i]
			local result = data["end"][arr[m]].tank[tostring(i)]
			if tolua.cast(tank,"cc.Node") and not tank.dead then
				if result == nil then
					tank:showHPTip(-tank.entity.blood,false)
					self.timer = qy.tank.utils.Timer.new(1,1,function()
						if tolua.cast(tank,"cc.Node") then
							tank:die()
						end
					end)
					self.timer:start()
				else
					if self.fight_type == 10 and m == 2 then -- 世界boss跳过掉血
						tank:showHPTip(-data.ext.total_hurt,false)
					else
						tank:showHPTip(-tank.entity.blood+result.blood,false)
					end
					tank:update(result,3)
					self:recover()
				end
			end
		end
	end
end

function BattleModel:reset()
	if self.timer then
		self.timer:stop()
		self.timer = nil
	end
	self:init(self.totalBattleDataClone)
	self.totalBattleData.ext.skip = 1
end

function BattleModel:clear()
	BattleModel.field2 = nil
	BattleModel.formation2 = nil
	BattleModel.tankDataList2 = {}
	BattleModel.tankList2 = {}
	BattleModel.actionList = {}
end

function BattleModel:getTank(direction,index)
	return self["tankList"..direction][index]
end

function BattleModel:getTankData(direction,index)
	return self["tankDateList"..direction][index]
end

function BattleModel:addTankData(data,d,i)
	local entity = qy.tank.entity.BattleTankEntity.new(data,d,self.monster_type)
	entity.maxBlood = data.blood
	entity.maxMorale = 4
	self["tankDataList"..d][i] = entity
	-- self["formation"..i]:addTank(entity,i)
end

function BattleModel:addTankListData(data,d)
	for k,v in pairs(data) do
		self:addTankData(v,d,k)
	end
end

function BattleModel:removeTankData(d,i)
	table.remove(self["tankDataList"..d],i)
end

function BattleModel:removeTankListData(data)
	for k,v in pairs(data) do
		self:removeTankData(v.from+1,v.pos)
	end
end

function BattleModel:initUserExp(data)
	if data then
		if data.add_exp ~= nil then
			self.add_exp = data.add_exp
		else
			self.add_exp = 0
		end

		if data.upgrade_level ~= nil then
			self.upgrade_level = data.upgrade_level
		else
			self.upgrade_level = 0
		end
	else
		self.add_exp = 0
		self.upgrade_level = 0
	end
end

function BattleModel:initAward(data,fightType)
	if fightType == 1 then
		self.awardList = {{["type"]=-1,["num"]=self.add_exp}}
	else
		self.awardList = {}
	end
	for i=1,#data do
		-- if data[i].type == 3 then
		-- 	self.add_coin = data[i].num
		-- else
		-- 	table.insert(self.awardList,data[i])
		-- end
		table.insert(self.awardList,data[i])
	end
end

function BattleModel:clearAward()
	self.awardList = {}
end

function BattleModel:getBgURL()
	print("BattleModel111",self.bg_id)
	return "bg/battleground_"..self.bg_id..".jpg"
end

function BattleModel:getMovementAngle(direction)
	local start_p = qy.tank.config.BattleConfig.GROUND[self.bg_id]["start"..tostring(direction)]
	local end_p = qy.tank.config.BattleConfig.GROUND[self.bg_id]["end"..tostring(direction)]
	return math.atan(math.abs((start_p.y - end_p.y)/(start_p.x - end_p.x)))
end

function BattleModel:getBgPosition(direction)
	-- local origin = qy.tank.config.BattleConfig.GROUND[self.bg_id]["origin"]
	-- local offset = qy.tank.config.BattleConfig.GROUND[self.bg_id]["offset"]
	-- local size = qy.tank.config.BattleConfig.GROUND[self.bg_id]["size"]
	-- local start,end_p
	-- if direction == 1 then --左边
	-- 	start_p = origin
	-- 	end_p = cc.p(start_p.x-offset.x,start_p.y-offset.y)
	-- else --右边
	-- 	start_p = cc.p(origin.x+qy.winSize.width-size.width,origin.y+qy.winSize.height-size.height)
	-- 	end_p = cc.p(start_p.x+offset.x,start_p.y+offset.y)
	-- end
	-- return {["start"]=start_p,["end"]=end_p}

	local start_p = qy.tank.config.BattleConfig.GROUND[self.bg_id]["start"..tostring(direction)]
	local end_p = qy.tank.config.BattleConfig.GROUND[self.bg_id]["end"..tostring(direction)]
	return {["start"]=start_p,["end"]=end_p}
end

-- 抗日远征回复气血
function BattleModel:recover()
	local recover = self.totalBattleData.ext.recover
	if recover then
		for i=1,6 do
			local tank = self.tankList1[i]
			if tolua.cast(tank,"cc.Node") then
				local id = tostring(tank.entity.unique_id)
				local add = recover[id]
				if add then
					if add.add_blood > 0 then
						tank:changeHP(add.add_blood)
					end
					if add.add_morale > 0 then
						tank:changeMorale(add.add_morale)
					end
					tank:popupTipSequence()
				end
			end
		end
	end
end

function BattleModel:getLeftUserLevel()
	if tonumber(self.leftPlayerLevel) then
		return self.leftPlayerLevel
	else
		return qy.tank.model.UserInfoModel.userInfoEntity.level
	end
end

return BattleModel
