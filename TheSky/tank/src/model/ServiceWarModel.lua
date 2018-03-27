--[[
	跨服战
	Date:2016-05-10
]]

local ServiceWarModel = qy.class("ServiceWarModel", qy.tank.model.BaseModel)

local userModel = qy.tank.model.UserInfoModel

--跨服战首页
function ServiceWarModel:entryQualification(data)
	-- self.data = data
	self.kid = data.userinfo.kid
	self.isBet = data.userinfo.is_bet
	self.name = data.userinfo.nickname
	self.role = data.userinfo.role
	self.betinfo = data.userinfo.betinfo
	self.service_user_list = data.service_user_list
	self.findscore = data.findscore
	self.myrank = data.userinfo.current_ranking
	self.myrewards = data.userinfo.reward
	self.mysupports = data.userinfo.support
	self.endtime = data.endtime
	self.pastrank = data.userinfo.past_ranking
	-- self.attend_list_ = {}
	-- self.attend_list = {}
	self.shopList = self:getLocalShopList()
	if data.userinfo and data.userinfo.betinfo then
		self.pastrank = data.userinfo.betinfo.past_ranking
		self.currentrank = data.userinfo.betinfo.current_ranking
	end

end

--跨服战列表
function ServiceWarModel:getRankList(data)
	self.service_top_list = data.service_top_list
	-- for i, v in pairs(data.attend_list) do	
	-- 	if not self.attend_list_[tostring(i)] then
	-- 		local entity = qy.tank.entity.ServiceRankEntity.new(v)
	-- 		self.attend_list_[tostring(i)] = entity
	-- 		table.insert(self.attend_list, entity)
	-- 	else
	-- 		self.attend_list_[tostring(i)]:update(v)
	-- 	end	
	-- end

	self.attend_list = data.attend_list
	self.cpage = data.page
	self.datanum = data.maxpage
	self.userinfo = data.userinfo   --列表页数据
	self.isbet = data.isbet
	self.remaining = data.userinfo.remaining
	-- self.bet = data.attend_list.is_bet
end

--战况列表
function ServiceWarModel:getWarDetail(data)
	self.list = data.list
	self.pages = data.page
	self.Maxpage = data.maxpage
end

--首页刷新领奖状态
function ServiceWarModel:refersh(data)
	self.kid = data.index.userinfo.kid
	self.isBet = data.index.userinfo.is_bet
	self.name = data.index.userinfo.nickname
	self.role = data.index.userinfo.role
	self.betinfo = data.index.userinfo.betinfo
	self.service_user_list = data.index.service_user_list
	self.findscore = data.index.findscore
	self.myrank = data.index.userinfo.current_ranking
	self.myrewards = data.index.userinfo.reward
	self.mysupports = data.index.userinfo.support
	self.endtime = data.index.endtime
	-- self.pastrank = data.userinfo.betinfo.past_ranking
	-- self.currentrank = data.userinfo.betinfo.current_ranking

end

--刷新列表
function ServiceWarModel:bet(data)
	self.attend_list = data.joinlist.attend_list
	self.userinfo = data.joinlist.userinfo
	self.betinfo = data.betinfo
	self.betinfo.bet_status = 300
	self.isBet = data.joinlist.userinfo.is_bet 
	self.role = data.joinlist.userinfo.role
	self.pastrank = data.betinfo.pastranking
	self.currentrank = data.betinfo.currentranking
end

--战斗
function ServiceWarModel:getFighting(data)
	self.attend_list = data.joinlist.attend_list
	if data.joinlist.userinfo then
		self.userinfo = data.joinlist.userinfo
	end
	if not self.userinfo.remaining then
		self.userinfo.remaining = 0
	end 

	self.kid = data.index.userinfo.kid
	self.mysupports = data.index.userinfo.support
	self.pastrank = data.index.userinfo.past_ranking
	self.currentrank = data.index.userinfo.current_ranking
	self.myrank = data.index.userinfo.current_ranking
	self.myrewards = data.index.userinfo.reward

end

--购买战斗次数
function ServiceWarModel:BuyNum(data)
	if data.status then
		self.success = data.status
	end

	self.consume = data.consume  --钻石消耗
	self.num = data.num -- 次数
	if data.remaining then
		self.remaining = data.remaining
	end
end

--押注
function ServiceWarModel:getBet(data)
	self.succ = data.status
	self.sername = data.serviceid
	self.ranking = data.ranking
	self.betreward = data.bet_reward
	self.nickname = data.nickname
	self.time = data.endtime
end

--商城道具列表
function ServiceWarModel:getShopList(data)
	self.findscore = data.score
	return qy.Config.intershop
end

function ServiceWarModel:getLocalShopList()
    local items = qy.Config.intershop
    local list = {}
    for k,v in pairs(items) do
      table.insert(list,v)
    end
    table.sort(list, function(a, b)
 		return a.sortid < b.sortid
 	end)
 	return list
end

function ServiceWarModel:BuyItems(data)
	self.award = data.award
	self.score = data.score
end

--首页押注奖励领取
-- function ServiceWarModel:getBetAward(data)
-- 	self.getbet = data.award
-- end

--全服礼包列表
function ServiceWarModel:getAll(data)
	local awards = data.list
	local lists = {}
	for k,v in pairs(awards) do
		table.insert(lists,v)
	end	
	return lists
end

--全服福利
function ServiceWarModel:SetAllAwardsList(data)
	self.awards = {}
	if data and data.welfalelist then
		local warAwards = data.welfalelist.list
		if warAwards ~= "" then
			for k,v in pairs(warAwards) do
				table.insert(self.awards, v)

			end
		end
	  -- return self.awards
	end
	print("=====self.awards===",qy.json.encode(self.awards))
end

function ServiceWarModel:getAllAwardsList()
	return self.awards
end

function ServiceWarModel:setChooseIndex(i)
	self.chooseIndex = i
	-- body
end

function  ServiceWarModel:getChooseIndex()
	return self.chooseIndex or 1
	-- body
end

--全服福利领取
function ServiceWarModel:getReward(data)
	if data and data.award then
		self.gifts = data.award
	end
end

function ServiceWarModel:setAllAttendListNotBet()
	for i, v in pairs(self.attend_list_) do
		v.is_bet = 100
	end
end

return ServiceWarModel