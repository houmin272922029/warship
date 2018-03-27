--[[
	无缓动效果的进度条，支持素材拉伸
	Author: Aaron Wei
	Date: 2015-02-07 18:47:17
]]

local ScaleBar = class("ScaleBar",function()
	return cc.Node:create() 
end)

function ScaleBar:ctor()
    self:init()
end

function ScaleBar:init(b,f,d)
    self.percent = 100
    self.offset = 0
    self.bar = nil
    self.frame = nil
    self.direction = nil
    -- self.value  = 0
    -- self.maxValue = 0
end

function ScaleBar:create(b,f,d)
    -- 背景
    if f then
        self.frame = f 
        self:addChild(self.frame)
    end 
    
    -- 进度条 
    if b then
        self.bar = b
        self:addChild(self.bar)
    end

    self:setDirection(d)
end

function ScaleBar:setDirection(d)
    self.direction = d
    if self.direction == 0 then
        if self.frame then
            self.frame:setAnchorPoint(0,0)
        end
        self.bar:setAnchorPoint(0,0)
    elseif self.direction == 1 then
        if self.frame then 
            self.frame:setAnchorPoint(1,0)
        end
        self.bar:setAnchorPoint(1,0)
    elseif self.direction == 2 then
        if self.frame then
            self.frame:setAnchorPoint(0,1)
        end
        self.bar:setAnchorPoint(0,1)
    elseif self.direction == 3 then
        if self.frame then
            self.frame:setAnchorPoint(0,0)
        end
        self.bar:setAnchorPoint(0,0)
    end

    self:setPercent(self.percent)
end

function ScaleBar:setBarPosition(x,y)
    if tolua.cast(self.bar,"cc.Node") then
        self.bar:setPosition(x,y)
    end
end

function ScaleBar:setBgPosition(x,y)
    if tolua.cast(self.frame,"cc.Node") then
        self.frame:setPosition(x,y)
    end
end

function ScaleBar:setPercent(p)
    local before = self.percent
    self.percent = math.min(100,math.max(0,p))
    self.offset = self.percent - before
    
    if self.direction == 0 then
        self.bar:setScaleX(self.percent/100)
    elseif self.direction == 1 then
        self.bar:setScaleX(self.percent/100)
    elseif self.direction == 2 then
        self.bar:setScaleY(self.percent/100)
    elseif self.direction == 3 then
        self.bar:setScaleY(self.percent/100)
    end
end

function ScaleBar:getPercent()
    return self.percent
end

-- function ScaleBar:setValue(v)
-- 	value = v
--     if maxValue > 0 then
--         setPercent(value/maxValue*100)
--     end
-- end

-- function ScaleBar:getValue()
--     if maxValue > 0 then
--         value = maxValue*percent
--     end
--     return value
-- end

-- function ScaleBar:setMaxValue(v)
-- 	maxValue = v
--     if value >= 0 then
--         setPercent(value/maxValue*100)
--     end
-- end

-- function ScaleBar:getMaxValue()
--     return maxValue
-- end

function ScaleBar:getOffset()
    return self.offset
end

return ScaleBar