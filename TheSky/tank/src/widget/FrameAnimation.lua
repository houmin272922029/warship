--[[
	逐帧动画类
	Author: Aaron Wei
	Date: 2015-01-28 16:31:58
]]

local FrameAnimation = class("FrameAnimation",function()
	return cc.Sprite:create()
end)
	
function FrameAnimation:ctor(frameTag,totalFrame,duration,loop,callback)
    self.frameTag = frameTag
    self.totalFrame = totalFrame
    self.duration = duration
    self.loop = loop
    self.callback = callback
end

function FrameAnimation:__play()
    local animation = cc.Animation:createWithSpriteFrames(self.frames,self.duration)
    local animate = cc.Animate:create(animation)
    local seq
    if self.callback then
        seq = cc.Sequence:create(animate,cc.CallFunc:create(self.callback))
    else
        seq = cc.Sequence:create(animate)
    end
    if self.loop > 0 then
        self.act = cc.Repeat:create(seq,self.loop)
    else
        self.act = cc.RepeatForever:create(animate)      
    end
    self:runAction(self.act)
end

function FrameAnimation:play()
    self.frames = {}
    for i =1,self.totalFrame do
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(self.frameTag.."_"..tostring(i)..".png")
        -- print("--------->" , self.frameTag.."_"..tostring(i)..".png")
        table.insert(self.frames,frame)  
    end
    self:__play()
end

function FrameAnimation:gotoAndPlay(idx)
    self.frames = {}
    for i =idx,self.totalFrame do
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(self.frameTag.."_"..tostring(i)..".png")
        table.insert(self.frames,frame)  
    end
    self:__play()
end

function FrameAnimation:stop()
    if self.act then
        self:stopAction(self.act)
    end
end

function FrameAnimation:remove()
	self:stop()
    if self:getParent() then
        self:getParent():removeChild(self)
    end
    self = nil
end

return FrameAnimation
