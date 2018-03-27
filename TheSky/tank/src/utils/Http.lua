--[[
    说明: Http请求库
    TODO: 实现队列功能, 加入协程
    usage:
        qy.Http.new(qy.Http.Request.new(params[, qy.Http.GET | qy.Http.POST]):send(function(response)
            print(response.code, response.data)
        end))
]]

local Http = class("Http")

local socket = require("socket")

local Game = qy.tank.model.Game

local url = nil

-- 请求方法常量
Http.GET = "GET"
Http.POST = "POST"

Http.Request = class("HttpRequest")
Http.Response = class("HttpResponse")

-- 提供一个重置url的方法
function Http.seturl()
    local userDefault = cc.UserDefault:getInstance()
    local version = userDefault:getStringForKey("version", "1.0");
    local ver = (function()
        if qy.SERVER_VERSION then
            return qy.SERVER_VERSION
        elseif qy.product == "local" or qy.product == "develop" then
            return "develop"
        else
            local package_code = userDefault:getStringForKey("package_code", "0")
            return package_code
        end
    end)()
    url = string.format("%s://%s:%s/%s&ver=%s&client_ver=%s",
        qy.SERVER_SCHEME,
        qy.SERVER_DOMAIN,
        qy.SERVER_PORT,
        qy.SERVER_PATH,
        ver,
        version
    )

    --英文开发服 需要加 config
    if qy.product == "develop" or qy.product == "local" then
        if qy.language == "en" then
            url = url .. "&config=en"
        end
    end
end

function Http:ctor(request)
    self.showLoading = true
    self.request = request
end

function Http:setShowLoading(bool)
    self.showLoading = bool
    return self
end

function Http:send(onSuccess,onError,ioError)
    local sendTime = socket.gettime()

    if self.showLoading then
        qy.Event.dispatch(qy.Event.SERVICE_LOADING_SHOW)
    end

    if qy.DEBUG then
        print("url: " .. url)
        print("params: " ..qy.json.encode(self.request.params))
    end

    local xhr = cc.XMLHttpRequest:new()

    local function onReadyStateChange()
        if qy.DEBUG then
            print(self.request.params.m .. "接口请求时间：" .. socket.gettime() - sendTime .. "秒")
        end

        if self.showLoading then
            qy.Event.dispatch(qy.Event.SERVICE_LOADING_HIDE)
        end

        qy.Event.dispatch(qy.Event.SCENE_TRANSITION_HIDE)

        if qy.DEBUG then
            print("http response: ")
            print("response code: ", xhr.status)
            local response = qy.json.decode(xhr.response)
            print(" ", qy.json.encode(response))
        end

        if xhr.status == 200 then
            local jdata = qy.json.decode(xhr.response)
            if jdata == nil then
                --正式服：代码错误
                qy.hint:show(qy.TextUtil:substitute(70018))
            end
            if not jdata.error_code then
                -- 游戏数据
                Game:setdata(jdata, self.request.params.m)

                -- 回调数据
                if onSuccess then
                    onSuccess(Http.Response.new(xhr.status, jdata), self.request)
                end
            else
                if qy.hint then

                    if jdata.error_code == 1802 then
                        --钻石不足
                        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.DIAMOND_NOT_ENOUGH)
                    elseif jdata.error_code == 1827 then
                        -- 充值未到帐不显示错误
                    elseif jdata.error_code == 905 and qy.tank.utils.SDK:channel() == "huawei" then
                        local client_version = cc.UserDefault:getInstance():getStringForKey("version", "1.0")
                        if client_version == "3.0.5" then
                            local dialog = qy.tank.view.BaseAlert2.new()
                            dialog:show(true)
                        end
                    elseif jdata.error_code == 9528 and qy.product == "sina" then
                        --新浪 IOS 除了 1.01 版本，其他的都可以跳到AppStore 下载
                        local client_ver = cc.UserDefault:getInstance():getStringForKey("version", "1.0")
                        local platform = device.platform
                        if client_ver ~= "1.01" and platform == "ios" then
                            --ios版本 1.01 没有改OC层
                            qy.tank.utils.SDK:jumpByUrl("appstore_download")
                        else
                            qy.hint:show(jdata.error_msg)
                        end
                    else
                        qy.hint:show(jdata.error_msg)
                    end
                else
                    qy.Event.dispatch("ERROR_MESSAGE", jdata.error_msg)
                end

                if jdata.error_code == 907 then -- 长时间未操作
                    -- self.model:clearData()
                    qy.tank.manager.ScenesManager:showLoginScene()
                end

                if onError then
                    onError(jdata)
                end

                if qy.DEBUG then
                    print("error code: " .. jdata.error_code)
                end
            end
        elseif xhr.status >= 500 then
            if qy.hint then
                qy.hint:show(qy.TextUtil:substitute(70019) .. xhr.status.. qy.TextUtil:substitute(70020))
            end

            if onError then
                onError()
            end
        else
            if qy.hint then
                qy.hint:show(qy.TextUtil:substitute(70021) .. xhr.status)
            end

            if ioError then
                ioError()
            end
        end

        xhr:unregisterScriptHandler()
    end

    local sessionId = qy.tank.model.UserInfoModel:getSessionId()
    if sessionId then
        xhr:setRequestHeader("PHPSESSID", sessionId)
    end

    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open(self.request.method, url)
    xhr:registerScriptHandler(onReadyStateChange)

    xhr:send(self.request:getParamsStr())
end

function Http.Request:ctor(params, method)
    self.params = params
    if self.params.cid == nil then
        self.params.cid = qy.LoginConfig.cid
    end
    if self.params.sign == nil then
        self.params.sign = qy.LoginConfig.sign
    end

    self.method = method or Http.POST
    local client_version = cc.UserDefault:getInstance():getStringForKey("version", "1.0")
    if client_version == "3.0.5" then 
        local extra = ""
        local session_token 
        local loginModel =  qy.tank.model.LoginModel
        local playerInfoEntity = loginModel:getPlayerInfoEntity()
        if qy.tank.utils.SDK:channel() == "huawei" and playerInfoEntity ~=null then
            session_token = qy.json.decode(playerInfoEntity.session_token)
            local extratable = qy.TextUtil:StringSplit(session_token["gameAuthSign"],"\n",false,false)
            for i=1,table.nums(extratable) do
               extra = extra..extratable[i]
            end
            session_token["gameAuthSign"] = extra
            if self.params.p == nil then
                self.params.p = {}
            end
            self.params.p["extra"] =  session_token
        end
    end
end

function Http.Request:getParamsStr()
    return self.method == Http.POST and qy.json.encode(self.params) or nil
end

-- data: 返回数据
function Http.Response:ctor(code, data)
    self.code = code
    self.data = data
end

-- 默认设置url
Http.seturl()

return Http
