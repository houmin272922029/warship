--[[
    Description:主文件
    Author: Aaron Wei
    Date: 2015-01-07 18:00:16
]]
local fileUtils = cc.FileUtils:getInstance()
fileUtils:setPopupNotify(false)
fileUtils:addSearchPath("src")
fileUtils:addSearchPath("res")

-- 屏幕适配
CC_DESIGN_RESOLUTION = {
    width = 1080,
    height = 720,
    autoscale = "FIXED_HEIGHT",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "EXACT_FIT"}
        end
    end
}

require "config"
require "cocos.init"
require "utils.log"

local ClientDotService = require("service.ClientDotService")

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    local message = debug.traceback(msg, 3)

    if qy.DEBUG and qy.debuger ~= nil then
        qy.debuger:showBugMesg("lua error:\n\t" .. message)
    end

    -- 上报异常日志
    require("utils.Analytics"):onCrash(message)

    print("----------------------------------------")
    print("错误信息\nlua error:\n\t" .. message)
    print("----------------------------------------")
    return msg
end

local function main()
    collectgarbage("count")
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    --turn on display FPS
    if qy.DEBUG then
        cc.Director:getInstance():setDisplayStats(true)
    end

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_DEFAULT)

    cc.Device:setKeepScreenOn(true)

    -- 进入更新场景
    -- local gameScene = require("assetsManager.GameScene").new()
    -- if cc.Director:getInstance():getRunningScene() then
    --     cc.Director:getInstance():replaceScene(gameScene)
    -- else
    --     cc.Director:getInstance():runWithScene(gameScene)
    -- end
    fileUtils:addSearchPath(device.writablePath .. "assets/modules")
    
    require("App").new():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
