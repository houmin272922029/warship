--[[
	
	Author: lijian ren
	Date: 2016年07月13日15:09:18
]]

local RedPacketModel = qy.class("RedPacketModel", qy.tank.model.BaseModel)


function RedPacketModel:init(data)
	self.rankcfg = qy.Config.red_packet_runk--排行表
	self.newyearawardcfg = qy.Config.red_packet_reward--压碎红包表
	self.redpacketcoloecfg = qy.Config.red_packet_colour--红包颜色表
	print("入口数据==========",json.encode(data))
	local datas = data.activity_info
	self.award_time = datas.award_start_time
	self.nowday = datas.now_day
	self.every_award_list = datas.every_award_list--压岁红包list
	self.end_time = datas.end_time
	self.rank_list = {}
	for i, v in pairs(datas.share_rank.rank_list) do
		table.insert(self.rank_list, v)

	end
	table.sort(self.rank_list, function(a, b)
		return a.rank < b.rank
	end)
	self.share_list = datas.share_rank
	
	self.red_pack_list_world = {} 
	self.red_pack_list_legion = {} 
	self.red_pack_list_system = {}
	local staticdata1 = datas.red_pack_list.world--世界红包
	for i, v in pairs(staticdata1) do
		local entity = qy.tank.entity.RedPacketEntity.new(v)
		table.insert(self.red_pack_list_world, entity)

	end
	local staticdata1 = datas.red_pack_list.legion--军团
	for i, v in pairs(staticdata1) do
		local entity = qy.tank.entity.RedPacketEntity.new(v)
		table.insert(self.red_pack_list_legion, entity)

	end
	local staticdata1 =  datas.red_pack_list.system--系统
	for i, v in pairs(staticdata1) do
		local entity = qy.tank.entity.RedPacketEntity.new(v)
		table.insert(self.red_pack_list_system, entity)

	end
end



function RedPacketModel:update(datas,range)
	print("更新完成",json.encode(datas))
	if range == 0 then
		self.red_pack_list_system = {}
		local staticdata1 =  datas.red_pack_list.system--系统
		for i, v in pairs(staticdata1) do
			local entity = qy.tank.entity.RedPacketEntity.new(v)
			table.insert(self.red_pack_list_system, entity)

		end
	elseif range == 1 then
		self.red_pack_list_world = {}
		local staticdata1 = datas.red_pack_list.world--世界红包
		for i, v in pairs(staticdata1) do
			local entity = qy.tank.entity.RedPacketEntity.new(v)
			table.insert(self.red_pack_list_world, entity)

		end
	else
		self.red_pack_list_legion = {}
		local staticdata1 = datas.red_pack_list.legion--军团
		for i, v in pairs(staticdata1) do
			local entity = qy.tank.entity.RedPacketEntity.new(v)
			table.insert(self.red_pack_list_legion, entity)

		end
	end

end
function RedPacketModel:initRankList( datas )
	
	self.rank_list = {}
	for i, v in pairs(datas.share_rank.rank_list) do
		table.insert(self.rank_list, v)

	end
	table.sort(self.rank_list, function(a, b)
		return a.rank < b.rank
	end)
	self.share_list = datas.share_rank
end
function RedPacketModel:GetRedPacketcolor( num )
	if num >= self.redpacketcoloecfg[tostring(1)].min_num then
		if num >= self.redpacketcoloecfg[tostring(2)].min_num then
			if num >= self.redpacketcoloecfg[tostring(3)].min_num then
				return 3
			else
				return 2
			end
		else
			return 1
		end
	end
end



return RedPacketModel