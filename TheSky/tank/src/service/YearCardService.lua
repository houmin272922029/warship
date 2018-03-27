--[[--
--充值 service
--Author: H.X.Sun
--Date: 2015-05-04
--]]

local RechargeService = qy.class("RechargeService", qy.tank.service.BaseService)

local model = qy.tank.model.RechargeModel

local _pay_params = {
    amount = 1,
	extra = ""
}

function RechargeService:paymentBegin(data, onSuccess,gift_type,gift_id)
    local loginModel =  qy.tank.model.LoginModel
    local playerInfoEntity = loginModel:getPlayerInfoEntity()

    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Payment.begin",
        ["p"] = 
        {
            ["product_id"]      = data.product_id,
            ["gift_type"]      = gift_type,
            ["gift_id"]      = gift_id,
            ["access_token"]    = playerInfoEntity.session_token
        }
    })):send(function(response, request)
    
    
    
        print("RechargeService paymentBegin","channel="..qy.tank.utils.SDK:channel())
        if qy.tank.utils.SDK:channel() == "qiyou" then
            self:paymentFinish(response.data.token, onSuccess)
        else
            if qy.tank.utils.SDK:channel() == "google" then
                _pay_params.amount = data.product_id
                _pay_params.extra = data.cash
            elseif qy.tank.utils.SDK:channel() == "yijie" or  qy.tank.utils.SDK:channel() == "migu" or  qy.tank.utils.SDK:channel() == "pengyouwan" then
                _pay_params.amount = data.product_id
                _pay_params.extra = response.data.token
            elseif qy.tank.utils.SDK:channel() == "xiongmaowan" then
                _pay_params.amount = data.cash
                _pay_params.extra = response.data.serial
                print("_pay_params.extra====".._pay_params.extra)
            elseif qy.tank.utils.SDK:channel() == "uc" then
                 local client_version = cc.UserDefault:getInstance():getStringForKey("version", "1.0")
                 -- if client_version == "3.1.2" then
                    local  parm = {}
                    parm["token"] = response.data.token
                    parm["sign"] = response.data.sign
                    parm["uid"] = response.data.uid
                    _pay_params.amount = data.cash
                    _pay_params.extra = parm
                 -- else
                 --    _pay_params.amount = data.cash
                 --    _pay_params.extra = response.data.token
                 -- end
             elseif qy.tank.utils.SDK:channel() == "vivo" then
                 local client_version = cc.UserDefault:getInstance():getStringForKey("version", "1.0")
                 -- if client_version == "3.1.2" then
                    local  parm = {}
                    parm["token"] = response.data.token
                    parm["sign"] = response.data.accessKey
                    parm["uid"] = response.data.orderNumber
                    _pay_params.amount = data.cash
                    _pay_params.extra = parm
                 -- else
                 --    _pay_params.amount = data.cash
                 --    _pay_params.extra = response.data.token
                 -- end 
            else
                if qy.tank.utils.SDK:channel() == "xinlang" then -- 新浪loading单独处理
                     qy.Event.dispatch(qy.Event.SERVICE_LOADING_SHOW)
                end
                _pay_params.amount = data.cash
                _pay_params.extra = response.data.token
            end
            qy.tank.utils.SDK:showPayView(_pay_params, function(jdata)
                print("支付完成，开始验证","token="..response.data.token,"jdata="..(jdata and jdata or "nil"))
                -- print("支付完成，开始验证","token="..response.data.token,"jdata="..jdata)
                self:paymentFinish(response.data.token,onSuccess,jdata)
            end)
        end
    end)
end

function RechargeService:paymentFinish(token,onSuccess,jdata)
    onSuccess(3)
    co(function()
        for i = 1, 3 do
            print("第" .. i .. "次查询")
            local status, msg = yield(RechargeService.check(token,i,jdata))
            if status then
                return true
            end

            if i == 3 then
                return false, msg or "充值验证失败，请重启游戏查询是否到帐或与客服联系"
            end
        end
    end, onSuccess)
end

function RechargeService.check(token,delay,jdata)
    return function(__next)
        local m = ""
        if qy.tank.utils.SDK:channel() == "qiyou" then
            m = "Payment.dev_finish_payment"
        elseif qy.tank.utils.SDK:channel() == "google" then
            m = "Payment.beginGooglePayCheck"
        else
            m = "Payment.finish_payment"
        end

        qy.Http.new(qy.Http.Request.new({
            ["m"] = m,
            ["p"] = {["token"] = token,['data']=jdata and qy.json.decode(jdata) or nil}
        })):send(function(response, request)
            -- local cash = response.data.recharge.cash
            -- local coin = response.data.recharge.add_gem
            -- if cash and coin then
            --     require("utils.Analytics"):onPay(cash, coin)
            -- end
            __next(true)
        end, function(data)
            qy.Timer.create(tostring(math.random()),function()
                __next(false, data.error_msg)
            end, delay * 2, 1)
        end)
    end
end

return RechargeService
