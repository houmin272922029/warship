--[[
    说明: 工具表
]]

local Utils = class("Utils")

local director = cc.Director:getInstance()
local textureCache = director:getTextureCache()
local texture2D = cc.Texture2D

function Utils.convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local factor = (glview:getScaleX() + glview:getScaleY()) / 2.0;
    return pointDis * factor / cc.Device:getDPI();
end

-- 将一个一维数组合并为二维数组
function Utils.oneToTwo(tables, num1, num2)
    local array = {}
    local tempTable = {}
    local tidx = 1
    for k, v in pairs(tables) do
        table.insert(tempTable, tidx, v)
        tidx = tidx + 1
    end

    local idx = 1
    for i = 1, num1 do
        array[i] = {}
        for j = 1, num2 do
            array[i][j] = tempTable[idx]
            idx = idx + 1
        end
    end

    return array
end

function Utils.keyof(hashtable, value)
    for k, v in pairs(hashtable) do
        if v == value then return k end
    end
    return nil
end

function Utils.slice(list, start, total)

    local _end = math.min(start + total - 1, #list)

    local array = {}

    for i = start, _end do
        table.insert(array, list[i])
    end

    return array
end

-- 遍历表
function Utils.foreach(t, callfunc)
    if not t then return end
    if #t > 0 then
        for i,v in ipairs(t) do
            callfunc(v)
        end
    else
        callfunc(t)
    end
end

--[[
    target:被震动的目标
    type:震动类型 1
    range:震动幅度
    duration:震动时长
]]
function Utils.shake(target,range)
    local px,py = target:getPosition()
    local px1,py1 = px+range,py+range
    local px2,py2 = px-range,py-range
    local px3,py3 = px+range,py-range
    local px4,py4 = px-range,py+range

    -- local move1 = cc.EaseElasticInOut:create(cc.MoveTo:create(0.05,cc.p(px1,py1))) -- 匀速
    -- local move2 = cc.EaseElasticInOut:create(cc.MoveTo:create(0.05,cc.p(px2,py2))) -- 匀速
    -- local move3 = cc.EaseElasticInOut:create(cc.MoveTo:create(0.05,cc.p(px,py))) -- 匀速
    -- local move4 = cc.EaseElasticInOut:create(cc.MoveTo:create(0.05,cc.p(px3,py3))) -- 匀速
    -- local move5 = cc.EaseElasticInOut:create(cc.MoveTo:create(0.05,cc.p(px4,py4))) -- 匀速
    -- local move6 = cc.EaseElasticInOut:create(cc.MoveTo:create(0.05,cc.p(px,py))) -- 匀速

    local move1 = cc.EaseBackInOut:create(cc.MoveTo:create(0.05,cc.p(px1,py1))) -- 匀速
    local move2 = cc.EaseBackInOut:create(cc.MoveTo:create(0.05,cc.p(px2,py2))) -- 匀速
    local move3 = cc.EaseBackInOut:create(cc.MoveTo:create(0.05,cc.p(px,py))) -- 匀速
    local move4 = cc.EaseBackInOut:create(cc.MoveTo:create(0.05,cc.p(px3,py3))) -- 匀速
    local move5 = cc.EaseBackInOut:create(cc.MoveTo:create(0.05,cc.p(px4,py4))) -- 匀速
    local move6 = cc.EaseBackInOut:create(cc.MoveTo:create(0.05,cc.p(px,py))) -- 匀速


    -- local move1 = cc.EaseElasticInOut:create(cc.MoveTo:create(0.2,cc.p(px2,py2))) -- 弹性缓冲
    -- local move1 = cc.EaseExponentialInOut:create(cc.MoveTo:create(0.05,cc.p(px2,py2))) -- 指数缓冲
    -- local move1 = cc.EaseSineInOut:create(cc.MoveTo:create(0.1,cc.p(px2,py2))) -- sine缓冲
    -- local move1 = cc.EaseBackInOut:create(cc.MoveTo:create(duration,cc.p(px1,py1))) -- 回震缓冲
    -- local move1 = cc.EaseBounceInOut:create(cc.MoveTo:create(0.1,cc.p(px2,py2))) -- 跳跃缓冲

    local seq = cc.Sequence:create(move1,move2,move3,move4,move5,move6,nil)
    local shake = cc.Repeat:create(seq,1)
    target:runAction(shake)
end

function Utils.horizontalShake(target,range,duration)
    local px,py = target:getPosition()
    local px1,py1 = px+range,py
    local px2,py2 = px-range,py

    local move1 = cc.MoveTo:create(duration,cc.p(px1,py1)) -- 匀速
    -- local move1 = cc.EaseElasticInOut:create(cc.MoveTo:create(0.2,cc.p(px2,py2))) -- 弹性缓冲
    -- local move1 = cc.EaseExponentialInOut:create(cc.MoveTo:create(0.05,cc.p(px2,py2))) -- 指数缓冲
    -- local move1 = cc.EaseSineInOut:create(cc.MoveTo:create(0.1,cc.p(px2,py2))) -- sine缓冲
    -- local move1 = cc.EaseBackInOut:create(cc.MoveTo:create(duration,cc.p(px1,py1))) -- 回震缓冲
    -- local move1 = cc.EaseBounceInOut:create(cc.MoveTo:create(0.1,cc.p(px2,py2))) -- 跳跃缓冲

    local move2 = cc.MoveTo:create(duration,cc.p(px2,py2))
    -- local move2 = cc.EaseBackInOut:create(cc.MoveTo:create(duration,cc.p(px2,py2))) -- 回震缓冲

    local move3 = cc.MoveTo:create(duration,cc.p(px,py))
    -- local move3 = cc.EaseBackInOut:create(cc.MoveTo:create(duration,cc.p(px,py))) -- 回震缓冲

    local seq = cc.Sequence:create(move1,move2,move3,nil)

    local shake = cc.Repeat:create(seq,1)
    target:runAction(shake)
end

function Utils.verticalShake(target,range,duration)
    local px,py = target:getPosition()
    local px1,py1 = px,py+range
    local px2,py2 = px,py-range

    local move1 = cc.MoveTo:create(duration,cc.p(px1,py1)) -- 匀速
    -- local move1 = cc.EaseElasticInOut:create(cc.MoveTo:create(0.2,cc.p(px2,py2))) -- 弹性缓冲
    -- local move1 = cc.EaseExponentialInOut:create(cc.MoveTo:create(0.05,cc.p(px2,py2))) -- 指数缓冲
    -- local move1 = cc.EaseSineInOut:create(cc.MoveTo:create(0.1,cc.p(px2,py2))) -- sine缓冲
    -- local move1 = cc.EaseBackInOut:create(cc.MoveTo:create(0.2,cc.p(px1,py1))) -- 回震缓冲
    -- local move1 = cc.EaseBounceInOut:create(cc.MoveTo:create(0.1,cc.p(px2,py2))) -- 跳跃缓冲

    local move2 = cc.MoveTo:create(duration,cc.p(px2,py2))

    local move3 = cc.MoveTo:create(duration,cc.p(px,py))

    local seq = cc.Sequence:create(move1,move2,move3,nil)

    local shake = cc.Repeat:create(seq,1)
    target:runAction(shake)
end

function Utils.rotationShake(target,range,duration)

end

function Utils.scaleShake(target,range,duration)
    local scale = target:getScale()
    local scale1 = scale*1.1
    local scale2 = scale

    local transform1 = cc.ScaleTo:create(duration,scale1) -- 匀速
    -- local transform1 = cc.EaseElasticInOut:create(cc.MoveTo:create(0.2,cc.p(px2,py2))) -- 弹性缓冲
    -- local transform1 = cc.EaseExponentialInOut:create(cc.MoveTo:create(0.05,cc.p(px2,py2))) -- 指数缓冲
    -- local transform1 = cc.EaseSineInOut:create(cc.MoveTo:create(0.1,cc.p(px2,py2))) -- sine缓冲
    -- local transform1 = cc.EaseBackInOut:create(cc.ScaleTo:create(duration,scale1)) -- 回震缓冲
    -- local transform1 = cc.EaseBounceInOut:create(cc.MoveTo:create(0.1,cc.p(px2,py2))) -- 跳跃缓冲

    local transform2 = cc.ScaleTo:create(duration,scale2) -- 回震缓冲

    local seq = cc.Sequence:create(transform1,transform2,nil)

    local shake = cc.Repeat:create(seq,1)
    target:runAction(shake)
end

function Utils.preloadJPG(jpg)
    texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RG_B565)
    textureCache:addImage(jpg)
    texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_DEFAULT)
end

function Utils.preloadPNG(png)
    texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444)
    textureCache:addImage(png)
    texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_DEFAULT)
end

return Utils
