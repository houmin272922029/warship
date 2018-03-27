--[[
	军功悬赏
	Author: 
	Date: 2016年09月19日18:46:54
]]

local OfferARewardService = qy.class("OfferARewardService", qy.tank.service.BaseService)

local model = qy.tank.model.OfferARewardModel
-- 获取
function OfferARewardService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "reward.get",
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end


-- 获取
function OfferARewardService:getInfo(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "reward.get",
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end


-- 刷新情报
function OfferARewardService:refresh(callback, type)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "reward.refresh",
        ["p"] = {["type"]=type}
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end

-- 获取情报
function OfferARewardService:getInformation(callback, pos)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "reward.getInformation",
        ["p"] = {["pos"]=pos}
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end


-- 立即派遣
function OfferARewardService:dispatch(callback, pos)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "reward.dispatch",
        ["p"] = {["pos"]=pos}
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end


-- 完成
function OfferARewardService:finish(callback, pos, times)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "reward.finish",
        ["p"] = {["pos"]=pos, ["times"]=times}
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end


return OfferARewardService



