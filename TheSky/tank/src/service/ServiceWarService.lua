--[[
	跨服战
	Date: 2016-05-10 
]]

local ServiceWarService = qy.class("ServiceWarService", qy.tank.service.BaseService)

local model = qy.tank.model.ServiceWarModel

--获取首页
function ServiceWarService:getList(callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservice.index",
    })):send(function(response, request)
    	model:entryQualification(response.data)
        callback(response.data)
    end)
end

--跨服战排名
function ServiceWarService:getRankList(page, callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "interservice.joinlist",
		["p"] = {["page"] = page}
		})):send(function (response, request)
			model:getRankList(response.data)
			callback(response.data)
	end)
end

--押注
function ServiceWarService:Bet(targetkid, callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "interservice.bet",
		["p"] = {["targetkid"] = targetkid}
		})):send(function (response, request)
		    model:bet(response.data)
		    callback(response.data)
	end)
end

--战斗
function ServiceWarService:Battle(targetkid, currentranking, targetcurrentranking, callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "interservice.battle",
		["p"] = {
					["targetkid"] = targetkid,
					["currentranking"] = currentranking,
					["targetcurrentranking"] = targetcurrentranking,
				}
		})):send(function (response, request)
		model:getFighting(response.data)
		qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.model.BattleModel:init(response.data.fight_result)
        callback(response.data)
	end)
end
 
 --购买战斗次数
function ServiceWarService:BuyBattleNum(_type, callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "interservice.attendnumserver",
		["p"] = {
					["type"] = _type,
					-- ["kid"] = kid,
				}
		})):send(function (response, request)
			model:BuyNum(response.data)
			callback(response.data)
	end)
end

--跨服商店列表
function ServiceWarService:ShopList(callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "interservice.shoplist",
		})):send(function (response, request)
			model:getShopList(response.data)
			callback(response.data)
	end)
end
--跨服商城购买
function ServiceWarService:Buyitems(goodid, callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "interservice.shoppay",
		["p"] = {["goodid"] = goodid}
		})):send(function (response, request)
			model:BuyItems(response.data)
			qy.tank.command.AwardCommand:add(response.data.award)
 	      	qy.tank.command.AwardCommand:show(response.data.award)
			callback()
	end)
end

--查看战况列表
function ServiceWarService:WatchDetailList(page, callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "interservice.battlelist",
		["p"] = {["page"] = page}
		})):send(function (response, request)
			model:getWarDetail(response.data)
			callback(response.data)
	end)
end
 
--查看战况详情
function ServiceWarService:WatchDetail(battleid, callback)
 	qy.Http.new(qy.Http.Request.new({
		["m"] = "interservice.findbattle",
		["p"] = {
					["battleid"] = battleid,
					-- ["currentranking"] = currentranking,
					-- ["targetcurrentranking"] = targetcurrentranking,
				}
				})):send(function (response, request)

        	qy.tank.model.BattleModel:init(response.data.fight_result)
			-- model:getWarDetail(response.data)
			callback(response.data)
	end)
 end

--查看用户资料
-- function ServiceWarService:UserInfo(battleid, callback)
-- 	qy.Http.new(qy.Http.Request.new({
-- 		["m"] = "interservice.finduserinfo",
-- 		["p"] = {["battleid"] = battleid}
-- 		})):send(function (response, request)
-- 			model:getWarDetail(response.data)
-- 			callback(response.data)
-- 	end)
-- end

--领取押注奖励
function ServiceWarService:GetAwards(callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "interservice.getbetreward",
		})):send(function (response, request)
		model:refersh(response.data)
		qy.tank.command.AwardCommand:add(response.data.award)
 	    qy.tank.command.AwardCommand:show(response.data.award)
		callback(response.data)
	end)
end

--全服礼包
-- function ServiceWarService:GetAllAwardsList(callback)
-- 	qy.Http.new(qy.Http.Request.new({
-- 		["m"] = "interservice.getwelfalelist",
-- 		})):send(function (response, request)
-- 			model:getAll(response.data)
-- 			callback(response.data)
-- 	end)
-- end

--领取全服礼包
function ServiceWarService:GetAllAwards(callback, show)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "interservice.getwelfale",
		})):send(function (response, request)
		model:getReward(response.data)
		qy.tank.command.AwardCommand:add(response.data.award)
		if show then
 	    	qy.tank.command.AwardCommand:show(response.data.award)
 	    end
		callback(response.data)
	end)
end
return ServiceWarService