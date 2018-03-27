--[[
	查看资料
	Author: Your Name
	Date: 2015-09-11 10:37:05
]]

local ExamineModel = qy.class("ExamineModel", qy.tank.model.BaseModel)

ExamineModel.techTypeList = {qy.TextUtil:substitute(3008),qy.TextUtil:substitute(3009),qy.TextUtil:substitute(3010),qy.TextUtil:substitute(10007),qy.TextUtil:substitute(10008),qy.TextUtil:substitute(10009)}
ExamineModel.achieveTypeList = {qy.TextUtil:substitute(10004),qy.TextUtil:substitute(10005),qy.TextUtil:substitute(10006),qy.TextUtil:substitute(10010),qy.TextUtil:substitute(10011),qy.TextUtil:substitute(10012),qy.TextUtil:substitute(10013),qy.TextUtil:substitute(10014),qy.TextUtil:substitute(10015),qy.TextUtil:substitute(10016),"攻击力","防御力","血量","伤害减免"}

function ExamineModel:init(data)
    self.data = data
    self.headIcon = data.user_info.headicon
    self.level = data.user_info.level
    self.nickname = data.user_info.nickname
    self.fight_power = data.user_info.fight_power
    self.pvp_rank = data.user_info.pvp_rank

    -- 查看坦克
	self.tankList = {}
	for i=1,6 do
		if data.tank_list[tostring(i)] then
			local tank
			if data.tank_list[tostring(i)].kid <= 10000 then
				tank = qy.tank.entity.OtherTankEntity.new(data.tank_list[tostring(i)],3)
			else
				tank = qy.tank.entity.OtherTankEntity.new(data.tank_list[tostring(i)],0)
			end
			table.insert(self.tankList,tank)
		end
	end

	-- 查看科技
	self.techTypeCfg = qy.Config.technology_type
    self.techValueCfg = qy.Config.technology_value
    self.tech = {}
    if data.tech then
    	for k,v in pairs(data.tech) do
    		local item = self:getTechItem(k,v)
    		local template = item.template
    		if self.tech[template] == nil then
    			self.tech[template] = {}
    		end
    		table.insert(self.tech[template],item)
    	end
    end

	for k,v in pairs(self.tech) do
		table.sort(v,function(a,b)
			return tonumber(a.id) < tonumber(b.id)
		end)
	end
	-- 查看成就
	self.achieveCfg = qy.Config.achievement
	self.achievePlusCfg = qy.Config.achievement_plus
	self.achieve = {}
	if data.achieve then
		for k,v in pairs(data.achieve) do
			local item = self:getAchieveItem(k,v)
			table.insert(self.achieve,item)
		end
	end

	table.sort(self.achieve,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)

	-- for k,v in pairs(self.achieve) do
	-- 	table.sort(v,function(a,b)
	-- 		return tonumber(a.id) < tonumber(b.id)
	-- 	end)
	-- end
end

function ExamineModel:getAchieveItem(id,level)
	local name = self.achieveCfg[tostring(id)].name
    local item = self.achievePlusCfg[tostring(id).."_"..tostring(level)]
    local attr= {}
    for i=1,3 do
    	local name = self.achieveTypeList[tonumber(item["shuxing"..i.."_type"])]
    	local value = item["shuxing"..i.."_val"]
    	local idx = item["shuxing"..i.."_type"]
    	if idx ~= 0 then
    		if idx == 6 or idx == 7 or idx == 9 or idx == 10 or idx == 14 then
    			value = (value / 10).."%"
    		end
    	end
    	-- if id == "4" and (i == 1 or i == 2 ) then
    	-- 	value = (value / 10).."%"
    	-- end
    	table.insert(attr,{["name"]=name,["value"]=value})
    end
    return {["id"]=id,["level"]=level,["name"]=name,["attr"]=attr}
end

function ExamineModel:getTechItem(id,level)
    local name = self.techTypeCfg[tostring(id)].name
    local template = self.techTypeCfg[tostring(id)].template
    local item = self.techValueCfg[tostring(level)]
    local attr = self.techTypeList[item["attribute"..tostring(id)]]
    local value = item["value"..tostring(id)]
    if item["attribute"..tostring(id)] > 3 then
   		value = tostring((value - 1)*100).."%"
    end
    return {["id"]=id,["level"]=level,["name"]=name,["template"]=template,["attr"]=attr,["value"]=value}
end

return ExamineModel
