--[[
    群战
    Author: H.X.Sun
]]

local WarGroupService = qy.class("WarGroupService", qy.tank.service.BaseService)

local model = qy.tank.model.WarGroupModel

function WarGroupService:groupWar(war_key,callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "LegionFight.final_round",
		["p"] = {["legion_id_str"] = war_key}
	})):send(function(response, request)
		model:initWarData(response.data)
		callback(response.data)
	end)
end

return WarGroupService
