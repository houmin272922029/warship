--[[
	全屏界面通用header样式1
	Author: Aaron Wei
	Date: 2015-10-27 16:54:30
]]

local ViewStyle1 = qy.class("ViewStyle1", qy.tank.view.BaseView, "view/style/ViewStyle1")

function ViewStyle1:ctor(params)
    ViewStyle1.super.ctor(self, params)
    self:InjectView("header")
    self:InjectView("wire")
    self:InjectView("title")
    if params.titleUrl then
    	self.title:setVisible(true)
    	if cc.SpriteFrameCache:getInstance():getSpriteFrame(params.titleUrl) then
            self.title:setSpriteFrame(params.titleUrl)
        else
            self.title:setTexture(params.titleUrl)
        end
    else
    	self.title:setVisible(false)
    end
    
    self:InjectView("exitBtn")
    self:OnClick("exitBtn", function(sender)
        if params and params.onExit then
            params.onExit()
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE,["isScale"] = false})

    self:InjectView("homeBtn")
    if params.showHome then
        self.homeBtn:setVisible(true)
        self:OnClick("homeBtn", function(sender)
            if params and params.onHome then
                params.onHome()
            end
            qy.App.runningScene:disissAllView()
        end,{["audioType"] = qy.SoundType.BTN_CLOSE,["isScale"] = false})
        self.homeBtn:setPosition(0,qy.winSize.height)
    else
        self.homeBtn:setVisible(false)
    end
end

function ViewStyle1:onEnter()
    self.header:setPosition(qy.winSize.width/2,qy.winSize.height)
	self.exitBtn:setPosition(qy.winSize.width,qy.winSize.height)
	self.wire:setPosition(0,qy.winSize.height+10)

end

function ViewStyle1:onEnterFinish()
end

function ViewStyle1:onExitStart()
end

function ViewStyle1:onExit()
end

function ViewStyle1:onCleanup()
end


return ViewStyle1