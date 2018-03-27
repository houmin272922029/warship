local CleanupDialog = qy.class("CleanupDialog", qy.tank.view.BaseDialog, "view/login/CleanupDialog")

local ASSETS_PATH = device.writablePath .. "assets/"
local fileUtils = cc.FileUtils:getInstance()
local userDefault = cc.UserDefault:getInstance()
local client_version = userDefault:getStringForKey("version", "1.0")

function CleanupDialog:ctor(next)
    CleanupDialog.super.ctor(self)

    self:OnClick("Button_no", function()
        self:dismiss()
    end)

    self:OnClick("Button_ok", function()
        self:dismiss()

        -- 删除热更新目录
        fileUtils:removeDirectory(ASSETS_PATH .. client_version .. "/")
        -- 删除模块目录
        fileUtils:removeDirectory(ASSETS_PATH .. "modules/")
        fileUtils:removeDirectory(ASSETS_PATH .. "manifests/")
        cc.Director:getInstance():endToLua()
        os.exit()
    end)
end

return CleanupDialog
