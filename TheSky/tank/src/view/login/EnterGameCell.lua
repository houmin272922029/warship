--[[--
--进入游戏cell
--Author: H.X.Sun
--Date: 2015-07-28
--]]

local EnterGameCell = qy.class("EnterGameCell", qy.tank.view.BaseView, "view/login/EnterGameCell")

local LoginModel = qy.tank.model.LoginModel

function EnterGameCell:ctor(delegate)
    EnterGameCell.super.ctor(self)

    self:InjectView("accountTxt")
    self:InjectView("districtTxt")
    self:InjectView("accountLabel")
    self:InjectView("changeAccountBtn")
    self:InjectView("loginNode")
    self:InjectView("EnterBtn")
    self:InjectView("logout_btn")
    self:InjectView("cell_1")
    self:InjectView("cell_2")
    self:InjectView("QuickStartBtn")
    self:InjectView("loginBtn")
    self:InjectView("districtBtn")

    if qy.isAudit and qy.product == "sina" then
        self.districtBtn:setVisible(false)
    end

    self:updateLogoutBtn()
    if qy.language == "en" then
        if LoginModel:getPlayerInfoEntity().is_visitor == 1 then
            -- 英文游客
            self:OnClick("logout_btn", function()
                -- 退到登录解决
                self:updateCell(1)
            end)
        else
            -- 英文版 退出 fb
            self:OnClick("logout_btn", function()
                -- 退到登录解决
                self:updateCell(1)
                qy.tank.utils.SDK:logoutFacebook()
            end)
        end
        
    end


    --绑定账号/更换账号
    self:OnClick("changeAccountBtn", function()
        if LoginModel:getPlayerInfoEntity().is_visitor == 1 then
            if qy.language == "en" then

            else
                delegate.update(3)
                -- 游客：点击绑定账号
                if qy.tank.utils.SDK:channel() ~= "google" then
                    qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.REGISTER, {["update"] =delegate.update, ["action"] = 2})
                else
                    -- 先登录facebook再绑定账号
                    -- qy.tank.utils.SDK:showLoginView(2, function()
                    --     qy.tank.service.LoginService:bindAccount(function()
                    --         delegate.update(2)
                    --     end)
                    -- end)

                    qy.tank.utils.SDK:bindAccount(function()
                        qy.hint:show("Facebook account bind successful")
                        delegate.update(2)
                    end,function()
                        qy.hint:show("Facebook account bind failed")
                        delegate.update(2)
                    end)
                end
            end
        else
            --普通用户：更换账号
            delegate.updateLoginData()
            delegate.update(6)
        end
    end, {["isScale"] = false})

    --点击换区
    self:OnClick("changeDistrictBtn", function()
        if qy.isAudit and qy.product == "sina" then
            return
        end

        local function open()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.DISTRICT, function ()
                self:updateDistrict()
            end)
        end

        if LoginModel:getLastDistrictEntity() then
            open()
        else
            qy.tank.service.LoginService:getDistrictList(function ()
                open()
            end)
        end
    end, {["isScale"] = false})

    --进入游戏
    self:OnClick("EnterBtn", function()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.ENTER_GAME)
    end, {["isScale"] = false})

    --快速开始
    self:OnClick("QuickStartBtn", function()
        delegate.update(5)
    end, {["isScale"] = false})

    --点击登录
    self:OnClick("loginBtn", function()
        delegate.update(4)
    end, {["isScale"] = false})

    self._delegate = delegate
end

function EnterGameCell:updateLogoutBtn()
    if qy.language == "en" then
        if LoginModel:getPlayerInfoEntity().is_visitor == 1 then
            self.logout_btn:loadTextures("Resources/login/visitor_logout_btn_1.png","Resources/login/visitor_logout_btn_2.png",nil,1)
        else
            self.logout_btn:loadTextures("Resources/login/logout_btn_1.png","Resources/login/logout_btn_2.png",nil,1)
        end
    end
end

function EnterGameCell:updateCell(_type)
    if _type == 1 then
        self.cell_1:setVisible(false)
        self.cell_2:setVisible(false)
        self.loginNode:setVisible(true)
        self.EnterBtn:setVisible(false)
        self:updateDistrict()
    else
        self.cell_1:setVisible(true)
        self.cell_2:setVisible(true)
        self.EnterBtn:setVisible(true)
        self.loginNode:setVisible(false)
        self:updateData()
    end
    self:updateLogoutBtn()
end

function EnterGameCell:updateData()
    local _nickname = LoginModel:getPlayerInfoEntity().nickname
    self.accountTxt:setString(_nickname)
    print("EnterGameCell:updateData",_nickname)
    self:updateDistrict()
    if LoginModel:getPlayerInfoEntity().is_visitor == 1 then
        --游客：点击绑定账号
        self.accountLabel:setString(qy.TextUtil:substitute(18006))
    else
        --普通用户：更换账号
        self.accountLabel:setString(qy.TextUtil:substitute(18007))
    end
end

function EnterGameCell:updateDistrict()
    local _entity = LoginModel:getLastDistrictEntity()
    if _entity then
        self.districtTxt:setString(_entity.s_name .. "-" .. _entity.name)
    else
        self.districtTxt:setString(qy.TextUtil:substitute(18008))
    end
end

-- 根据平台，把快速游戏按钮隐藏，点击登录居中
function EnterGameCell:setPlatform(platform)
    if platform == "msdk" then
        self.QuickStartBtn:removeAllChildren()
        self.loginBtn:removeAllChildren()
        self.QuickStartBtn:setContentSize(cc.size(300, 80))
        self.loginBtn:setContentSize(cc.size(300, 80))

        self.QuickStartBtn:setPositionX(-175)
        self.loginBtn:setPositionX(175)

        local icon = cc.Sprite:create("login_qq.png")
        icon:setPosition(150, 42)
        icon:addTo(self.loginBtn)

        icon = cc.Sprite:create("login_weixin.png")
        icon:setPosition(150, 42)
        icon:addTo(self.QuickStartBtn)
    elseif (platform ~= "qiyou" and platform ~= "google") or qy.product == "sina" then
        self.QuickStartBtn:setVisible(false)
        self.loginBtn:setPositionX(0)
    end
end

return EnterGameCell
