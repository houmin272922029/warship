--[[
	商店服务器
	Author: Aaron Wei
	Date: 2015-03-20 10:39:36
]]

local ShopService = qy.class("ShopService", qy.tank.service.BaseService)

ShopService.tankModel = qy.tank.model.TankShopModel
ShopService.propModel = qy.tank.model.PropShopModel

-- 兑换坦克
function ShopService:exchangeTank(view_idx,id,callback)
    local _m
    if view_idx == 3 then
        -- 兑换声望坦克
        _m = "shop.reputationTank"
    else
        -- 兑换普通坦克
        _m = "shop.tankShop"
    end
    qy.Http.new(qy.Http.Request.new({
        ["m"] = _m,
        ["p"] = {["id"]=id}
    })):send(function(response, request)
        callback(response.data)
    end)
end

-- 购买道具&装备
function ShopService:buyProp(id,num,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "shop.propsShop",
        ["p"] = {["id"]=id,["num"]=num}
    })):send(function(response, request)
        qy.tank.command.AwardCommand:add(response.data.award)
        if response.data.next_consume and response.data.next_consume > 0 then
            self.propModel:updateConsum(id, response.data.next_consume)
        end

        callback(response.data)
    end)
end

-- 获取道具&装备列表
function ShopService:propsList(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "shop.propsList",
        -- ["p"] = param
    })):send(function(response, request)
        self.propModel:updateAllConsume(response.data.list)
        callback()
    end)
end

return ShopService
