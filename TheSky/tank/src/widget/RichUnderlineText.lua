--[[--
-- 富文本带下划线的 element
-- Author:mingming
--Date: 2015-12-25

--用法：
	
--]]

local RichUnderlineText = qy.class("RichUnderlineText")

function RichUnderlineText:ctor(params)
    self.button =  self:makeButton(params.text, function()
        params.callback()
    end,params.color,params.type)
end

function RichUnderlineText:getRichElement()
	return self.button
end

function RichUnderlineText:makeButton(text, callback, color, type)
    local textButton = ccui.Button:create()
    textButton:ignoreContentAdaptWithSize(true)
    textButton:setTouchEnabled(true)
    textButton:setSwallowTouches(false)
    textButton:setTitleText(text)
    textButton:setTitleFontName(qy.res.FONT_NAME)
    textButton:setTitleFontSize(22)
    textButton:setTitleColor(color or cc.c3b(0, 255, 77))
    textButton:getTitleRenderer():enableOutline(cc.c4b(0,0,0,255),1)
    textButton:setZoomScale(0)
    textButton:getTitleRenderer():setAnchorPoint(0.5, 0.4)
    textButton:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
            if self._touchMoved then
                sender:setBrightStyle(ccui.BrightStyle.normal)
            end
        else
            if not self._touchMoved and callback then
                callback()
            end
        end
    end)
    local size = textButton:getContentSize()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/img/common_img.plist")
    local idx = type or 1
    local line = ccui.Scale9Sprite:createWithSpriteFrameName("Resources/common/img/underline" .. idx .. ".png")
    line:setAnchorPoint(0.5, 0)
    line:setPosition(size.width / 2, -2)
    line:setCapInsets(cc.rect(2, 0, 2, 0))
    line:setContentSize(size.width - 5, 16)
    line:setColor(color or cc.c3b(216, 197, 157))
    textButton:addChild(line, -1)
    return ccui.RichElementCustomNode:create(1, cc.c3b(255, 255, 255), 255, textButton)
end

return RichUnderlineText
