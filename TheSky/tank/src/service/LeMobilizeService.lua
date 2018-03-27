--[[
    军团
    Author: H.X.Sun
]]

local LeMobilizeService = qy.class("LeMobilizeService", qy.tank.service.BaseService)

local model = qy.tank.model.LeMobilizeModel

--获取动员列表
function LeMobilizeService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "LegionSport.sport_list",
        ["p"] = {}
    })):send(function(response,request)
        model:init(response.data)
        callback(response.data)
    end)
end

--发起
function LeMobilizeService:create(id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "LegionSport.sport_create",
        ["p"] = {["id"] = id}
    })):send(function(response,request)
        model:updateForCreate(id)
        model:updateInitiate(response.data)
        callback(response.data)
    end)
end

--刷新
function LeMobilizeService:refresh(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "LegionSport.sport_refresh",
        ["p"] = {["id"] = id}
    })):send(function(response,request)
        model:updateInitiate(response.data)
        callback(response.data)
    end)
end

--加入
function LeMobilizeService:join(uid,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "LegionSport.sport_join",
        ["p"] = {["unique_id"] = uid}
    })):send(function(response,request)
        model:updateForJoin(uid)
        callback(response.data)
    end)
end

--领奖
function LeMobilizeService:getAward(uid,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "LegionSport.sport_award",
        ["p"] = {["unique_id"] = uid}
    })):send(function(response,request)
        model:removeOneMobi(uid)
        callback(response.data)
    end)
end

return LeMobilizeService
