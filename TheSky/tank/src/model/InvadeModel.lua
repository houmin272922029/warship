--[[
    伞兵入侵model
    add by lianyi
]]
local InvadeModel = qy.class("InvadeModel", qy.tank.model.BaseModel)

function InvadeModel:init() 
	self.invade_monster = qy.Config.invade_monster
    self.invade_checkpoint = qy.Config.invade_checkpoint
end

function InvadeModel:update(data) 
	self.fightData = data
end

--通过ID获取伞兵入侵配置数据
function InvadeModel:getConfigDataById(fid )
	for id,configData in pairs(self.invade_checkpoint) do
		if tonumber(fid) == tonumber(id) then 
			return configData
		end
	end
	return nil
end

function InvadeModel:getCurrentFightData()
	return self.fightData
end

return InvadeModel
