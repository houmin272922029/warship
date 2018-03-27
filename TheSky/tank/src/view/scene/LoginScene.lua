local LoginScene = qy.class("MainScene", qy.tank.view.scene.BaseScene)

local userDefault = cc.UserDefault:getInstance()
local client_version = userDefault:getStringForKey("version", "1.0")
local package_code = userDefault:getStringForKey("package_code", "0")

local CleanupDialog = qy.tank.view.login.CleanupDialog

-- jenkins build number
local build_version = (function()
    local ret = 1
    local ok, build = pcall(function()
        return require("build")
    end)
    if ok then
        ret = build.number
    elseif qy.DEBUG then
        print("Warning: build.lua不存在!!")
    end
    return ret
end)()

local LoginController = qy.tank.controller.LoginController
local ModuleHelper = qy.tank.module.Helper

function LoginScene:ctor()
    LoginScene.super.ctor(self)

    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/login/login.plist")

    local winSize = cc.Director:getInstance():getWinSize()
    -- login封面
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RG_B565)
    local bg = cc.Sprite:create("Resources/login/cover_plan.jpg")
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_DEFAULT)
    bg:setPosition(winSize.width / 2, winSize.height / 2)
    bg:addTo(self)

    local logo = cc.Sprite:create("Resources/login/cover_logo.png")
    logo:setPosition(winSize.width / 2, 564)
    logo:addTo(self)

    local title = ccui.Text:create()
    title:setFontName(qy.res.FONT_NAME_2)
    title:setFontSize(22)
    title:setString(string.format("%s.%s.%s", client_version, package_code, build_version))
    title:setAnchorPoint(1, 0)
    title:setPosition(display.width - 10, 10)
    title:addTo(self)

    local clean = ccui.Button:create()
    clean:loadTextureNormal("Resources/login/clean.png", 1)
    clean:setAnchorPoint(0, 0)
    clean:setPosition(25, 20)
    clean:addTo(self)
    clean:addClickEventListener(function()
        CleanupDialog.new():show()
    end)

    local function preload(next)
        self.listener = qy.Event.add(qy.Event.PRELOAD_RES, next)
        self:push(qy.tank.controller.PreloadController.new())
    end

    co(function()
        yield(preload) -- 预加载完成后才会执行下面的代码
    end, function()
        self:replace(qy.tank.controller.LoginController.new())

        -- qy.tank.module.Helper:register("gold_bunker")
        -- qy.tank.module.Helper:start("gold_bunker")
    end)
end

function LoginScene:onCleanup()
    if self.listener then
        qy.Event.remove(self.listener)
    end
end

return LoginScene
