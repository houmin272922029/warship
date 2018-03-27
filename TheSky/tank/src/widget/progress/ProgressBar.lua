--[[
	有缓动效果的进度条
	-- Author: Aaron Wei
	-- Date: 2015-02-07 18:03:59
	--
]]

local ProgressBar = class("ProgressBar",function()
	return cc.Node:create() 
end)

function ProgressBar:ctor()
	self.frame = nil
	self.bar = nil
	-- 0~1之间的小数 
	self.percent = 0
	self.offset = 0
	-- 进度条从头到尾走完所需秒数，时间与步进量成正比，匀速
	self.speed = 10
	-- 进度条每次步进量所需秒数，时间恒定，步进量不定，变速
	self.duration = 10
end

function ProgressBar:init(bar_img,frame_img)
	-- 背景  
    self.frame = cc.Sprite:create(frame_img)  
    self:addChild(self.frame);  
    self.frame:setPosition(0, 0); 
      
    -- 进度条 
    self.bar = cc.ProgressTimer:create(cc.Sprite:create(bar_img))    
    self.bar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
	-- Setup for a self.bar starting from the left since the midpoint is 0 for the x
    self.bar:setMidpoint(cc.p(0,0))
    -- Setup for a horizontal self.bar since the self.bar change rate is 0 for y meaning no vertical change
    self.bar:setBarChangeRate(cc.p(1, 0))
    self.bar:setPosition(0,0)
    self:addChild(self.bar)
end

function ProgressBar:setMidpoint(x,y)
    if self.bar and tolua.cast(self.bar,"cc.ProgressTimer") then
        self.bar:setMidpoint(cc.p(x,y))
    end
end

function ProgressBar:setBarChangeRate(x,y)
    if self.bar and tolua.cast(self.bar,"cc.ProgressTimer") then
        self.bar:setBarChangeRate(cc.p(x,y))
    end
end

function ProgressBar:setFramePosition(x,y)
    if self.frame and tolua.cast(self.frame,"cc.Node") then
        self.frame:setPosition(x,y)
    end
end

function ProgressBar:setBarPosition(x,y)
    if self.bar and tolua.cast(self.bar,"cc.ProgressTimer") then
        self.bar:setPosition(x,y)
    end
end

function ProgressBar:setPercent(p)
    local before = self.percent
    self.percent = math.min(100,math.max(0,p))
    self.offset = self.percent - before
    self.bar:setPercentage(p)
end

function ProgressBar:setPercentWithTween(p)
    local before = self.percent
    self.bar:setPercentage(before)
    self.percent = math.min(100,math.max(0,p))
    self.offset = self.percent - before
    
    local to = cc.ProgressTo:create(self.duration,p)
    self.bar:runAction(cc.RepeatForever:create(to))
end

function ProgressBar:getPercent()
    return self.percent
end

function ProgressBar:setSpeed(s)
    self.speed = s
end

function ProgressBar:setDuration(d)
    self.duration = d
end

function ProgressBar:getOffset()
    return self.offset
end

return ProgressBar