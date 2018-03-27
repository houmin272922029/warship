

local TasteWarModel = qy.class("TasteWarModel", qy.tank.model.BaseModel)

function TasteWarModel:init(data)
	-- local data = datas.activity_info
	self.shoplist =  qy.Config.zzf_score_shop
	local staticdata = qy.Config.zzf_tiptext
	self.textlist1 = {}
	self.textlist2 = {}
	for k,v in pairs(staticdata) do
		if v.type == 1 then
			table.insert(self.textlist1,v)
		else
			table.insert(self.textlist2,v)
		end
	end

	self.endtime = data.stop_timestamp--活动结束时间
	self.awrdtime = data.over_timestamp
	self.team_score = data.team_score
	self.userinfo = data.user_info
	self.att_nums = data.user_info.last_attack_times--剩余次数
	self.buy_num = data.user_info.attack_time_buy_times --买了多少次
	self.score = data.user_info.score
	self.team = data.user_info.team
	self:Getawardtimes()
end
function TasteWarModel:Getshoplistnum(  )
	return table.nums(self.shoplist)
end
function TasteWarModel:update( data )
	self.team_score = data.team_score
	self.userinfo = data.user_info
	self.att_nums = data.user_info.last_attack_times
	self.buy_num = data.user_info.attack_time_buy_times
	self.score = data.user_info.score
	self.team = data.user_info.team
end
function TasteWarModel:getStatus(  )
	if self.endtime - qy.tank.model.UserInfoModel.serverTime <= 0 then
		return true 
	else
		return false
	end
end
function TasteWarModel:Getawardtimes(  )
    local tab = os.date("*t", self.awrdtime)
    return tab.year .. "-" ..tab.month .. "-" .. tab.day 
end
function TasteWarModel:Gettextbyid( id )
	local data = {}
	if id == 1 then
		data = self.textlist1
	else
		data = self.textlist2
	end
	local num = math.random(1, #data)
	return data[num].text
end




return TasteWarModel