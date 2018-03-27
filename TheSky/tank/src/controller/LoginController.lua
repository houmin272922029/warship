local LoginController = qy.class("LoginController", qy.tank.controller.BaseController)

function LoginController:ctor()
    LoginController.super.ctor(self)

    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    local function showLogionView()
        qy.tank.model.LoginModel:init()
        self.loginView = qy.tank.view.login.LoginView.new({
            ["dismiss"] = function()
                self.viewStack:pop()
                self.viewStack:removeFrom(self)
                self:finish()
            end,
        })
        self.viewStack:push(self.loginView)
    end

    if qy.product == "local" or qy.product == "develop" then
        -- 一次启动，仅出现一次
        
        if qy.tank.model.UserInfoModel:isSetDevelopBranch() then
            showLogionView()
            return
        end

        self.selectView = qy.tank.view.debug.SelectBranchView.new({
            ["showLogionView"] = function()
                self.viewStack:pop()
                showLogionView()
            end,
        })
        self.viewStack:push(self.selectView)
    else
        showLogionView()
    end
end

return LoginController
