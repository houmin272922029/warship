local HelpModel = qy.class("HelpModel", qy.tank.model.BaseModel)

function HelpModel:init()
 	local data = qy.Config.help
 	local list = {}

 	for i, v in pairs(data) do
 		table.insert(list, v)
 	end

 	table.sort(list, function(a, b)
 		return a.id < b.id
 	end)

 	self.list = {}
 	self.titleList1 = {} -- 一级 title 列表
 	self.titleList2 = {} -- 二级 title 列表
 	for i, v in pairs(list) do
 		local entity = require("help.src.HelpEntity").new(v)
 		if not self.list[tostring(v.id1)] then
 			self.list[tostring(v.id1)] = {}
 			self.titleList1[tostring(v.id1)] = v.title1
 			self.list[tostring(v.id1)][tostring(v.id2)] = {}
 			table.insert(self.list[tostring(v.id1)][tostring(v.id2)], entity)
 		elseif not self.list[tostring(v.id1)][tostring(v.id2)] then
 			self.list[tostring(v.id1)][tostring(v.id2)] = {}
 			table.insert(self.list[tostring(v.id1)][tostring(v.id2)], entity)
 		else
 			table.insert(self.list[tostring(v.id1)][tostring(v.id2)], entity)
 		end

 		if not self.titleList2[tostring(v.id1)] then
 			self.titleList2[tostring(v.id1)] = {}
 			self.titleList2[tostring(v.id1)][tostring(v.id2)] = v.title2
 		else
 			self.titleList2[tostring(v.id1)][tostring(v.id2)] = v.title2
 		end
 	end
end

-- 获取一级title
function HelpModel:atTitle1(idx)
	return self.titleList1[tostring(idx)]
end

-- 获取二级 title
function HelpModel:atTitle2(idx)
	return self.titleList2[tostring(idx)]
end

HelpModel:init()

return HelpModel
