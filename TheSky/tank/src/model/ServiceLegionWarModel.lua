local ServiceLegionWarModel = qy.class("ServiceLegionWarModel", qy.tank.model.BaseModel)

ServiceLegionWarModel.typeNameList ={
	["1"] = "前线侦查哨所",
	["2"] = "补给储备所",
	["3"] = "前线指挥所",
	["4"] = "弹药储备所",
	["5"] = "军团调动中心",
	["6"] = "军团指挥部"
}

function ServiceLegionWarModel:init(data)
	--本地数据表
	print("初始化数据",json.encode(data))
	self.personnal_day_award = qy.Config.interservice_legionbattle_personal_day_rank --个人日奖励排行表
	self.personnal_week_award = qy.Config.interservice_legionbattle_personal_week_rank --个人周排行
	self.personnal_achieve_award = qy.Config.interservice_legionbattle_personal_achieve --个人周战绩
	self.legion_week_award = qy.Config.interservice_legionbattle_legion_week_rank --军团周排名
	self.legion_achieve_award = qy.Config.interservice_legionbattle_legion_achieve --军团成就

	self.is_auth = data.is_auth --权限 1代表有权限 0 代表没有
	self.status = data.stage.status --当前状态  0未开放 1清理一期数据 2报名可调整驻防 3清理历史数据, 自动分配驻防与AI, 匹配军团
											--4攻打 5调整驻防6休息期
	self.is_enter = data.is_enter--是否已经报名 0没有  1报名了
	self.legionlevel = data.level
	self.legionname = data.legion_name
	self.cangetaward = data.stage.can_get_day_rank--日排行是否可领取
	self.awardflag = 0 --奖励接口开关，只请求一次
	self.chooselegion = 2
	self.end_time = data.stage.end_time
	self.attacklegionlist = {
	["2"] = 0,
	["3"] = 0,
	["4"] = 0,
	}
end
function ServiceLegionWarModel:update( data )
	self.status = data.stage.status
	self.is_enter = data.is_enter
end
function ServiceLegionWarModel:initDefencedate( data )
	self.garrison_list = {}
	for k,v in pairs(data.garrison_list) do
		table.insert(self.garrison_list,v)
	end
	table.sort(self.garrison_list, function(a, b)
           return a.pos < b.pos
    end)
end
function ServiceLegionWarModel:getDefenceByPos( Pos )
	local list = {}
	for k,v in pairs(self.garrison_list) do
		if v.pos == Pos then
			table.insert(list,v)
			break
		end
	end
	return list
end
function ServiceLegionWarModel:updateDefenceByPos( data,Pos )
	local temp = 0
	for i=1,#self.garrison_list do
		if self.garrison_list[i].pos == Pos then
			self.garrison_list[i] = data.garrison_list[1]
			temp = 1
			break
		end
	end
	if temp == 0  then
		table.insert(self.garrison_list,data.garrison_list[1])
	end
	table.sort(self.garrison_list, function(a, b)
           return a.pos < b.pos
    end)
end
function ServiceLegionWarModel:initRankdate( data )
	self.awardflag = 1
	self.personal_day_rank = data.personal_day_rank.rank_list--个人日排行
	self.my_day_rank = data.personal_day_rank.my_rank.rank--我的当前日排名 0 代表无排名
	self.personal_record = data.personal_week_rank.my_rank.record--个人周战绩
	self.personal_week_rank = data.personal_week_rank.rank_list--个人周排行
	self.my_week_rank = data.personal_week_rank.my_rank.rank--我的周排名 
	self.legion_day_rank = data.legion_day_rank.rank_list--军团日排名
	self.legion_week_rank = data.legion_week_rank.rank_list--军团周排名
	self.my_legion_week_rank = data.legion_week_rank.my_rank.rank--我的军团排名
	self.legion_record = data.legion_week_rank.my_rank.record--军团周战绩
	--奖励状态
	self.day_award = data.inter_legion.is_draw_personal_day_rank --日排行是否领取 0 不可领 1 可领取  -1 领取过了
	self.week_award = data.inter_legion.personal_week_rank_award --周排行是否领取 0 1 -1 

	self.legion_award = data.inter_legion.legion_week_rank_award  --军团周排名  0 1 -1

	self.personal_achieve_award = data.inter_legion.personal_achieve_award --个人战绩   领取状态，数组  领过的在里面
	self.legion_achieve_award_arry = data.inter_legion.legion_achieve_award --军团战绩领取状态 数组

end
function ServiceLegionWarModel:updateaward(data)
	self.day_award = data.inter_legion.is_draw_personal_day_rank --日排行是否领取 0 不可领 1 可领取  -1 领取过了
	self.week_award = data.inter_legion.personal_week_rank_award --周排行是否领取 0 1 -1 

	self.legion_award = data.inter_legion.legion_week_rank_award  --军团周排名  0 1 -1

	self.personal_achieve_award = data.inter_legion.personal_achieve_award --个人战绩   领取状态，数组  领过的在里面
	self.legion_achieve_award_arry = data.inter_legion.legion_achieve_award --军团战绩领取状态 数组
end
function ServiceLegionWarModel:initAttlist( data )
	self.fire_pos = data.group.fire_pos--集火的哪个军团
	self.attacklist = data.group.list
	for i=2,#self.attacklist do
		self.attacklegionlist[tostring(i)] = self.attacklist[i].is_break
	end
	print("llllllllll",json.encode(self.attacklegionlist))
end
function ServiceLegionWarModel:initAttSitelist( data )
	self.buytime = data.legion_site.buy_times--购买的次数
	self.ammo_store = data.legion_site.ammo_store--弹药储备数量
	self.passlist = data.legion_site.pass_site--击破的地点数组
	-- body
end
function ServiceLegionWarModel:updateziyuan( data )
	self.buytime = data.attack_info.buy_times--购买的次数
	self.ammo_store = data.attack_info.ammo_store--弹药储备数量
end
function ServiceLegionWarModel:initAttackSitelist( data )
	self.site_member = data.site_member
end
function ServiceLegionWarModel:initAttackSitelist1( data )
	self.site_member = data.site_member
	self.ammo_store = data.legion_site.ammo_store--弹药储备数量
end
function ServiceLegionWarModel:getawardtype( _type,_idx )
	local data = {}
	local num = 0
	if _type == 3 then
       data = self.personal_achieve_award
    else
       data = self.legion_achieve_award_arry
    end
	for i=1,#data do
		if data[i] == _idx then
			num = 1 
			break
		end
	end
	if num == 0 then
		return false
	else
		return true
	end
end
return ServiceLegionWarModel