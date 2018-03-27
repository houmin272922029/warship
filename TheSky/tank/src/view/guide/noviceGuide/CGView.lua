--[[
    CG片头
    Author: H.X.Sun 
    Date：2015-11-06
]]

local CGView = class("CGView", qy.tank.view.BaseDialog)

local videoFullPath = cc.FileUtils:getInstance():fullPathForFilename("res/video/cg_tank.mp4")

function CGView:ctor(onCompleted)
    CGView.super.ctor(self)
    self.onCompleted = onCompleted
    qy.QYPlaySound.stopMusic()

    local ColorLayer = cc.LayerColor:create(cc.c4b(0,0,0,255))
    self:addChild(ColorLayer)

    self.sceneTransition = qy.tank.widget.SceneTransition.new()
    self.sceneTransition:setVisible(false)
    self:addChild(self.sceneTransition, 10)

    self.videoPlayer = ccexp.VideoPlayer:create()
    self.videoPlayer:setPosition(qy.centrePoint)
    self.videoPlayer:setAnchorPoint(0.5,0.5)
    self.videoPlayer:setContentSize(qy.winSize)
    self.videoPlayer:setFileName(videoFullPath)
    self.videoPlayer:setKeepAspectRatioEnabled(true)
    -- self.videoPlayer:setFullScreenEnabled(true)
    -- self.videoPlayer:play()
    self.videoPlayer:setVisible(true)

    self.videoPlayer:addEventListener(function(sener, eventType)
        if eventType == 3 then
            self:__onCompletedCG()
        end
    end)

    self:addChild(self.videoPlayer)
    self.videoPlayer:play()

    self.skip = ccui.ImageView:create()
    self.skip:loadTexture("res/video/"..qy.language.."_skip_txt.png")
    self.skip:setPosition(qy.winSize.width / 2, 130)
    self:addChild(self.skip)
    self.skip:setVisible(false)
    self.aminIsPlaying = false
end

function CGView:__txtAmin()
    self.skip:setVisible(true)
    self.aminIsPlaying = true
    local move1 = cc.MoveBy:create(0.05,cc.p(0,-100))
    local delay = cc.DelayTime:create(1.5)
    local move2 = cc.MoveBy:create(0.7,cc.p(0,100))
    self.skip:runAction(cc.Sequence:create(move1,delay,move2,cc.CallFunc:create(function ()
        self.aminIsPlaying = false
        self.skip:setVisible(false)
    end)))
end

function CGView:__onCompletedCG()
    self.sceneTransition:setVisible(true)
    self.videoPlayer:stop()
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
        self.videoPlayer:getParent():removeChild(self.videoPlayer)
        print("PLATFORM_OS_ANDROID self.removeChild:stop()===================>>>>>>>")
    end
    self.sceneTransition:close(function ()
        self.onCompleted()
    end)
end

function CGView:onEnter()
    local listener = cc.EventListenerTouchOneByOne:create() 
    local function onTouchBegan(touch, event)
        return true
    end
    local limit_time = 0

    local function onTouchEnded(touch, event)
        print("点击剧情屏幕")
        if self.aminIsPlaying then
            --时间限制
            if os.time() - limit_time > 0.5 then
                self:__onCompletedCG()
            end
        else
            self:__txtAmin()
            limit_time = os.time()
        end
        return true
    end
    
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN) 
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
    self._touchListener = listener
end

function CGView:onExit()
    self:getEventDispatcher():removeEventListener(self._touchListener)
    self._touchListener = nil
end

return CGView