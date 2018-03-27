--[[
    军团战
    Author: H.X.Sun
]]

local LegionWarService = qy.class("LegionWarService", qy.tank.service.BaseService)

local model = qy.tank.model.LegionWarModel
local userModel = qy.tank.model.UserInfoModel

function LegionWarService:get(_isShowLoading,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "LegionFight.main",
        ["p"] = {}
    }))
    :setShowLoading(_isShowLoading)
    :send(function(response,request)
        cc.UserDefault:getInstance():setStringForKey("legion_fight_main_time",userModel.serverTime)
        model:update(response.data)
        callback(response.data)
    end)
end

function LegionWarService:join(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "LegionFight.one_sign_up",
        ["p"] = {}
    })):send(function(response,request)
        model:join(response.data)
        callback(response.data)
    end)
end

--查看战报
function LegionWarService:showCombat(combatId, callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "user.show_combat",
		["p"] = {["combat_id"] = combatId}
	})):send(function(response, request)
		qy.tank.model.BattleModel:init(response.data.combat)

		if response.data.award then
			qy.tank.model.BattleModel:initAward(response.data.award)
		end
		callback(response.data)
	end)
end

function LegionWarService:getCombatList(callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "LegionFight.combat_list",
		["p"] = {}
	})):send(function(response, request)
		model:initCombatList(response.data)
		callback(response.data)
	end)
end

function LegionWarService:getRankList(callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "LegionFight.rank",
		["p"] = {}
	})):send(function(response, request)
		model:initRankList(response.data)
		callback(response.data)
	end)
end

function LegionWarService:cancel_join(callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "LegionFight.cancel_sign_up",
		["p"] = {}
	})):send(function(response, request)
		model:cancelJoin(response.data)
		callback(response.data)
	end)
end

function LegionWarService:groupWar(war_key,callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "LegionFight.final_round",
		["p"] = {["legion_id_str"] = war_key}
	})):send(function(response, request)
		qy.tank.model.WarGroupModel:initWarData(response.data)
		callback(response.data)
	end)
end

function LegionWarService:getShopList(_isShowLoading,callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "legion.shop",
		["p"] = {}
	}))
    :setShowLoading(_isShowLoading)
    :send(function(response, request)
        model:initShopList(response.data)
		callback(response.data)
	end)
end

function LegionWarService:shopBuy(index,id,callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "legion.shop_buy",
		["p"] = {["id"] = id}
	})):send(function(response, request)
        if response.data.award then
	        qy.tank.command.AwardCommand:show(response.data.award)
            qy.tank.command.AwardCommand:add(response.data.award)
            model:dealShopBuy(index)
        end
		callback(response.data)
	end)
end

return LegionWarService
