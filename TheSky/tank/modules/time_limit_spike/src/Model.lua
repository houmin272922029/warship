--[[
	
	限时秒杀
]]

local Model = class("Model", qy.tank.model.BaseModel)
function Model:init(data)
	self.data = data


	--拿到表中的数据
	 self.config = qy.Config.seckill


	 self.status = 0

end
function Model:initlist(data)
	 self.list = {}
	for i=1,#data do
		if data[i].type == 1 then
			table.insert(self.list,data[i])
		end
	end
	-- table.sort(list,function(a,b)
 --        return tonumber(a.id) < tonumber(b.id)
 --    end) 
end
function Model:getlist( )
	return self.list
end

function Model:GetButtonStatus( )-- 0 参加中   1 抽奖中
	return self.data.current_list[1].special
end

function Model:AddButtonStatus( )-- 0 参加中   1 抽奖中

	self.data.current_list[1].special = self.data.current_list[1].special + 1
end

function Model:SubButtonStatus( )-- 0 参加中   1 抽奖中

	self.data.current_list[1].special = self.data.current_list[1].special - 1
end

function Model:AddSuperButtonStatus( )-- 0 参加中   1 抽奖中
	--self.status =  self.status + 1
	self.data.current_big_list[1].special = self.data.current_big_list[1].special + 1
end

function Model:SubSuperButtonStatus( )-- 0 参加中   1 抽奖中
	--self.status =  self.status - 1
	self.data.current_big_list[1].special = self.data.current_big_list[1].special - 1
end

function Model:GetSuperButtonStatus( )-- 0 参加中   1 抽奖中	
	return self.data.current_big_list[1].special
end

function Model:AddNum(id)--次数加一
	self.data.current_list[id].current_join_times = self.data.current_list[id].current_join_times + 1
	self.data.current_list[id].my_join_times = self.data.current_list[id].my_join_times + 1
	self.data.last_join_times = self.data.last_join_times - 1
end

function Model:SubNum(id)--数减一
	self.data.current_big_list[1].current_join_times = self.data.current_big_list[1].current_join_times + 1
	self.data.current_big_list[1].my_join_times = self.data.current_big_list[1].my_join_times + 1
	self.data.last_join_times = self.data.last_join_times - 1
end

function Model:GetYuGaoStatus(  )--预告状态
	local status = 0

	if self.data.server_time >= self.data.end_time then
		status = 1
	end
	return status
end

function Model:GestAwardById(id)--拿到当天显示的奖励
	local  list = {}
	for k,v in pairs(self.config) do
		if id == v.id then
			table.insert(list,v)
		end
	end
	table.sort(list,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)
	return list
end

function Model:GestAwardById2(id)--拿到超级奖励显示
	local  list = {}
	for k,v in pairs(self.config) do
		if id == v.id  then
			table.insert(list,v)
		end
	end
	table.sort(list,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)
	return list
end



return Model
