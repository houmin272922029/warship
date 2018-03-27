--[[
	战争图卷
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local WarPictureModel = qy.class("WarPictureModel", qy.tank.model.BaseModel)

function WarPictureModel:init(data)
	-- {"locking_num":15,"update_num":5,"selected":0,"time":0,"status":300,"uptime":20160728,"position":{"p_1":0,"p_2":0,"p_3":0,"p_4":0,"p_5":0}}
	
	

	self.list = {}
	self.checkpointList = {}

	local staticData = qy.Config.warfare_jigsaws
	for i, v in pairs(staticData) do
		table.insert(self.checkpointList, v)
	end

	table.sort(self.checkpointList,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)



	local staticData2 = qy.Config.warfare_jigsaws_weight
	for i, v in pairs(staticData2) do
		table.insert(self.list, v)
	end

	table.sort(self.list,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)
	

	self:update(data)
	
end

function WarPictureModel:update(data)

	self.locking_num = data.locking_num + data.pay_locking_num
	self.update_num = data.update_num + data.pay_update_num
	self.selected = data.selected
	self.status = data.status
	self.position = data.position
	self.locking_list = data.locking_list
	self.award = data.award or 0
	
	self.matching = {false, false, false, false, false}

	if self.selected > 0 then
	    for i = 1, 5 do
	    	if self.list[self.position["p_"..i]].pid == self.selected and self.list[self.position["p_"..i]].position == "p_"..i then
		    	self.matching[i] = true
		    end
	    end
	end	

end


function WarPictureModel:getImgPath(id)	
	return "war_picture/res/"..self.list[id].pid.."/"..self.list[id].position..".jpg"

end


function WarPictureModel:getMatchingById(id)
	return self.matching[id]
end


function WarPictureModel:getLockingByIndex(id)	
	return self.locking_list["p_"..id] == 1
end


function WarPictureModel:getLockingNum()	
	local num = 0
	for i = 1, 5 do
		if self.locking_list["p_"..i] == 1 then
			num = num + 1
		end		
	end

	return num
end

function WarPictureModel:getLockingByIndex2(id)
	if self.locking_list["p_"..id] == 1 then 
		return "200"
	else 
		return "100"
	end
end


function WarPictureModel:getConsume()
	if self.selected > 0 then 
		return self.checkpointList[self.selected].consume
	end

	return 0
end




return WarPictureModel