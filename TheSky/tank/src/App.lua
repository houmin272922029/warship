--[[
    Description:全局启动类
    Author: Aaron Wei i
    Date: 2015-01-07 18:00:16
]]

require("utils.functions")
require("utils.MemoryScan")
require("utils.co") -- import co, yield

local Dnspod = require("utils.Dnspod")
local Analytics = require("utils.Analytics")


local query_domains = {
    ["tank.9173.com"] = true,
    ["ios.tank.9173.com"] = true,
}

function qy.class(classname, super, theme)
    local cls = class(classname, super)
    if type(theme) == "string" then
        cls.__create = function()
            return cls.super.__create(theme)
        end
    end
    return cls
end

local App = class("App")

function App:ctor()
    self:registerClass()

    qy.App = self
    qy.Event = qy.tank.utils.EventUtil
    qy.Timer = qy.tank.utils.TimerUtil
    qy.Runtime = qy.tank.utils.Runtime
    qy.Utils = require("utils.Utils")
    qy.Http = require("utils.Http")
    qy.json = require("utils.dkjson")
    qy.M = require("utils.QYPlaySound")
    qy.winSize = display.size
    qy.centrePoint = display.center
    qy.res = qy.tank.config.Res
    qy.Config = qy.tank.config.Config
    qy.LoginConfig = qy.tank.config.LoginConfig
    qy.ResConfig = qy.tank.config.ResConfig
    qy.BattleConfig = qy.tank.config.BattleConfig
    qy.AnimationUtil = qy.tank.utils.AnimationUtil
    qy.SoundType = qy.tank.view.type.SoundType
    qy.QYPlaySound = qy.tank.utils.QYPlaySound
    qy.RedDotType = qy.tank.view.type.RedDotType
    qy.RedDotCommand = qy.tank.command.RedDotCommand
    qy.AwardList = qy.tank.view.common.AwardList
    qy.Analytics = qy.tank.utils.Analytics
    qy.ClientDotService = require("service.ClientDotService")
    qy.ClientDotService:onEvent("start_game")
    qy.GuideManager = qy.tank.manager.GuideManager
    -- qy.GuideStepT = qy.tank.view.type.GuideStepType
    qy.GuideCommand = qy.tank.command.GuideCommand
    qy.GuideModel = qy.tank.model.GuideModel
    qy.isNoviceGuide = false
    qy.isTriggerGuide = false
    qy.TextUtil = qy.tank.utils.TextUtil
    qy.isAudit = true-- 审核屏蔽
    qy.InternationalUtil = qy.tank.utils.InternationalUtil -- 多语言转换工具类
    qy.tank.utils.SDK:logout()--把登出回调传过去

    -- 加入cocos2d_version来判断当前运行的引擎
    -- 用于兼容旧引擎的代码
    -- 假如有一段代码，只有在新引擎才有效，那可以用if判断
    --[[
        if qy.cocos2d_version == qi.COCOS2D_3_7_1 then
            print("只有在3.7.1引擎下运行")
        else
            print("在其它引擎下运行")
        end
    ]]
    qy.COCOS2D_3_7_1 = "cocos2d-x-3.7.1"
    qy.COCOS2D_3_9 = "cocos2d-x-3.9"
    qy.cocos2d_version = cc.UserDefault:getInstance():getStringForKey("cocos2d_version", qy.COCOS2D_3_7_1)
end

-- 动态注册类,类java语法调用,包路径首字母小写,类名首字母大写
-- local login = qy.tank.scene.LoginScene.new()
function App:registerClass()
    local o = {}
    local recursion; function recursion(_o)
        setmetatable(_o, {
            __index = function(t, k)
                local path = rawget(t,"__path")
                local t1 = nil
                if string.byte(k,1) == string.byte(string.upper(k),1) then
                    local className
                     if path then
                        className = path.."."..k
                    else
                        className = k
                    end
                    -- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>className",className)
                    t1 = require(className)
                    rawset(t, k, t1)
                else
                    t1 = {}
                    if path then
                        t1.__path = path ..".".. k
                    else
                        t1.__path = k
                    end
                    -- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>path",t1.__path)
                    rawset(t, k, t1)
                    recursion(_o[k])
                end
                return t1
            end,

            __newindex = function(_, k, v)
                -- only read
            end,
        })
    end

    recursion(o)
    qy.tank = o
end

-- 监听键盘事件
function App:registerKeyboardListener()
    local keyTime = 0
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(function(keyCode, event)
        if keyCode == cc.KeyCode.KEY_BACK then
            if (os.time() - keyTime) > 1.5 then
                keyTime = os.time()
                if tolua.cast(qy.hint,"cc.Node") then
                    local sdk = qy.tank.utils.SDK
                    sdk:exitgame()
    
                end
            else
                Analytics:doAction("onExitGame")
            end
        end
    end, cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(listener, 1)

    -- 监听游戏进出后台
    if not self.listener1 then
        self.listener1 = cc.EventListenerCustom:create("event_come_to_background1",function()
            self.time = os.time()
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> App event_come_to_background1",self.time)
        end)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self.listener1,1)
    end

    if not self.listener2 then
        self.listener2 = cc.EventListenerCustom:create("event_come_to_foreground1",function()
            if self.time then
                local t = os.time() - self.time
                print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> App event_come_to_foreground1",t)
                -- if t >= 3 then
                --     qy.tank.manager.ScenesManager:showLoginScene()
                -- end

                qy.Event.dispatch(qy.Event.GROUP_BATTLES2) --fq 2016年08月29日14:12:55 多人副本
            end
        end)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self.listener2,1)
    end
end

function App:start()
    self:registerKeyboardListener()

    qy.Runtime.start()
    qy.tank.service.LoginService:getAnnounce()
    qy.tank.manager.ScenesManager:start()
end

function App:queryip()
    qy.Event.dispatch("ERROR_MESSAGE", qy.TextUtil:substitute(70046))
    local domain = qy.SERVER_DOMAIN
    if query_domains[domain] then
        Dnspod:query(domain, function(ok, ip)
            if ok then
                qy.SERVER_DOMAIN = ip
            end
            self:start()
        end)
    else
        self:start()
    end
end

function App:run()
    math.newrandomseed()
    if qy.product == "develop" and false then
        local ServerScene = require("src.scenes.ServerScene")
        display.runScene(ServerScene.new(function()
            self:queryip()
        end))
    else
        self:queryip()
    end
end

return App
