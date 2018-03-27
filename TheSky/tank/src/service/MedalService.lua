--[[
	
	Author: 
	Date: 2016年07月13日15:08:24
]]

local MedalService = qy.class("MedalService", qy.tank.service.BaseService)

local model = qy.tank.model.MedalModel
-- 获取
function MedalService:init( callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Medal.medalMain",
        ["p"] = {
    }
    })):send(function(response, request)
        model:initnum(response.data)
        callback()
    end)
end
--激活属性
function MedalService:activateAttr( unid_id,num,callback )
    -- unique_id是勋章唯一Id  , num是激活第几条属性,只能是1和2,
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Medal.activateAttr",
        ["p"] = {
        ["unique_id"] = unid_id,
        ["num"] = num
    }
    })):send(function(response, request)
        model:updatemedalById(response.data.medal)
        callback(response.data.medal)
    end)
end
--戴上勋章
function MedalService:medalPutOn( unid_id,tank_id,callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Medal.medalPutOn",
        ["p"] = {
        ["unique_id"] = unid_id,
        ["tank_unique_id"] = tank_id
    }
    })):send(function(response, request)
        print("装上了勋章",json.encode(response.data.medal))
        model:updatemedalById(response.data.medal)
        callback(response.data)
    end)
end
--卸下勋章
function MedalService:medalTakeOff( tank_id,pos,callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Medal.medalTakeOff",
        ["p"] = {
            ["pos"] = pos,
            ["tank_unique_id"] = tank_id
        }
    })):send(function(response, request)
        print("卸下了勋章",json.encode(response.data.medal))
        model:updatemedalById(response.data.medal)
        callback(response.data)
    end)
end
--分解自动转化接口
function MedalService:directDecomposeColour(param,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Medal.directDecomposeColour",
        ["p"] = {
            ["colours"] = param
        }
    })):send(function(response, request)
        model:initchangelist(response.data)
        callback()
    end)
end
--精铸接口
function MedalService:EliteAttr(unique_id,lock,callback )
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Medal.eliteAttr",
       ["p"] = {
            ["unique_id"]= unique_id,
            ["x"] = lock
        }
    })):send(function(response, request)
        model:updatemedalById(response.data.medal)
        callback(response.data.medal)
    end)
end
--精铸10接口
function MedalService:ElitetenAttr(unique_id,lock,callback )
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Medal.eliteAttr",
       ["p"] = {
            ["unique_id"]= unique_id,
            ["x"] = lock,
            ["times"] = 10
        }
    })):send(function(response, request)
        model:updatemedalById(response.data.medal)
        callback(response.data)
    end)
end
--重铸
function MedalService:RecastAttr( unique_id,lock,callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Medal.recastAttr",
        ["p"] = {
        ["unique_id"]= unique_id,
        ["lock"] = lock
    }
    })):send(function(response, request)
        model:updatemedalById(response.data.medal)
        callback(response.data.medal)
    end)
end
--保存结果
function MedalService:saveRecast( unique_id,callback )
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
function MedalService:fenjie(param,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Medal.decompose",
        ["p"] = {
            ["unique_ids"] = param
        }
    })):send(function(response, request)
    model:removemedalById(response.data.remove)
    if response.data.award then
        qy.tank.command.AwardCommand:show(response.data.award)
    end
        callback()
    end)
end
--展示接口
function MedalService:showMedalToWorld( id ,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Medal.medalShare",
        ["p"] = {
            ["medal_uid"] = id
        }
    })):send(function(response, request)
        callback()
    end)
end

return MedalService



