--[[
	战狼归来
	
]]

local Model = class("Model", qy.tank.model.BaseModel)
function Model:init(data)--data是service中传过来的
	--拿到war_wolf_checkpoint表中的数据
	self.config = qy.Config.war_wolf_checkpoint
	self.config1 = qy.Config.war_wolf_award
	
	self.start_time = data.serverTime
	self.end_time = data.endTime
	--已经攻打过的关卡
	self.checkpoint = {}
	for k,v in pairs(data.checkpoint) do
		table.insert(self.checkpoint,v)
	end
	--已经领取的奖励
	--self.extends_data = data.extends_data
	self.extendsdata={}
	for k,v in pairs(data.extends_data) do
		table.insert(self.extendsdata,k)
	end
	--奖励列表
	self.awardlist = data.award_list

end

function Model:update(copyid ,id ,data)
	if data.win == 1 then		
		table.insert(self.checkpoint,id)
		self.awardlist[tostring(copyid)] = data.award_list
	end
end

function Model:update1(copyid ,data)
	table.insert(self.extendsdata,copyid)
end


function Model:getStatusByid( id )
	local status = 0
	for k,v in pairs(self.checkpoint) do
		if id == v then
			status = 1 
			break
		end
	end
	return status
end

function Model:getStatusBy(id)
	local statu = 0
	for k,v in pairs(self.awardlist) do	 	  
	 	if tonumber(id) == tonumber(k) then
	 		statu = 1
	 	end
	end
	
	return statu
end

function Model:getChapterByid(id)
	local list = {}
	for k,v in pairs(self.config) do
		if v.copy_id == id then
			table.insert(list,v)
		end
	end
	table.sort(list,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)
	return list
end

function Model:getPersonalAwardByid( id )
    local list = {}
    for k,v in pairs(self.config1) do
       if id == v.copy_id then
        table.insert(list,v)
       end
    end
    table.sort(list,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)
   return list
end

return Model
