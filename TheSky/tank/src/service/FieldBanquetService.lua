

local FieldBanquetService = qy.class("FieldBanquetService", qy.tank.service.BaseService)

local model = qy.tank.model.FieldBanquetModel



-- -- -- 获取
function FieldBanquetService:getInfo(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "war_party"}
    })):send(function(response, request)
       model:init(response.data.activity_info)
       callback()
    end)
end

function FieldBanquetService:getAward(type,id,callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getAward",
       ["p"] = {
                ["activity_name"] = "war_party",
                ["id"] = id,
                ["type"] = type
   }
    })):send(function(response, request)
    	qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award,{["isShowHint"]=false})
       --model:init(response.data)
       	model:change_attr(response.data.user_activity_data)
       callback(response.data)
    end)
end

function FieldBanquetService:getRefresh2(type,id,callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getAward",
       ["p"] = {
                ["activity_name"] = "war_party",
                ["id"] = id,
                ["type"] = type
   }
    })):send(function(response, request)
       model:chage_user_data(response.data.user_activity_data)
       callback(response.data)
    end)
end

function FieldBanquetService:getRefresh(type,callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getAward",
       ["p"] = {
                ["activity_name"] = "war_party",
                ["type"] = type
   }
    })):send(function(response, request)
    	model:chage_user_data(response.data.user_activity_data)
        callback(response.data)
    end)
end

function FieldBanquetService:getJihuo(type,id,callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getAward",
       ["p"] = {
                ["activity_name"] = "war_party",
                ["id"] = id,
                ["type"] = type
   }
    })):send(function(response, request)
       model:chage_user_data(response.data.user_activity_data)
    	model:setTankEntity(response.data.user_activity_data)
       callback(response.data)
    end)
end

return FieldBanquetService
