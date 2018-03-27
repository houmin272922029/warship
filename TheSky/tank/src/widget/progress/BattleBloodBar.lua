--[[
	战斗坦克血量条
	Author: Aaron Wei
	Date: 2015-05-08 11:49:05
]]

local BattleBloodBar = qy.class("BattleBloodBar", qy.tank.view.BaseView, "widget/BattleBloodBar")

function BattleBloodBar:ctor(params)
    BattleBloodBar.super.ctor(self)

    -- 背景
    -- self:InjectView("bg")
    -- self:InjectView("bar1")
    -- self:InjectView("bar2")
    self.beforePercent = nil
    self.percent = nil

    self.bar1 = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("Resources/battle/yishuz_29_1.png"))  
    self.bar1:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    -- Setup for a self.bar starting from the left since the midpoint is 0 for the x
    self.bar1:setMidpoint(cc.p(0,0))
    -- Setup for a horizontal self.bar since the self.bar change rate is 0 for y meaning no vertical change
    self.bar1:setBarChangeRate(cc.p(1, 0))
    self.bar1:setPosition(46,6)
    self:addChild(self.bar1,99)

    self.bar2 = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("Resources/battle/yishuz_34_1.png"))  
    self.bar2:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.bar2:setMidpoint(cc.p(0,0))
    self.bar2:setBarChangeRate(cc.p(1, 0))
    self.bar2:setPosition(46,6)
    self:addChild(self.bar2,98)
end

function BattleBloodBar:setPercent(v,isDelay,tween)
    self.percent = v
    -- self.bar1:setScaleX(v)
    -- if isDelay then
    --     self.timer = qy.tank.utils.Timer.new(1,1,function()
    --         if tolua.cast(self.bar2,"cc.Node") then
    --             self.bar2:setScaleX(v)
    --         end
    --     end)
    --     self.timer:start()
    -- else
    --     self.bar2:setScaleX(v)
    -- end

    self.bar1:setPercentage(v*100)
    if isDelay then
        self.timer = qy.tank.utils.Timer.new(0.7,1,function()
            if tolua.cast(self.bar2,"cc.Node") then
                if tween then
                    local to = cc.ProgressTo:create(0.3,v*100)
                    self.bar2:runAction(cc.RepeatForever:create(to))
                else
                    self.bar2:setPercentage(v*100)
                end
            end
        end)
        self.timer:start()
    end
    self.beforePercent = v
end

function BattleBloodBar:getPercent()
	return self.percent
end

function BattleBloodBar:destroy()
    if self.timer then
        self.timer:stop()
    end
end

return BattleBloodBar