--dialog样式基类
local DialogBaseStyle = qy.class("DialogBaseStyle", qy.tank.view.BaseView)

function DialogBaseStyle:ctor(params)
    DialogBaseStyle.super.ctor(self)

    -- 背景
    self:InjectView("bg")

    -- self.bg:setSwallowTouches(false)
    -- if self.bg then
    --     self.bg:setPosition(qy.winSize.width/2, qy.winSize.height/2)
    -- end
    -- 框体
    self:InjectView("frame")
    self.frame:setSwallowTouches(false)
    self.frame:setContentSize(params.size.width,params.size.height)
    self.frame:setPosition(qy.winSize.width/2 + params.offset.x, qy.winSize.height/2+ params.offset.y)
    self.bg:setPosition(qy.winSize.width/2 + params.offset.x, qy.winSize.height/2+ params.offset.y)
    -- 按钮
    self:InjectView("closeBtn")
    if self.closeBtn then
        --DialogStyle5 没有closeBtn
        self.closeBtn:addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                qy.QYPlaySound.playEffect(qy.SoundType.BTN_CLOSE)
                if params.onClose then
                    params.onClose()
                end
            end
        end)
    end
end

function DialogBaseStyle:setFrameSize(size)
    self.frame:setContentSize(size.width,size.height)
end

function DialogBaseStyle:setFramePosition(pos)
    self.frame:setPosition(pos)
end

function DialogBaseStyle:setCloseBtnPosition(pos)
    self.closeBtn:setPosition(pos)
end

return DialogBaseStyle
