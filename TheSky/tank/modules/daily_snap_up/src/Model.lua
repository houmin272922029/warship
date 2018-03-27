--[[
	每日福利
	
]]

local Model = class("Model", qy.tank.model.BaseModel)
function Model:init(data)
	--拿到表中的数据
	self.config = qy.Config.daily_welfare_gift_buy
	self.config1 = qy.Config.daily_welfare_gift_personal	
	self.gift_personal = data.gift_personal
	self.week_day = data.week_day
	self.buyed_list = data.buyed_list
	self.gift_buy = data.gift_buy
	self.current_time = data.server_time
end

function Model:updatePersonal(id)
	table.insert(self.gift_personal,id)
	
end
function Model:updateBuy(id)
	table.insert(self.gift_buy,id)
end

function Model:updateBuyedList(id)
	for i=1,#self.buyed_list do
		if tonumber(self.buyed_list[i].id) == id then
			self.buyed_list[i].num = self.buyed_list[i].num + 1	
		end
	end	
end

function Model:getnumsByid( id )
	for k,v in pairs(self.buyed_list) do
		if v.id == id then
			return v.num
		end
	end
end

function Model:GetPersonalDataById(id)
	local list = {}
	for k,v in pairs(self.config1) do
		if v.day == id then
			table.insert(list,v)
		end
	end
	table.sort(list,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)
	return list	
end

function Model:GetBuyDataById(id)
	local list = {}
	for k,v in pairs(self.config) do
		if v.day == id then
			table.insert(list,v)
		end
	end
	table.sort(list,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)
	return list	
end
function Model:getstatusBy( id )
	local statu = 0
	for i = 1,#self.gift_personal do
	 	if self.gift_personal[i] == id then
	 		statu = 1
	 	end
 	end
 	return statu
end


function Model:GetBuyStatusById(id)
	local statu = 0		
	    for i = 1,#self.gift_buy do
		 	if self.gift_buy[i] == id  then
		 		statu=1
		 	end
	  	end 
	return statu
end
--personal
function Model:GetPersonalAwardId(id)
	local list = {}
    for k,v in pairs(self.config1) do
       if id == v.id then
        table.insert(list,v)
       end
    end
    table.sort(list,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)
   return list
end
--buy
function Model:GetBuyAwardId(id)
	local list = {}
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


return Model
