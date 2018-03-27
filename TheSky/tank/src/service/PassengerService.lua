--[[
	乘员系统
	Date: 2016-07-12 15:49:49
]]

local PassengerService = qy.class("PassengerService", qy.tank.service.BaseService)

-- 主接口
function PassengerService:getPassengerlist(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "passenger.getpassengerlist",
    })):send(function(response, request)
        qy.tank.model.PassengerModel:init(response.data)
        callback(response.data)
    end)
end

-- 招募 type 100 普通抽卡 200 钻石抽卡
function PassengerService:extract(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "passenger.extract",
        ["p"] = param,
    })):send(function(response, request)
        qy.tank.model.PassengerModel:extract(response.data)
        callback(response.data)
    end)
end

-- 装载 卸载 乘员  type 100 装 200 卸 tankid 坦克id passengid 乘员id
function PassengerService:joinformation(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "passenger.joinformation",
        ["p"] = param,
    })):send(function(response, request)
        qy.tank.model.PassengerModel:updateData(response.data)
        callback(response.data)
    end)
end

-- 乘员升级
function PassengerService:uplevel(param,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "passenger.uplevel",
        ["p"] = param,
    })):send(function(response, request)
        qy.tank.model.PassengerModel:updateData(response.data)
        callback(response.data)
    end)
end
-- 乘员一键升级
function PassengerService:uplevelAuto(param,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "passenger.uplevelAuto",
        ["p"] = param,
    })):send(function(response, request)
        qy.tank.model.PassengerModel:updateData(response.data)
        callback(response.data)
    end)
end
-- 乘员进修
function PassengerService:study(type,pas_id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "passenger.study",
        ["p"] = {
        ["type"] = type,
        ["passengid"] = pas_id,
        },
    })):send(function(response, request)
        qy.tank.model.PassengerModel:updateData1(response.data)
        callback(response.data)
    end)
end
-- 乘员晋升
function PassengerService:promote(pas_id,other_id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "passenger.promote",
        ["p"] = {
        ["other_id"] = other_id,
        ["passengid"] = pas_id,
        },
    })):send(function(response, request)
        qy.tank.model.PassengerModel:updateData1(response.data)
        callback(response.data)
    end)
end

return PassengerService



