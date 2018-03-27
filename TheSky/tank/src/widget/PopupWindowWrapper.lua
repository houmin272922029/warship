local PopupWindowWrapper = qy.class("PopupWindowWrapper", qy.tank.view.BaseView)

function PopupWindowWrapper:ctor()
    PopupWindowWrapper.super.ctor(self)

    self.mask = ccui.Layout:create()
    self.mask:setContentSize(qy.winSize.width, qy.winSize.height)
    self.mask:setBackGroundColor(cc.c3b(0, 0, 0))    -- 填充颜色
    self.mask:setBackGroundColorType(1)              -- 填充方式
    self.mask:setBackGroundColorOpacity(100)         -- 颜色透明度
    self:addChild(self.mask,-999)
    self.mask:setSwallowTouches(true)
    -- cc.Node.addChild(self,self.mask,-1)

    -- self.container = cc.Node:create()
    -- self:addChild(self.container)
    -- cc.Node.addChild(self,self.container)

    self:OnClick(self.mask, function()
        print(self.__cname,self.isCanceledOnTouchOutside)
        if self.isCanceledOnTouchOutside then
            self:dismiss()
        end
    end,{["isScale"] = false, ["hasAudio"] = false})
end

function PopupWindowWrapper:onEnter()

end

function PopupWindowWrapper:onEnterFinish()
    local mask = ccui.Layout:create()
    mask:setContentSize(qy.winSize.width, qy.winSize.height)
    mask:setBackGroundColor(cc.c3b(0, 0, 0))    
    mask:setBackGroundColorType(1)              
    mask:setBackGroundColorOpacity(0)         
    self:addChild(mask)
    mask:setTouchEnabled(true)
    -- mask:setSwallowTouches(true)
    
    mask:addTouchEventListener(function(sender, eventType)
    end)

    if mask and tolua.cast(mask,"cc.Node") then
        self:removeChild(mask)
    end
end

-- function PopupWindowWrapper:

--弹框效果
function PopupWindowWrapper:toShowPopupEffert()
    -- self:setScale(0.8)
    self:setAnchorPoint(0.5, 0.5)
    self:setPosition(qy.winSize.width / 2, qy.winSize.height / 2)
    -- self:runAction(cc.Sequence:create(cc.ScaleTo:create(0.15, 1.15), cc.ScaleTo:create(0.1, 1)))
    -- self.mask:setOpacity(0)
    -- self.mask:runAction(cc.Sequence:create(cc.DelayTime:create(0.15), cc.FadeTo:create(0.1, 255)))

    -- local act1 = cc.MoveTo:create(0.01,cc.p(px2,py2)) -- 匀速
    -- local act1 = cc.EaseElasticInOut:create(cc.ScaleTo:create(0.5,1)) -- 弹性缓冲
    -- local act1 = cc.EaseExponentialInOut:create(cc.MoveTo:create(0.05,cc.p(px2,py2))) -- 指数缓冲
    -- local act1 = cc.EaseSineInOut:create(cc.MoveTo:create(0.1,cc.p(px2,py2))) -- sine缓冲
    -- local act1 = cc.EaseBackInOut:create(cc.MoveTo:create(0.2,cc.p(px2,py2))) -- 回震缓冲
    -- local act1 = cc.EaseBounceInOut:create(cc.MoveTo:create(0.1,cc.p(px2,py2))) -- 跳跃缓冲

    -- local act2 = cc.MoveTo:create(0.5,cc.p(px1,py1)) -- 匀速
    -- local act2 = cc.EaseElasticInOut:create(cc.MoveTo:create(0.5,cc.p(px1,py1))) -- 弹性缓冲
    -- local act2 = cc.EaseExponentialInOut:create(cc.MoveTo:create(0.5,cc.p(px1,py1))) -- 指数缓冲
    -- local act2 = cc.EaseSineOut:create(cc.MoveTo:create(1,cc.p(px1,py1))) -- sine缓冲
    -- local act2 = cc.EaseBackInOut:create(cc.MoveTo:create(0.5,cc.p(px1,py1))) -- 回震缓冲
    -- local act2 = cc.EaseBounceInOut:create(cc.MoveTo:create(0.5,cc.p(px1,py1))) -- 跳跃缓冲

    -- self:runAction(act1)
end

-- function PopupWindowWrapper:addView(view)
--     PopupWindowWrapper.super.addView(self,view)
-- end

-- local cc_Node_addChild = cc.Node.addChild
-- function PopupWindowWrapper:addChild(child,zorder,tag)
--     if zorder == nil then
--         cc_Node_addChild(self.container,child)
--     elseif tag == nil then
--         cc_Node_addChild(self.container,child,zorder)
--     else
--         cc_Node_addChild(self.container,child,zorder,tag)
--     end
-- end

function PopupWindowWrapper:setCanceledOnTouchOutside(cancel)
    self.isCanceledOnTouchOutside = cancel
end

--设置背景透明度
function PopupWindowWrapper:setBGOpacity(opacity)
    self.mask:setOpacity(opacity)
end

return PopupWindowWrapper
