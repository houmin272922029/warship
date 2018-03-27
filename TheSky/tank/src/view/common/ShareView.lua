--[[
    星级评价
]]--
local ShareView = qy.class("ShareView", qy.tank.view.BaseDialog, "view/common/ShareView")

local platform = device.platform

function ShareView:ctor(idx)
    ShareView.super.ctor(self)
    -- self:InjectView("Panel_1")
    -- self:InjectView("Button_1")
    -- self:InjectView("Button_2")
    self.idx = idx
    self:OnClick("close_btn", function(sender)
        self:dismiss()
    end)
    self:OnClick("go_btn", function(sender)
        qy.tank.service.LoginService:gameScore()
        if platform == "ios" then
            qy.tank.utils.SDK:jumpByUrl("appstore_score")
        elseif platform == "android" then
            -- qy.tank.utils.SDK:openURL("https://play.google.com/apps/testing/com.xiaoao.tankempire")
            qy.tank.utils.SDK:openURL("https://play.google.com/store/apps/details?id=com.xiaoao.clashandcommand")
        end
    end)
    self:OnClick("no_btn", function(sender)
        if self.idx == 1 then
            cc.UserDefault:getInstance():setIntegerForKey("shareArena", 0)
        -- elseif self.idx == 2 then
        --     cc.UserDefault:getInstance():setIntegerForKey("campaign1", 0)
        elseif self.idx == 3 then
            cc.UserDefault:getInstance():setIntegerForKey("campaign2", 0)
        end
        self:dismiss()
    end)
end

return ShareView
