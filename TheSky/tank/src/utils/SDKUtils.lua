--[[
    说明: sdk
]]

local sdk = {}

local platform = device.platform

if platform == "ios" or platform == "mac" then
    sdk.luaoc = require "cocos.cocos2d.luaoc"
elseif platform == "android" then
    sdk.luaj = require "cocos.cocos2d.luaj"
    sdk.className = "com.qiyouhudong.sdk.Api"
end

local LoginModel =  qy.tank.model.LoginModel

local userDefault = cc.UserDefault:getInstance()
local client_version = userDefault:getStringForKey("version", "1.0")

function sdk:channelCode()
    if not self._channel_code then
        local ok, ret
        if platform == "android" then
            if client_version ~= "2.1" then
                ok, ret = self.luaj.callStaticMethod(self.className, "ChannelCode", nil, "()I")
            else
                ok = false
            end
        else
            ok, ret = self.luaoc.callStaticMethod("SDK", "ChannelCode")
        end
        if ok then
            self._channel_code = ret
        else
            self._channel_code = platform == "android" and 2 or 1
        end
    end
    return self._channel_code
end

function sdk:channel()
    if not self._channel then
        local ok, ret
        if platform == "android" then
            if client_version ~= "2.1" then
                ok, ret = self.luaj.callStaticMethod(self.className, "Channel", nil, "()Ljava/lang/String;")
            else
                ok = false
            end
        else
            ok, ret = self.luaoc.callStaticMethod("SDK", "Channel")
        end
        print("+++++++++++++++ sdk:channel",ok,ret)
        if ok then
            self._channel = ret
        else
            self._channel = "qiyou"
        end
    end
    return self._channel
end

-- 显示第三方登录界面
sdk.loginData = {}

function sdk:showLoginView(mplatform, callback,isBind)
    local args = {callback = function(status, uid, username, token)
        if status then
            print("SDK登录成功", uid, username, token)
            if not isBind or isBind == nil then
                LoginModel:saveRegisterData({
                    platform_user_id = uid,
                    session_token = token,
                    nickname = username
                })
                LoginModel:updateVisitorStatus(2)
            end
            self.loginData = {uid=uid,username=username,token=token}
            callback()
        end
    end}

    if platform == "android" then
        if self:channel() == "msdk" then
            self.luaj.callStaticMethod(self.className, "Login", {mplatform, function(jsonStr)
                local json = qy.json.decode(jsonStr)
                args.callback(json.status, json.uid, json.username, json.token)
            end}, "(II)V")
        elseif self:channel() == "google" or self:channel() == "overseauc" then
            self.luaj.callStaticMethod(self.className, "Login", {isBind and true or false, function(jsonStr)
                local json = qy.json.decode(jsonStr)
                args.callback(json.status, json.uid, json.username, json.token)
            end}, "(ZI)V")
        else
            self.luaj.callStaticMethod(self.className, "Login", {function(jsonStr)
                local json = qy.json.decode(jsonStr)
                args.callback(json.status, json.uid, json.username, json.token)
            end}, "(I)V")
        end
    else
        self.luaoc.callStaticMethod("SDK", "Login", args)
        self.luaoc.callStaticMethod("SDK", "SetIsHideBindingTip",{isHide=qy.isAudit})
    end
end

--[[
    args = {
        amount = 1,
        extra = "",
        callback = func
    }
]]

function sdk:showPayView(args, callback)
    print("sdk showPayView fuck! fuck! fuck!",platform,self:channel())
    args.callback = function(status,jdata)
        if status then
            callback(jdata)
        else
            print("取消支付")
        end
    end

    if platform == "android" then
        if self:channel() == "overseauc" then
            local args2 = {args.pid,args.price,args.token,args.extra, function(jsonStr)
            -- local args2 = {args.pid,args.price, function(jsonStr)
                local json = qy.json.decode(jsonStr)
                args.callback(json.status,jsonStr)
            end}
            self.luaj.callStaticMethod(self.className, "Pay", args2, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V")
        else
            local args2 = {tostring(args.amount), args.extra, function(jsonStr)
                local json = qy.json.decode(jsonStr)
                args.callback(json.status,jsonStr)
            end}
            self.luaj.callStaticMethod(self.className, "Pay", args2, "(Ljava/lang/String;Ljava/lang/String;I)V")
        end
    else
        self.luaoc.callStaticMethod("SDK", "Pay", args)
    end
end

function sdk:shareToFacebook(args, callback)
    print("sdk shareToFacebook",self)
    args.callback = function(status)
        if status then
            callback()
        else
            print("取消Facebook分享")
        end
    end
    local args2 = {function(jsonStr)
        local json = qy.json.decode(jsonStr)
        args.callback(json.status)
    end}
    self.luaj.callStaticMethod(self.className, "shareToFacebook", args2, "(I)V")
end

function sdk:hideFacebook()
    print("sdk hideFacebook")
    self.luaj.callStaticMethod(self.className, "hideFacebookLoginView")
end

function sdk:logoutFacebook()
    print("sdk logoutFacebook")
    self.luaj.callStaticMethod(self.className, "logoutFacebook")
end

-- 绑定Facebook账号
function sdk:bindAccount(onSuccess,onError,ioError)
    qy.tank.utils.SDK:showLoginView(2, function()
        qy.tank.service.LoginService:bindFacebookAccount(function()
            LoginModel:saveRegisterData({
                platform_user_id = self.loginData.uid,
                session_token = self.loginData.token,
                nickname = self.loginData.username
            })
            LoginModel:updateVisitorStatus(2)
            onSuccess()
        end,onError,ioError)
    end,true)
end

function sdk:openURL(url)
    local ok,ret
    if platform == "android" then
        print("sdk:android openURL="..url)
        local args = {url}
        ok,ret = self.luaj.callStaticMethod(self.className, "openURL", args, "(Ljava/lang/String;)Z")
    else
        print("sdk:ios openURL="..url)
        ok,ret = self.luaoc.callStaticMethod("SDK", "openURL", url)
    end

    -- return ret
end

--[[
    用法：qy.tank.utils.SDK:jumpByUrl("appstore_score")
]]--
function sdk:jumpByUrl(action)
    print("sdk jumpByUrl")
    if platform == "android" then
        -- android 目前没有处理
    elseif qy.product == "sina" then
        -- 新浪 IOS
        local params = {
            ["url"] = "",--跳转链接
            ["type"] = 1,--1:表示有二次提示，2:无提示框，直接跳转［title、info、btnNum可以省略］
            ["title"] = "提示", -- 弹窗标题
            ["messages"] = "",-- 弹窗现实内容
            ["btnNum"] = 2,--按钮输了，默认2个 最多仅支持两个按钮 ［1个按钮：确定；2个按钮：取消，确定］
        }

        if action == "appstore_download" then
            -- AppStore 下载新版本
            params.url = "itms-apps://itunes.apple.com/app/id1106452103"
            params.messages = "恭喜发现新版本！快去AppStore获取吧！"
            params.btnNum = 1
        elseif action == "appstore_score" then
            -- AppStore 评分
            params.url = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1106452103&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
            params.messages = "指挥官！前往AppStore给予游戏五星好评可获得200钻石"
        end
        if params.url ~= "" then
            self.luaoc.callStaticMethod("SDK", "jumpByUrl",params)
        end
    end
end

return sdk
