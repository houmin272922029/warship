local DebugContent = qy.class("DebugContent", qy.tank.view.BaseView, "view/alert/DebugContent")

function DebugContent:ctor()
    DebugContent.super.ctor(self)
end

function DebugContent:addContent(msg)
end

return DebugContent 