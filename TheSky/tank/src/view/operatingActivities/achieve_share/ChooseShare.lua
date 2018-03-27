--[[--
--二选一cell
--Author: H.X.Sun
--Date: 2015-06-24
--]]--
local ChooseShare = qy.class("ChooseShare", qy.tank.view.BaseDialog, "share/ui/shareAchive")

function ChooseShare:ctor(delegate)
    ChooseShare.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel
    local service = qy.tank.service.OperatingActivitiesService
    local sdk = qy.tank.utils.SDK
    self:InjectView("title")
    self:InjectView("message")
    self:InjectView("awardpic")
    self:InjectView("awardNum")
    self:InjectView("get_name")
    local data = self.model:getTempData()
    self.title:setString(data.desc)
    self.message:setString(data.message)
    self.awardNum:setString(tostring(data.award[1].num))
    self:OnClick("closeBtn", function(sender)
        self:dismiss()
    end)
    self:OnClick("wbBtn", function(sender)
        self:dismiss()
        sdk:achieve_share(1,data.message,function () 
            service:setAchieveSharestatus(data.type,function ( data)
                qy.tank.view.operatingActivities.achieve_share.AchieveShareDialog:dismiss()
                qy.tank.view.operatingActivities.achieve_share.AchieveShareDialog.new():show(true)
            end)
            
        end)
      
    end)
    self:OnClick("wxBtn", function(sender)
        self.dismiss()
        sdk:achieve_share(2,data.message,function () 
            service:setAchieveSharestatus(data.type,function ( data)
                qy.tank.view.operatingActivities.achieve_share.AchieveShareDialog:dismiss()
                qy.tank.view.operatingActivities.achieve_share.AchieveShareDialog.new():show(true)
            end)
            
        end)
    end)
end

return ChooseShare