local MainView = qy.tank.module.BaseUI.class("MainView", "hello.ui.MainView")

function MainView:ctor()
    MainView.super.ctor(self)

    -- self.ui这个表中包含了所有元素的集合，不区别层级
    self.ui.Button_1:setTitleText("我是Hello模块")
end

function MainView:onBack(sender)
    print("onBack(" .. tostring(sender) .. ")")

    self:removeSelf()
end

return MainView
