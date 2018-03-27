--[[
	
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local BreakFireModel = qy.class("BreakFireModel", qy.tank.model.BaseModel)


local userinfoModel = qy.tank.model.UserInfoModel
BreakFireModel.inPosition = {
	    ["1"] = cc.p(50, 405),["2"] = cc.p(140, 405),["3"] = cc.p(230, 405),["4"] = cc.p(320, 405),["5"] = cc.p(410, 405),["6"] = cc.p(500, 405),
	    ["7"] = cc.p(590, 405),["8"] = cc.p(680, 405),["9"] = cc.p(770, 405),["10"] = cc.p(860, 405),["11"] = cc.p(860, 315),["12"] = cc.p(860, 225),
	    ["13"] = cc.p(860, 135),["14"] = cc.p(860, 45),["15"] = cc.p(770, 45),["16"] = cc.p(680, 45),["17"] = cc.p(590, 45),["18"] = cc.p(500, 45),
	    ["19"] = cc.p(410, 45),["20"] = cc.p(320, 45),["21"] = cc.p(230, 45),["22"] = cc.p(140, 45),["23"] = cc.p(50, 45),["24"] = cc.p(50, 135),
	    ["25"] = cc.p(50, 225),["26"] = cc.p(140, 225),["27"] = cc.p(230, 225),["28"] = cc.p(320, 225),["29"] = cc.p(410, 225),["30"] = cc.p(500, 225)
	}

function BreakFireModel:init(data)
	self.crosscfg = qy.Config.crossfire
	self.crossfire_random ={}
	local data1 = qy.Config.crossfire_random
	self.crossfire_final = {}
	local data2 = qy.Config.crossfire_final
	for i, v in pairs(data1) do
		table.insert(self.crossfire_random, v)
	end

	table.sort(self.crossfire_random,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)
	for i, v in pairs(data2) do
		table.insert(self.crossfire_final, v)
	end

	table.sort(self.crossfire_final,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)
	self.endtime = data.end_time 
	self.settup =data.pos
	self.totalnums = data.times 
	self.lattice = data.lattice
end
function BreakFireModel:getlist( ids )
	local xx = ids/5
	local list = {}
	for k,v in pairs(self.crossfire_random) do
		if v.args ==xx then
			table.insert(list,v)
		end
	end
	table.sort(list,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)
	return list
end



function BreakFireModel:update(data)
	print("============刷新",json.encode(data))
	self.settup =data.pos
	self.totalnums = data.times 
	self.lattice = data.lattice
end



return BreakFireModel