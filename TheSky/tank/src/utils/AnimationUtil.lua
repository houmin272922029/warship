--[[
    动画工具
    Author: Aaron Wei
    Date: 2015-01-15 17:54:35
]]

local AnimationUtil = {}

--[[
    创建序列帧动画
    frames:序列帧的文件名列表
    index:默认显示帧数的索引值   
    duration:每一帧时长
    loop:动画循环次数
    callback:动画执行完一次后回调函数
]]
function AnimationUtil.createFrames(frames,index,duration,loop,callback)
    local spr
    if index > 0 then
        spr = cc.Sprite:createWithSpriteFrameName(frames[index]) 
    else
        spr = cc.Sprite:create()
    end
    local arr = {}
    for i =1,#frames do
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frames[i])
        table.insert(arr,frame)  
    end 
 
    local animation = cc.Animation:createWithSpriteFrames(arr,duration)
    local animate = cc.Animate:create(animation)
    local seq
    if callback then
        seq = cc.Sequence:create(animate,cc.CallFunc:create(callback))
    else
        seq = cc.Sequence:create(animate)
    end
    if loop > 0 then
        spr.act = cc.Repeat:create(seq,loop)
    else
        spr.act = cc.RepeatForever:create(animate)      
    end
    return spr
end

function AnimationUtil.playFrames(target)
    target:runAction(target.act)
end

function AnimationUtil.stopFrames(target)
    if target then
        if target.act then
            target:stopAction(target.act)
        end
    end
end

function AnimationUtil.removeFrames(target)
    AnimationUtil.stopFrames(target)
    if target then
        if target:getParent() then
            target:getParent():removeChild(target)
        end
        target = nil
    end
end 

--[[--
--装备粒子运动轨迹
--]]
function AnimationUtil.equipSuitParticleAnim(_target, w,h)
    -- if w == nil then
    --     w = 80
    -- end
    -- if w == nil then
    --     h = 80
    -- end
    local w = 80
    local h = 80
    _target:setOpacity(190)
    _target:setPosition(9, 9)
    local time = 0.5
    --向上走
    local moveUp = cc.MoveBy:create(time, cc.p(0,h))
    --向右走
    local moveRight = cc.MoveBy:create(time, cc.p(w,0))
    --向下走
    local moveDown = cc.MoveBy:create(time, cc.p(0,-h))
    --向左走
    local moveLeft = cc.MoveBy:create(time, cc.p(-w,0))
    local seq = cc.Sequence:create(moveUp,moveRight,moveDown,moveLeft)
    _target:runAction(cc.RepeatForever:create(seq))
end

return AnimationUtil
