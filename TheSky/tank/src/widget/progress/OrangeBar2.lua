--[[
	橙色进度条
	Author: Aaron Wei
	Date: 2015-02-10 11:21:25
]]

local OrangeBar2 = qy.class("OrangeBar2", qy.tank.widget.progress.ProgressBar)

function OrangeBar2:ctor()
    OrangeBar2.super.ctor(self)
end

function OrangeBar2:init()
	-- 背景  
    self.frame = cc.Sprite:createWithSpriteFrameName("Resources/common/img/bar_3.png")  
    self:addChild(self.frame);  
    self.frame:setPosition(0, 0); 
      
    -- 进度条 
    self.bar = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("Resources/common/img/bar_2.png"))    
    self.bar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
	-- Setup for a self.bar starting from the left since the midpoint is 0 for the x
    self.bar:setMidpoint(cc.p(0,0))
    -- Setup for a horizontal self.bar since the self.bar change rate is 0 for y meaning no vertical change
    self.bar:setBarChangeRate(cc.p(1, 0))
    self.bar:setPosition(0,0)
    self:addChild(self.bar)
end

return OrangeBar2
