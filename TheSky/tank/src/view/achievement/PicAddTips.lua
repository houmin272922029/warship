--[[
--图鉴
--Author: mingming
--Date:
]]

local PicAddTips = qy.class("PicAddTips", qy.tank.view.BaseView, "view/achievement/PicAddTips")

function PicAddTips:ctor(delegate)
    PicAddTips.super.ctor(self)

    self:InjectView("Name")
end

function PicAddTips:setData(data)
    self.Name:setString(data.name)
end


return PicAddTips