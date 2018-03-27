local MainView = qy.tank.module.BaseUI.class("MainView", "onlyres.ui.MainView")

function MainView:ctor()
    MainView.super.ctor(self)

    -- self.ui这个表中包含了所有元素的集合，不区别层级
    self.ui.Button_1:setTitleText(qy.TextUtil:substitute(24001))

    local image = ccui.ImageView:create("onlyres/res/test.png")
    image:setPosition(display.cx, display.cy)
    image:addTo(self)
end

function MainView:onBack(sender)
    print("onBack(" .. tostring(sender) .. ")")

    self:removeSelf()
end

return MainView
