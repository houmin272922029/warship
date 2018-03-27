--[[
	
	Author: 
	Date: 2016年07月13日15:08:24
]]

local FittingsService = qy.class("FittingsService", qy.tank.service.BaseService)

local model = qy.tank.model.FittingsModel
--戴上配件
function FittingsService:fittingsPutOn( unid_id,tank_id,callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "fittings.fittingsPutOn",
        ["p"] = {
        ["unique_id"] = unid_id,
        ["tank_unique_id"] = tank_id
    }
    })):send(function(response, request)
        model:updatemedalById(response.data.fittings)
        callback(response.data)
    end)
end
--卸下配件
function FittingsService:fittingsOff( tank_id,pos,callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "fittings.fittingsTakeOff",
        ["p"] = {
            ["pos"] = pos,
            ["tank_unique_id"] = tank_id
        }
    })):send(function(response, request)
        model:updatemedalById(response.data.fittings)
        callback(response.data)
    end)
end
--精炼接口
function FittingsService:EliteAttr(unique_id,callback )
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "fittings.upgradeFittings",
       ["p"] = {
            ["unique_id"]= unique_id
        }
    })):send(function(response, request)
        model:updatemedalById(response.data.fittings)
        callback(response.data.fittings)
    end)
end
--一键熔炼
function FittingsService:smeltByQuality( quality,callback )
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "fittings.smeltByQuality",
       ["p"] = {
            ["quality"]= quality
        }
    })):send(function(response, request)
        if response.data.fittings then
             model:updatemedalById1(response.data.fittings)
        end
        if response.data.remove then
            model:removemedalById(response.data.remove)
        end
        if response.data.award then
            qy.tank.command.AwardCommand:show(response.data.award)
        end
        callback(response.data.fittings)
    end)
end
--熔炼
function FittingsService:smeltFittings( unique_id,callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "fittings.smeltFittings",
        ["p"] = {
        ["unique_ids"]= unique_id
    }
    })):send(function(response, request)
         if response.data.fittings then
             model:updatemedalById1(response.data.fittings)
        end
        if response.data.remove then
            model:removemedalById(response.data.remove)
        end
        if response.data.award then
            qy.tank.command.AwardCommand:show(response.data.award)
        end
        callback(response.data.medal)
    end)
end
--保存结果
function FittingsService:saveRecast( unique_id,callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Medal.saveRecast",
        ["p"] = {
        ["unique_id"]= unique_id
        }
    })):send(function(response, request)
        model:updatemedalById(response.data.medal) 
        callback(response.data.medal)
    end)
end
--分解
function FittingsService:fenjie(param,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "fittings.resolveByUid",
        ["p"] = {
            ["uids"] = param
        }
    })):send(function(response, request)
    model:removemedalById(response.data.remove)
    if response.data.award then
        -- qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
    end
        callback()
    end)
end
function FittingsService:resolveByQuality( qulity,callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "fittings.resolveByQuality",
        ["p"] = {
            ["quality"] = qulity
        }
    })):send(function(response, request)
    model:removemedalById(response.data.remove)
    if response.data.award then
        qy.tank.command.AwardCommand:show(response.data.award)
    end
        callback()
    end)
end
--商店入口
function FittingsService:showShopView(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "fittings.shop",
        ["p"] = {}
    })):send(function(response, request)
        model:initShopList(response.data)
        callback()
    end)
end
--刷新商店
function FittingsService:refreshShopView(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "fittings.handRushShop",
        ["p"] = {}
    })):send(function(response, request)
        model:initShopList(response.data)
        callback()
    end)
end
--购买
function FittingsService:buyshopById(ID,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "fittings.buyshop",
        ["p"] = {["id"] = ID}
    })):send(function(response, request)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
        model:updateShopList(response.data)
        callback()
    end)
end


return FittingsService



