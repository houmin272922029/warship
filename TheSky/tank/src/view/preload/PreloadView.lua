--[[
	登录view
	Author: Aaron Wei
	Date: 2015-10-16 21:10:21
]]

local PreloadView = qy.class("PreloadView", qy.tank.view.BaseView)

function PreloadView:ctor()
    PreloadView.super.ctor(self)
end

function PreloadView:onEnter()
	local winSize = cc.Director:getInstance():getWinSize()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/login/login.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/operatingActivities/icon/activityIcon.plist")

    self.loadingBg = ccui.ImageView:create()
    self.loadingBg:loadTexture("Resources/login/login_24.png", 1)
    self.loadingBg:setScale9Enabled(true)
    self.loadingBg:setCapInsets(cc.rect(20, 20, 20, 20))
    self.loadingBg:setContentSize(450, 108)
    self.loadingBg:setPosition(winSize.width / 2, 319)
    self:addChild(self.loadingBg)

    self.loadingTxt = ccui.Text:create()
    self.loadingTxt:setAnchorPoint(0.5,0.5)
    self.loadingTxt:setFontName("Resources/font/ttf/black_body_2.TTF")
    self.loadingTxt:setFontSize(30)

    --新浪 AppStore 版本 有单独的提示语,不用归到表里
    if qy.product == "sina" then
        self.loadingTxt:setString("部队集结中,不消耗流量")
    else
        self.loadingTxt:setString(qy.TextUtil:substitute(26001))
    end
    self.loadingTxt:setPosition(220,54)
    self.loadingTxt:enableOutline(cc.c4b(0,0,0,255),1)
    self.loadingBg:addChild(self.loadingTxt)

    self.loadNode = cc.Node:create()
    self:addChild(self.loadNode)
    self.loadNode:setPosition(winSize.width/2, 360)

    self.LoadingBarBg1 = cc.Sprite:createWithSpriteFrameName("Resources/login/login_27.png")
    self.LoadingBarBg1:setPosition(0, -172)
    self.loadNode:addChild(self.LoadingBarBg1)

    self.LoadingBarBg = cc.Sprite:createWithSpriteFrameName("Resources/login/login_26.png")
    self.LoadingBarBg:setPosition(0, -172)
    self.loadNode:addChild(self.LoadingBarBg)

    self.LoadingBar = ccui.LoadingBar:create()
    self.LoadingBar:loadTexture("Resources/login/login_28.png",1)
    self.LoadingBar:setPosition(0, -170)
    self.LoadingBar:setPercent(0.0)
    self.loadNode:addChild(self.LoadingBar)

    self.LoadingBarBgWidth = self.LoadingBar:getContentSize().width

    self.loadingTips = cc.Sprite:createWithSpriteFrameName("Resources/login/login_34.png")
    self.loadingTips:setPosition(0, 20)
    self.loadingTips:setVisible(false)
    self.LoadingBar:addChild(self.loadingTips)

    self.perTxt = ccui.Text:create()
    self.perTxt:setFontName("Resources/font/ttf/black_body_2.TTF")
    self.perTxt:setFontSize(24)
    self.perTxt:setString("0.00%")
    self.perTxt:setPosition(380,20)
    self.perTxt:enableOutline(cc.c4b(0,0,0,255),1)
    self.LoadingBar:addChild(self.perTxt)
end

function PreloadView:onEnterFinish()
    local timer = qy.tank.utils.Timer.new(0.5,1,function() 

        local total,count = 29,0
        -- local total,count = 40,0
        qy.tank.command.PreloadCommand:start(function()
            count = count + 1
        	local percent = count/total*100
            print("++++++++++++++++++++++++++++++ preloading",percent,count,total)
            self.perTxt:setString(qy.TextUtil:substitute(26002) .. string.format(" %s / %s", count,total))
            self.LoadingBar:setPercent(percent)
            self.loadingTips:setVisible(true)
            self.loadingTips:setPosition(math.floor(percent / 100.0 * self.LoadingBarBgWidth) - 15, 20)
            if count >= total then
                --新浪 AppStore 版本 有单独的提示语,不用归到表里
                if qy.product == "sina" then
                    self.loadingTxt:setString("部队集结完成，即将进入游戏")
                else
                    self.loadingTxt:setString(qy.TextUtil:substitute(26003))
                end
                self.LoadingBar:setPercent(100)
                self.loadingTips:setVisible(false)
                self.timer = qy.tank.utils.Timer.new(0.5,1,function()
                    qy.Event.dispatch(qy.Event.PRELOAD_RES)
                end)
                self.timer:start()
            end
        end)
    end)
    timer:start()
end

return PreloadView
