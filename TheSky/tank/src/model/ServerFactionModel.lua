


local ServerFactionModel = qy.class("ServerFactionModel", qy.tank.model.BaseModel)

ServerFactionModel.camp = {
	["1"] = "铁血轴心",
	["3"] = "自由同盟",
	["2"] = "均衡仲裁"
}

function ServerFactionModel:init(data)
	qy.Utils.preloadJPG("Resources/main_city/building/camp_bg.jpg")
	self.isfaction = data.camp_id --0没阵营1有阵营
	self.camp_war_level = {}--
	for i, v in pairs(qy.Config.camp_war_level) do	
		table.insert(self.camp_war_level, v)
	end
	 table.sort(self.camp_war_level, function(a, b)
        return a.level > b.level
    end)

	self.config = qy.Config.camp_war_shop
	self.config2 = qy.Config.camp_war_level
	self.RedList = {}
	self.GreenList = {}
	self.BlueList = {}
	for k,v in pairs(self.config) do
		if v.camp == 1 then
			table.insert(self.RedList,v)
		elseif v.camp == 2 then
			table.insert(self.GreenList,v)
		else
			table.insert(self.BlueList,v)
		end
	end
	print(table.nums(self.config),"你大爷始终",table.nums(self.RedList))
	table.sort(self.RedList,function ( a,b )
		return tonumber(a.id) < tonumber(b.id)
	end)

	table.sort(self.GreenList,function ( a,b )
		return tonumber(a.id) < tonumber(b.id)
	end)

	table.sort(self.BlueList,function ( a,b )
		return tonumber(a.id) < tonumber(b.id)
	end)
	self.RedList_length = #self.RedList
	self.GreenList_length = #self.GreenList
	self.BlueList_length = #self.BlueList
end
--初始化推荐阵营
function ServerFactionModel:initProposalCamp( data )
	
	self.proposalCamp = data.proposal_camp
end
--主界面地图
function ServerFactionModel:initMainCamp( data ,flag)
	self.isfaction = data.userinfo.camp
	if flag and flag == 1 then
	else
		self.slectcity_id = 0
	end
	self.times = data.userinfo.energy_next_update_time
	self.my_camp = data.userinfo.camp
	self.my_feats = data.userinfo.credit--当前功勋
	self.my_kid = data.kid
	self.combat_have_no_read = data.combat_have_no_read--红点
	self.seize_count_down = data.seize_count_down--主界面时间现实
	self.max_credit = data.userinfo.max_credit -- 功勋上线
	self.today_get_credit = data.userinfo.today_get_credit --今天拿到的功勋
	self.userinfo = data.userinfo
	self.my_city = data.userinfo.city_id 
	self.fight_buff_camp = data.fight_buff_camp--战斗buff
	self.resource_buff_camp = data.resource_buff_camp
	self.city_info = {}
	self.camp_info = data.camp_info
	local staticData  = qy.Config.camp_war_city
	for i, v in pairs(staticData) do
		v.camp = data.city_info[tostring(i)].camp
		v.current_blood = data.city_info[tostring(i)].current_blood 
		table.insert(self.city_info, v)
	end
	 table.sort(self.city_info, function(a, b)
        return a.id < b.id
    end)
end
function ServerFactionModel:initOneCamp( data )
	self.campbase = data.city_info
	self.position = data.position
end
--获取资源加成
function ServerFactionModel:getBuff1Bycamp(  )
	local status = false
	for k,v in pairs(self.resource_buff_camp) do
		if v == self.my_camp then
			return true
		end
	end
	return status
end
function ServerFactionModel:getBuff2Bycamp(  )
	local status = false
	for k,v in pairs(self.fight_buff_camp) do
		if v == self.my_camp then
			return true
		end
	end
	return status
end
function ServerFactionModel:initRanklist( data )
	self.ranklist1 = data[1]
	self.ranklist2 = data[2]
	self.ranklist3 = data[3]
end
--设置当前在哪个城里面
function ServerFactionModel:setSlectcity( city_id )
	self.slectcity_id = city_id
end
--重置cityid
function ServerFactionModel:initSlectcity(  )
	self.slectcity_id = 0
end
function ServerFactionModel:initCombatlist( data )
	self.combat = data
end
function ServerFactionModel:getlevelByid( id )
	for k,v in pairs(self.camp_war_level) do
		if v.level == id then
			return v
		end
	end
end

-- 拿到几级防守点
function ServerFactionModel:getDefensivePoint( _id )
	local PointDate = qy.Config.camp_war_city
	for k,v in pairs(PointDate) do
		if _id == v.id then
			return v.mine_level
		end
	end
end

function ServerFactionModel:changeRedPointStatus()
	self.combat_have_no_read = 0
end

function ServerFactionModel:changeRedPointStatus2()
	self.combat_have_no_read = 1
end

--撤退更新功勋
function ServerFactionModel:addFeats(_num)
	self.my_feats = self.my_feats + _num
end

--进攻或占领增加功勋
function ServerFactionModel:addFeatsTwo(_num)
	self.my_feats = self.my_feats + _num
end

--拿到商店显示奖励
function ServerFactionModel:getAward(_idx,camp_type)
	if camp_type == 1 then
		return self.RedList[_idx]
	elseif camp_type == 2 then
		return self.GreenList[_idx]
	else
		return self.BlueList[_idx]
	end
end

--拿到商品所需军衔
function ServerFactionModel:getName(_idx)
	for k,v in pairs(self.config2) do
		if v.level == _idx then
			return v.name
		end

	end
end

--展示勋章
function ServerFactionModel:getXunZhang(_data)
	if _data.gold_badge == 0 then
		if _data.silver_badge == 0 then
			return "service_faction_war/res/xunzhang2.png", _data.copper_badge
		else
			return "service_faction_war/res/xunzhang3.png", _data.silver_badge
		end
	else
		return "service_faction_war/res/xunzhang1.png", _data.gold_badge
	end
end

--商店购买后减去所购买的贡献
function ServerFactionModel:changeGongXian(_num)
	self.userinfo.contribution = self.userinfo.contribution - _num
end

--兑换后更改军衔
function ServerFactionModel:changeLevel(_level)
	self.userinfo.rank_level = _level
end

--拿到购买的次数
function ServerFactionModel:getNums(_idx)
	--print("你是谁",self.userinfo.shop_limit[tostring(23)])
	return self.userinfo.shop_limit[tostring(_idx)] or 0
end

--改变购买的次数
function ServerFactionModel:changeNums(_idx)
	if self.userinfo.shop_limit[tostring(_idx)] then
		self.userinfo.shop_limit[tostring(_idx)] = self.userinfo.shop_limit[tostring(_idx)] + 1
	else
		--table.insert(self.userinfo.shop_limit,)
		self.userinfo.shop_limit[tostring(_idx)] = 1
	end
end

return ServerFactionModel