
 --[[
	战争图卷
	Author: 
	Date: 2016年07月13日15:08:24
]]

local WarPictureService = qy.class("WarPictureService", qy.tank.service.BaseService)

local model = qy.tank.model.WarPictureModel
-- 获取
function WarPictureService:get(callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "warfarejigsaws.main",
    })):send(function(response, request)
       model:init(response.data)
       callback(response.data)
    end)
end


-- 开始
function WarPictureService:start(callback, imgid)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "warfarejigsaws.start",
       ["p"] = {["imgid"]=imgid}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end


-- 刷新
function WarPictureService:update(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "warfarejigsaws.update",
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end


-- 放弃
function WarPictureService:reset(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "warfarejigsaws.reset",
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end

-- 支付购买
function WarPictureService:pay(callback, type)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "warfarejigsaws.pay",
        ["p"] = {["type"]=type}
    })):send(function(response, request)
        model:update(response.data)
        callback()
    end)
end


-- 一键完成
function WarPictureService:complete(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "warfarejigsaws.complete",
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end

--锁定
function WarPictureService:locking(callback, type, position)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "warfarejigsaws.locking",
        ["p"] = {["type"]=type, ["position"]=position}
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end




return WarPictureService



