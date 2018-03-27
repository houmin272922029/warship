--[[
    说明: qysdk
]]

local qysdk = {}

local platform = device.platform

if platform == "ios" then
    qysdk.luaoc = require "cocos.cocos2d.luaoc"
elseif platform == "android" then
    qysdk.luaj = require "cocos.cocos2d.luaj"
end

local socket = require("socket")
local md5 = require("utils.Md5Util")

local LoginModel =  qy.tank.model.LoginModel
local LoginService = qy.tank.service.LoginService

local pw = md5.sumhexa(qy.LoginConfig.UUID .. qy.LoginConfig.APP_ID .. qy.LoginConfig.APP_KEY)

local _base_url = "http://login.weisanguo.cn/user/?r=qiyoo/%s"
local _xhr = nil
local _url = nil
local _params = nil

local _time = 0

local _onSuccess, _onError, _ioError = nil, nil, nil

--[[ 用户注册或登录(登录奇游平台) ]]
function qysdk.registerOrLogin(nType, params, onSuccess, onError, ioError)
    -- local districtList = LoginModel:getDistrictInfo()
    -- if districtList then
        qysdk.__registerOrLogin(nType, params, onSuccess, onError, ioError)
    -- else
        -- qy.tank.service.LoginService:getDistrictList(function ()
            -- qysdk.__registerOrLogin(nType, params, onSuccess, onError, ioError)
        -- end, onError, ioError)
    -- end
end

function qysdk.__registerOrLogin(nType, params, onSuccess, onError, ioError)
    local action = "login"
    if nType == 1 then
        --注册
        qy.Analytics:onEvent({["name"] = "QY_REGISTER"})
        action = "register"
    elseif nType == 2 then
        --登录
        qy.Analytics:onEvent({["name"] = "QY_LOGIN"})
    end
    qysdk.http(action, {
        ["password"] = params.password,
        ["username"] = params.username
    },function (response)
        LoginModel:saveRegisterData(response.data)
        LoginModel:saveAccountData(params)
        LoginModel:updateVisitorStatus(2)
        LoginService:getDistrictList(onSuccess, onError, ioError)
    end, onError, ioError)
end

--[[ 游客登录 ]]
function qysdk.visitorLogin(nType, onSuccess, onError)
    qy.Analytics:onEvent({["name"] = "VISITOR_LOGIN"})    
    if qy.tank.utils.SDK:channel() == "google" then
        -- qy.Http.new(qy.Http.Request.new({
        --     ["m"] = "system.visitorLogin",
        --     ["p"] = {["mac"] = qy.LoginConfig.UUID,["app_id"] = qy.LoginConfig.APP_ID,["password"] = pw}
        -- })):send(function(response, request)
        --     LoginModel:saveRegisterData(response.data)
        --     LoginModel:updateVisitorStatus(1)
        --     LoginService:getDistrictList(onSuccess, onError)
        -- end)
    
        LoginModel:saveRegisterData({["platform_user_id"]=qy.LoginConfig.UUID,["session_token"]=qy.LoginConfig.UUID,["nickname"]="游客"})
        LoginModel:updateVisitorStatus(1)
        LoginService:getDistrictList(onSuccess, onError)
    else
        qysdk.http("visitorlogin", {
            ["mac"] = qy.LoginConfig.UUID,
            ["app_id"] = qy.LoginConfig.APP_ID,
            ["password"] = pw
        },function (response)
            LoginModel:saveRegisterData(response.data)
            LoginModel:updateVisitorStatus(1)
            -- if nType == 2 then
                LoginService:getDistrictList(onSuccess, onError)
            -- else
            --     onSuccess()
            -- end
        end, onError)
    end
    
end

--[[
    绑定账号
    nType:1:需要获取服务器列表；2:不需要获取
]]
function qysdk.bindAccount(nType, params, callback)
    qy.Analytics:onEvent({["name"] = "QY_BIND_ACCOUNT"})
    qysdk.http("bind", {
        ["mac"] = qy.LoginConfig.UUID,
        ["app_id"] = qy.LoginConfig.APP_ID,
        ["password2"] = pw,
        ["password"] = params.password,
        ["username"] = params.username
    }, function (response)
        LoginModel:saveRegisterData(response.data)
        LoginModel:saveAccountData(params)
        LoginModel:updateVisitorStatus(2)
        if nType == 1 then
            LoginService:getDistrictList(callback)
        else
            callback()
        end
    end)
end

function qysdk.http_response()
    if qy.DEBUG then
        print("登录接口请求时间：" .. (socket.gettime() - _time)  .. "秒")
        print("http request:")
        print(" ", _url)
        print(" ", _params)
        print(" ")
        print("http response:")
        print(" ", _xhr.status)
        print(" ", _xhr.response)
    end

    qy.Event.dispatch(qy.Event.SERVICE_LOADING_HIDE)

    if _xhr.status == 200 then
        local jdata = qy.json.decode(_xhr.response)
        if jdata.code == 200 then
            _onSuccess(jdata)
        else
            qy.hint:show(jdata.data)
            if _onError then
                _onError()
            end
        end
    elseif _xhr.status >= 500 then
        qy.hint:show(qy.TextUtil:substitute(70028) ..  _xhr.status .. qy.TextUtil:substitute(70029))
        if _onError then
            _onError()
        end
    else
        qy.hint:show(qy.TextUtil:substitute(70030))

        if _ioError then
            _ioError()
        end
    end
    -- else
    --     qy.hint:show("网络超时！请点击重试或检查您的网络环境")
    --     if _ioError then
    --         _ioError()
    --     end
    -- end
    _xhr:unregisterScriptHandler()
end

function qysdk.http(action, params, onSuccess, onError, ioError)
    if qy.DEBUG then
        _time = socket.gettime()
    end

    qy.Event.dispatch(qy.Event.SERVICE_LOADING_SHOW)

    _onSuccess = onSuccess
    _onError = onError
    _ioError = ioError

    _url = string.format(_base_url, action)
    _params = qy.json.encode({p = params})

    _xhr = cc.XMLHttpRequest:new()
    _xhr:registerScriptHandler(qysdk.http_response)
    _xhr:open("POST", _url)
    _xhr:send(_params)
end

return qysdk
