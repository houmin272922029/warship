local Debugger = qy.class("Debugger", qy.tank.view.BaseView, "widget/Debugger")

function Debugger:ctor()
    Debugger.super.ctor(self)

    self.layout = ccui.Layout:create()
    self.layout:setContentSize(qy.winSize.width, qy.winSize.height)
    self.layout:setBackGroundColor(cc.c4b(0,0,0,125))    -- 填充颜色
    self.layout:setBackGroundColorType(1)              -- 填充方式
    self.layout:setBackGroundColorOpacity(100)         -- 颜色透明度
    self.layout:setTouchEnabled(true)
    self:addChild(self.layout, -1)
    
    -- 点击透明区域可关闭
    self:OnClick(self.layout, function()
        self:setVisible(false)
        self.totalMesg = ""
    end)

    self:InjectView("contentTxt")
    self.totalMesg = ""
    self:setVisible(false)
end

function Debugger:showBugMesg(mesg)
    self:setVisible(true)
    self.totalMesg = self.totalMesg..tostring(mesg).."\n"
    self.contentTxt:setString(self.totalMesg)
end

return Debugger
