--[[
	
	Author: 跨服军神榜
	Date: 2016年12月15日13:53:53
]]

local InterServiceArenaService = qy.class("InterServiceArenaService", qy.tank.service.BaseService)

local model = qy.tank.model.InterServiceArenaModel
-- 获取
function InterServiceArenaService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservicearena.index",
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end

--换人（可以挑战的人）
function InterServiceArenaService:change(callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "interservicearena.change",
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end

--战报列表
function InterServiceArenaService:battlelist(callback, type, page, pagesize)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "interservicearena.battlelist",
       ["p"] = {["type"] = 200, ["page"] = page, ["pagesize"] = 5}
    })):send(function(response, request)
       callback(response.data)
    end)
end


--总排行榜
function InterServiceArenaService:getRankList(callback, page, pagesize)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "interservicearena.get_rank_list",
       ["p"] = {["page"] = page, ["pagesize"] = 20}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end


--获取战报
function InterServiceArenaService:findbattle(callback, battleid)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "interservicearena.findbattle",
       ["p"] = {["battleid"] = battleid}
    })):send(function(response, request)
       callback(response.data)
    end)
end



--购买次数
function InterServiceArenaService:attendnumserver(callback, num)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "interservicearena.attendnumserver",
       ["p"] = {["num"] = num}
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end

--扫荡
function InterServiceArenaService:sweep(callback, rank)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "interservicearena.sweep",
       ["p"] = {["type"] = 200, ["def_rank"] = rank}
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end

function InterServiceArenaService:getSourceAward(callback, type, source)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "interservicearena.get_source_award",
       ["p"] = {["type"] = type, ["source"] = source}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end

function InterServiceArenaService:getStageAward(callback, type, stage)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "interservicearena.get_stage_award",
       ["p"] = {["type"] = type, ["stage"] = stage}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end


function InterServiceArenaService:getDayAward(callback, day)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "interservicearena.get_day_award",
       ["p"] = {["day"] = day}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end


--分享
function InterServiceArenaService:send(callback, battleid)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "interservicearena.send_battle",
       ["p"] = {["battleid"] = battleid}
    })):send(function(response, request)
       callback(response.data)
    end)
end


--显示某人的详细信息
function InterServiceArenaService:userShow(callback, uid)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "user.show",
       ["p"] = {["uid"] = uid, ["type"] = 200}
    })):send(function(response, request)
       callback(response.data)
    end)
end

--战斗
function InterServiceArenaService:battle(callback, rank)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "interservicearena.battle",
        ["p"] = {["def_rank"] = rank}
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end


return InterServiceArenaService