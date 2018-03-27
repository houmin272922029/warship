--[[
	军奥会
	Author: Aaron Wei
	Date: 2016-09-09 18:11:16
]]

local OlympicService = qy.class("OlympicService", qy.tank.service.BaseService)

OlympicService.model = qy.tank.model.OlympicModel

function OlympicService:join(type,num,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.junaohui_game",
        ["p"] = {["type"] = type,["num"]=num}
    }))
    -- :setShowLoading(false)
    :send(function(response, request)
        self.model.key = response.data.key
        self.model.times = num
        self.model:updateJoin(response.data)
        callback()
    end)
end


function OlympicService:score(type,key,score,num,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.junaohui_score",
        ["p"] = {["type"]=type,["key"]=key,["source"]=score,["num"]=num}
    })):send(function(response, request)
        self.model.source = response.data.source
        self.model.sourceLabel:setString(self.model.source.." 积分")
        callback()
    end)
end


function OlympicService:rank_list(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.junaohui_rank_list",
        ["p"] = {}
    })):send(function(response, request)
        self.model:initRankList(response.data)
        callback()
    end)
end


function OlympicService:shop(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.junaohui_shop",
        ["p"] = {}
    })):send(function(response, request)
        self.model:updateGoods(response.data)
        callback(response.data)
    end)
end

--远征商店兑换
function OlympicService:exchange(id, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.junaohui_shop_pay",
        ["p"] = {["good_id"]=id}
    })):send(function(response, request)
        self.model:updateGoods(response.data)
        callback(response.data)
    end)
end

return OlympicService
