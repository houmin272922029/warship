local BlackListService = qy.class("BlackListService", qy.tank.service.BaseService)
function BlackListService:getBlackList(id, type, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "user.blacklist",
        ["p"] = {
            ["uid"] = id,
            ["type"] = type,
        }
    })):send(function(response, request)
        callback(response.data)
    end)
end
return BlackListService