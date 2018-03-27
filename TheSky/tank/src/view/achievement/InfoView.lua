--[[
--图鉴
--Author: mingming
--Date:
]]

local InfoView = qy.class("InfoView", qy.tank.view.BaseView, "view/achievement/InfoView")

function InfoView:ctor(delegate)
    InfoView.super.ctor(self)
end

return InfoView