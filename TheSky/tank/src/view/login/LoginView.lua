--[[--
--登录view
--Author: H.X.Sun
--Date: 2015-07-28
--]]

local LoginView = qy.class("LoginView", qy.tank.view.BaseView, "view/login/LoginView")

function LoginView:ctor()
    LoginView.super.ctor(self)

    self:InjectView("des_txt")
    self.des_txt:setLocalZOrder(100)
end

function LoginView:createLoginDialog()
    if self.loginCell == nil then
        self.loginCell = qy.tank.view.login.LoginCell.new({
            ["update"] = function (nType)
                self:updateCell(nType)
            end
            })
        self.loginCell:setPosition(display.cx, display.cy)
        self.loginCell:addTo(self)
    end
end

function LoginView:createEnterGameCell()
    if self.enterGame == nil then
        self.enterGame = qy.tank.view.login.EnterGameCell.new({
            ["update"] = function (nType)
                self:updateCell(nType)
            end,
            ["updateLoginData"] = function()
                self:updateLoginCellData()
            end
            })
        self.enterGame:setPlatform(qy.tank.utils.SDK:channel())
        self.enterGame:setPosition(display.cx, display.cy)
        self.enterGame:addTo(self)
    end
end

function LoginView:updateLoginCellData()
    if self.loginCell then
        self.loginCell:updateData()
    end
end

--[[--
--更新cell
--]]
function LoginView:updateCell(nType)
    if nType == 1 or nType == 2 then
        -- 1:登录入口，显示游客和登录
        -- 2:登录成功，进入游戏和用户信息
        if self.loginCell then
            self.loginCell:hide()
        end
        if not self.enterGame then
            self:createEnterGameCell()
        end
        self.enterGame:setVisible(true)
        self.enterGame:updateCell(nType)
        print("LoginView:updateCell",nType,self.loginCell,self.enterGame)
    elseif nType == 3 then
        --
        if self.loginCell then
            self.loginCell:hide()
        end
        if self.enterGame then
            self.enterGame:setVisible(false)
        end
    elseif nType == 4 then
        -- 输入用户名和密码界面
        if qy.tank.utils.SDK:channel() == "qiyou" then
        -- if qy.tank.utils.SDK:channel() == "qiyou" or qy.tank.utils.SDK:channel() == "google" then
            if self.enterGame then
                self.enterGame:setVisible(false)
            end

            if not self.loginCell then
                 self:createLoginDialog()
            end
            self.loginCell:show()
            self.loginCell:updateData()
        else
            -- SDK登录框
            self:showLoginView(2)
        end
    elseif nType == 5 then
        -- 快速登录，GO界面
        if qy.tank.utils.SDK:channel() == "qiyou" or qy.tank.utils.SDK:channel() == "google" then
            qy.tank.view.login.ReminderDialog.new({
                ["update"] = function (nType)
                    self:updateCell(2)
                end
            }):show(true)
        else -- 微信
            self:showLoginView(1)
        end
    elseif nType == 6 then
        --
        if qy.tank.utils.SDK:channel() == "qiyou" then
            self:updateCell(4)
        else
            self:updateCell(1)
        end
    end
end

--
-- 显示第三方SDK登录UI
--
function LoginView:showLoginView(platform)
    qy.tank.utils.SDK:showLoginView(platform, function()
        qy.tank.service.LoginService:getDistrictList(function()
            self:updateCell(2)
        end)
    end)
end

function LoginView:onEnter()
    qy.QYPlaySound.playMusic(qy.SoundType.M_W_BG_MS)
    --qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.LOGIN_ANNOUNCE)

    -- qiyo渠道时的自动登录处理
    require("utils.Analytics"):onEvent({["name"] = "UPDATE_SUCCESS"})
    local channel = qy.tank.utils.SDK:channel()
    print("LoginView:onEnter channel="..channel)
    if channel == "qiyou" then
        if qy.tank.model.LoginModel:hasVistorAccount() then
            print("奇游游客账号获取服务器列表")
            qy.tank.utils.QYSDK.visitorLogin(2, function ()
                self:updateCell(2)
            end,function ()
                self:updateCell(1)
            end,function ()
                self:updateCell(1)
            end)
        elseif qy.tank.model.LoginModel:getUserAccountNun() > 0 then
            local params = qy.tank.model.LoginModel:getUserAccountData()[1]
            print("奇游非游客账号获取服务器列表：[username]:" .. params.username .. "   [password]:".. params.password)
            qy.tank.utils.QYSDK.registerOrLogin(2, params, function ()
                self:updateCell(2)
            end,function ()
                self:updateCell(4)
            end, function ()
                self:updateCell(4)
            end)
        else
            print("奇游空账号，显示选择登陆入口")
            self:updateCell(1)
        end
    elseif channel == "google" then
        print("LoginView:onEnter",qy.tank.model.LoginModel:hasVistorAccount(),qy.tank.model.LoginModel:getUserAccountNun())
        if qy.tank.model.LoginModel:hasVistorAccount() then
            print("小奥游客账号获取服务器列表")
            qy.tank.utils.QYSDK.visitorLogin(2, function ()
                self:updateCell(2)
            end,function ()
                self:updateCell(1)
            end,function ()
                self:updateCell(1)
            end)
        elseif qy.tank.model.LoginModel:hasSDKAccount() then
            print("小奥SDK账号登陆")
            self:updateCell(1)
            self:showLoginView(0)
        else
            print("小奥空账号，显示选择登陆入口")
            self:updateCell(1)
        end
    else
        self:updateCell(1)
        self:showLoginView(0)
    end
end
function LoginView:onExit()
    -- cc.Director:getInstance():getTextureCache():removeAllTextures() 
end

return LoginView
