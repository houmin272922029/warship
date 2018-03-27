--[[
	
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local LuckyTurntableModel = qy.class("LuckyTurntableModel", qy.tank.model.BaseModel)


function LuckyTurntableModel:init(types,id,need_id)
	self.opentype = types
	self.id = id
	self.need_id = need_id
	self.list = {}
	print("道具id"..types.."lalala"..id.."pppppppp"..need_id)
	local staticData = qy.Config.turntable 
	for k,v in pairs(staticData) do
		if types == v.type then
			table.insert(self.list,v)
		end
	end
	table.sort(self.list, function(a, b)
           return a.id < b.id
    end)
end


return LuckyTurntableModel