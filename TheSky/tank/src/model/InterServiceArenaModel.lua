--[[
	跨服竞技场
	Author: fq
	Date: 2016年12月02日17:52:13
]]

local InterServiceArenaModel = qy.class("InterServiceArenaModel", qy.tank.model.BaseModel)


local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil

function InterServiceArenaModel:init(data)
	self:initConfig()
	self.rank_list_page_size = 20 --排行榜每次请求的数量


	self:update(data)
end



function InterServiceArenaModel:update(data)
	--分组id
	self.group_id = data.group_id or self.group_id

	--活动时间
	self.end_time = data.end_time or self.end_time or 0
	self.start_time = data.str_time or self.start_time or 0
	self.new_str_time = data.new_str_time or self.new_str_time or 0

	--个人信息
	self.user_list = data.user_list or self.user_list
	if self.user_list then
		--总排名
		self.rank = self.user_list.rank or self.rank
		--段位排名
		self.stage_rank = self.user_list.current_rank or self.stage_rank
		self.stage_num = self.user_list.stage or self.stage_num
		self.win_num = self.user_list.win_num or self.win_num
		self.max_stage = self.user_list.max_stage or self.max_stage
		self.max_current_rank = self.user_list.max_current_rank or self.max_current_rank
	end

	--是否参赛
	self.is_join = data.is_join or self.is_join

	--可以打的人
	self.battle_list = data.battle_list or self.battle_list
	if data.battle_list and data.battle_list.list then
		--self.opponent = self.battle_list.list or self.opponent
		table.sort(self.battle_list.list,function(a,b)
			return tonumber(a.rank) < tonumber(b.rank)
		end)
	end

	--竞技场积分
	self.source = data.source or self.source
	
	--最强王者
	self.kinglist = data.kinglist or self.kinglist
	if data.kinglist and self.kinglist.list then
		table.sort(self.kinglist.list,function(a,b)
			return tonumber(a.rank) < tonumber(b.rank)
		end)
	end

	--7天奖励是否领取
	self.day_award_7 = data.day_award_7 or self.day_award_7	
	if self.day_award_7 then
		self.day_7_get = self.day_award_7.is_get or self.day_7_get
		self.day_7_stage = self.day_award_7.stage or self.day_7_stage
	end

	--14天的奖励是否领取
	self.day_award_14 = data.day_award_14 or self.day_award_14	
	if self.day_award_14 then
		self.day_14_get = self.day_award_14.is_get or self.day_14_get
		self.day_14_stage = self.day_award_14.stage or self.day_14_stage
	end

	--积分奖励是否领取
	self.source_award = data.source_award or self.source_award

	--晋级奖励是否领取
	self.stage_award = data.stage_award or self.stage_award

	--扫荡数据
	self.sweep = data.sweep or self.sweep

	if data.sweep then
		--扫荡需要钻石
		self.sweep_need_diamond = data.sweep.need_diamond or self.sweep_need_diamond or 0
		--扫荡需要次数
		self.sweep_need_times = data.sweep.need_num or (data.battle_num and (data.battle_num < 5 and 5 - data.battle_num or 0) or 0) or self.sweep_need_times or 0
		--扫荡敌人
		self.sweep_list = data.sweep.list or self.sweep_list
	end

	--剩余挑战次数
	self.battle_num = data.battle_num or self.battle_num

	if data.pay then
		--购买信息
		self.diamond_consume = data.pay.diamond or self.diamond_consume
	end

	--剩余挑战次数
	self.times = data.battle_num or self.times


	--服务器列表
	self.server_list = data.server_list or self.server_list

	--可以分享的次数
	self.send_num = data.send_num or self.send_num or 0

	-- self.is_empty_up = data.is_empty_up
	-- if self.is_empty_up == 100 then
	-- 	qy.Event.dispatch(qy.Event.INTER_SERVICE_ARENA, {["hint"] = true})
	-- elseif self.is_empty_up == 300 then
	-- 	qy.Event.dispatch(qy.Event.INTER_SERVICE_ARENA, {["hint"] = false})
	-- end


	
end




function InterServiceArenaModel:initConfig()
	self.end_award_config = qy.Config.inter_server_arena_end_award	
	self.stage_award_config = qy.Config.inter_server_arena_stage_award
	self.stage_config = qy.Config.inter_server_arena_stage
	self.up_award_config = qy.Config.inter_server_arena_up_award


	local staticData = qy.Config.inter_server_arena_score_award
	self.score_award = {}
	for i, v in pairs(staticData) do
		table.insert(self.score_award, v)
	end

	table.sort(self.score_award,function(a,b)
		return tonumber(a.source) < tonumber(b.source)
	end)
end





function InterServiceArenaModel:getStageNum(stage_num)
	local s_num = stage_num
	if not s_num then
		if self.stage_num then
			s_num = self.stage_num
		else
			s_num = 19 --19对应青铜3
		end
	end

	return s_num
end



function InterServiceArenaModel:getEndAwardByStage(stage_num)
	local s_num = self:getStageNum(stage_num)

	return self.end_award_config[tostring(s_num)]
end


function InterServiceArenaModel:getStageAwardByStage(stage_num)
	local s_num = self:getStageNum(stage_num)
	return self.stage_award_config[tostring(s_num)]
end

function InterServiceArenaModel:getStageByStage(stage_num)
	local s_num = self:getStageNum(stage_num)

	return self.stage_config[tostring(s_num)]
end

function InterServiceArenaModel:getUpAwardByStage(stage_num)
	local s_num = self:getStageNum(stage_num)

	return self.up_award_config[tostring(s_num)]
end

function InterServiceArenaModel:getScoreAwardByScore(idx)
	return self.score_award[idx]
end




-- return num1, num2
-- num1 : 图标，段位名
-- num2 : 对应 I II III
function InterServiceArenaModel:getStageIcon(stage_num)
	local s_num = self:getStageNum(stage_num)

	if s_num == 1 then
		return 1, nil
	else
		return math.floor((s_num - 2) / 3 + 2), (s_num - 2) % 3 + 1
	end
end



function InterServiceArenaModel:getEndTime()
	local time = self.end_time - userinfoModel.serverTime
	if time > 0 then
		return qy.TextUtil:substitute(90299, NumberUtil.secondsToTimeStr(time, 6))
	else
		return qy.TextUtil:substitute(90300)
	end
end


function InterServiceArenaModel:getStartTime()
	local time = self.new_str_time - userinfoModel.serverTime
	if time > 0 then
		return qy.TextUtil:substitute(90310, NumberUtil.secondsToTimeStr(time, 6))
	else
		return qy.TextUtil:substitute(90300)
	end
end


function InterServiceArenaModel:getTime()
	return os.date("%d",userinfoModel.serverTime - self.start_time)
end




return InterServiceArenaModel