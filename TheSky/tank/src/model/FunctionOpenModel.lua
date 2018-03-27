--[[--
--功能开启 model
--Author: H.X.Sun
--Date: 2015-07-22
--]]
local FunctionOpenModel = qy.class("FunctionOpenModel", qy.tank.model.BaseModel)

--[[--
--开启竞技场等级
--]]
function FunctionOpenModel:getLevelOfOpenArena()
	local data = qy.Config.function_open
	local moduleType = qy.tank.view.type.ModuleType
	local _openViewId = qy.tank.utils.ModuleUtil.getViewIdByType(moduleType.ARENA)
	for _k, _v in pairs(data) do
		if data[_k].view_id == _openViewId then
			return data[_k].open_level
		end
	end

	return 0
end


return FunctionOpenModel