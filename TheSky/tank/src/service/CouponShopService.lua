--[[

]]--

local CouponShopService = qy.class("CouponShopService", qy.tank.service.BaseService)

local model =  qy.tank.model.CouponShopModel


--[[
    获取界面的信息  
    "m":"shop.shopping",
    "p":{
      "goodslist": {"1":99,"3":99},
       "type":1
    } 
]]--
function CouponShopService:GetgetawardData(type,extend,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "shop.shopping",
        ["p"] = {
                    ["goodslist"] = model:GetShopTable(),
                    ["type"]=model:GetAtType(),
                }
    })):send(function(response, request)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award,{["critMultiple"] = false})
        model.mGwcData = {}
        model:GetModleMainlayer():UpdateTableViewInAll()
        callback(response)
    end)
end

function CouponShopService:GetpropsList( param, callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "shop.shoplist",
                ["p"] = {
                    ["kid"] = qy.tank.model.UserInfoModel.userInfoEntity.kid,
                    ["type"]=param["index"],
                }
    })):send(function(response, request)
        model:init(response.data,param["index"])
        callback()

    end)
end


function CouponShopService:UpdatePropsList(  callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "shop.resetshop",
                ["p"] = {
                    ["type"]=model:GetAtType(),
                }
    })):send(function(response, request)
        callback()

        model:init(response.data,model:GetAtType())
        model:GetModleMainlayer():UpdateTableViewInAll()
    end)
end



return CouponShopService
