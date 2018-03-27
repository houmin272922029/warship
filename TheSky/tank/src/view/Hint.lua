--飘字提示
local Hint = qy.class("Hint", qy.tank.view.BaseView)

function Hint:ctor()
    Hint.super.ctor(self)
end

--data:如果data是字符串，则是飘纯文字
--data：是table
--data.critMultiple: 暴击倍数，现在有2、4、6、8倍，默认没有
--data.award: 【toast2 独有】奖励 award内含type、num、id
--data.text:【toast3 独有】显示的文本
function Hint:show(data, duration, position)
    self.duration = duration or 1
    self.position = position or cc.p(qy.winSize.width / 2, qy.winSize.height * 0.6)
    local toast = nil
    if type(data) == "string" then
        -- 文本
        toast = qy.tank.widget.Toast.new()
            -- {
                -- ["toRemove"] = function(thisToast)
                    -- thisToast:removeFrom(self)
                -- end
            -- }

        toast:make(toast ,data, position)
    elseif type(data.text) == "string" then
        -- 暴击+文本
        toast = qy.tank.view.common.Toast3.new(data)
        toast:setPosition(self.position)
    elseif data.textType == 1 then
        toast = qy.tank.view.common.Toast4.new(data)
        toast:setPosition(self.position)
    elseif data.textType == 2 then
        toast = qy.tank.view.common.Toast5.new(data)
        toast:setPosition(self.position)
    else
        -- 暴击 + 奖励
        toast = qy.tank.view.common.Toast2.new(data)
        toast:setPosition(self.position)
    end

    toast:setLocalZOrder(20)
    toast:addTo(self)
    self:showCOKEffect(toast)
    qy.QYPlaySound.playEffect(qy.SoundType.CHANNEL_2_TIPS)
end

--飘字停顿显示 ： 文字飘出，停顿若干毫秒，再渐隐消失
function Hint:showCOKEffect(toast)
    -- local duration = 1
    toast:setScaleX(1)
    toast:setScaleY(0.1)
    toast:stopAllActions()
    -- toast:setOpacity(255)
    -- local spawn = cc.Spawn:create(cc.FadeOut:create(0.5) , cc.MoveBy:create(0.5,cc.p(0, 80)))
    local spawn = cc.Spawn:create(cc.MoveBy:create(0.5,cc.p(0, 80)))
    -- local spawn = cc.Spawn:create(cc.FadeOut:create(0.5))
    toast:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1,1) ,cc.DelayTime:create(self.duration) ,spawn,cc.CallFunc:create(function()
        self:removeChild(toast)
        -- self.toast = nil
    end)
    ))
end

--[[--
--飘图
--@param toast 运动的ui
--@param #number duration 运动时间(默认为2s)
--@param #
--]]
function Hint:showImageToast(toast, actionId, duration, position, h_ratio)
    if not tolua.cast(toast, "cc.Node") then
        --判空操作
        return
    end
    -- self.toast = toast
    self.duration = (duration or 2)
    self.position = position or cc.p(qy.winSize.width / 2, qy.winSize.height * 0.7)
    toast:setPosition(self.position)
    toast:setLocalZOrder(20)
    if toast:getParent() == nil then
        self:addChild(toast)
    end
    if actionId == nil then
        actionId = 1
    end
    self:__playAnimByActionId(toast, actionId, h_ratio)
end

--[[--
--根据action ID 播放动作
--]]
function Hint:__playAnimByActionId(toast, actionId, h_ratio)
    toast:stopAllActions()
    if actionId == 1 then
        if h_ratio == nil then
            h_ratio = 2
        end

        --飘字动画(向上，停顿，向上)
        toast:setOpacity(125)
        local FadeIn = cc.FadeTo:create(self.duration/ 2, 255)
        local move1 = cc.MoveTo:create(self.duration/ 2, cc.p(self.position.x, (qy.winSize.height + self.position.y)/h_ratio))
        local delay = cc.DelayTime:create(0.5)
        --从淡到正常，从下到中点
        local spawn1 = cc.Spawn:create(move1,FadeIn)
        local delay = cc.DelayTime:create(self.duration/ 6)
        local fadeOut = cc.FadeTo:create(self.duration/ 3, 0)
        -- local move2 = cc.MoveTo:create(self.duration/ 3, cc.p(self.position.x, qy.winSize.height * 0.9))
        local scale = cc.ScaleTo:create(self.duration/ 3, 1.1)
        local spawn2 = cc.Spawn:create(scale,fadeOut)
        toast:runAction(cc.Sequence:create(spawn1 ,spawn2,cc.CallFunc:create(function()
            self:removeChild(toast)
        end)))
    elseif actionId == 2 then
        --数字滚动
        local endValue =  toast:getStringValue()
        local nowValue = 1
        toast:setOpacity(0)

        local function __disappear()
            local FadeIn = cc.FadeTo:create(self.duration/ 3, 0)
            local move = cc.MoveTo:create(self.duration/ 3, cc.p(self.position.x, qy.winSize.height * 0.9))
            local scale = cc.ScaleTo:create(self.duration/6, 1.1)
            local delay = cc.DelayTime:create(self.duration/6)
            local spawn1 = cc.Spawn:create(move,FadeIn)
            local spawn2 = cc.Spawn:create(delay,scale)
            local spawn3 = cc.Spawn:create(spawn1,spawn2)
            toast:runAction(cc.Sequence:create(spawn3,cc.CallFunc:create(function()
                self:removeChild(toast)
            end)))
        end

        local function __updateValue()
            toast:stopAllActions()

            local seq = cc.Sequence:create(cc.CallFunc:create(function()
               nowValue = math.ceil(nowValue * 1.7)

                if nowValue >= endValue then
                    toast:update(endValue)
                    toast:stopAllActions()
                    __disappear()
                else
                    toast:update(nowValue)
                end
            end))
            toast:runAction(cc.RepeatForever:create(seq))
        end

        local FadeIn = cc.FadeTo:create(0.1, 255)
        toast:update(1)
        local callFunc1 = cc.CallFunc:create(function()
            __updateValue()
        end)

        toast:runAction(cc.Sequence:create(FadeIn, callFunc1))
        --上升消失
    elseif actionId == 3 then
        --盖章动画
        toast:setScale(3)
        -- self.toast:setVisible(true)
        toast:setOpacity(0)
        local scaleSmall =  cc.ScaleTo:create(self.duration / 12, 1)
        local ease = cc.EaseOut:create(scaleSmall,self.duration / 12)
        local FadeIn = cc.FadeTo:create(self.duration/ 6, 255)
        local spawn1= cc.Spawn:create(ease,FadeIn)
        local delay = cc.DelayTime:create(self.duration / 6)
        local FadeOut = cc.FadeTo:create(self.duration/ 6, 0)
        local callFunc = cc.CallFunc:create(function ()
            self:removeChild(toast)
        end)
        toast:runAction(cc.Sequence:create(spawn1,delay, FadeOut, callFunc))
    end
end

return Hint
