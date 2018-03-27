--[[--
--角色升级dialog
--Author: H.X.Sun
--Date: 2015-06-01
--]]--

local FunctionOpenDialog = qy.class("FunctionOpenDialog", qy.tank.view.BaseDialog, "view/guide/triggerGuide/FunctionOpenDialog")

function FunctionOpenDialog:ctor(delegate)
    FunctionOpenDialog.super.ctor(self)

	self.delegate = delegate
	self.res = qy.GuideModel:getTriggerGuideIcon() --
	local data = qy.tank.model.RoleUpgradeModel:findNextOpenData()

    self:OnClick("close_btn",function()
        self:dismiss()
        qy.GuideManager:nextTiggerGuide()
    end)

	self:InjectView("icon")
	self:InjectView("des")
    self:InjectView("btn_txt")
    self:InjectView("bg")
    self.bg:setContentSize(qy.winSize)
	self.icon:setSpriteFrame("Resources/activity/" ..self.res .. ".png")
	self.des:setString(data.introduce)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/txt/common_txt.plist")
    if qy.GuideModel:isNeedTriggerGuide() then
        self.btn_txt:setSpriteFrame("Resources/common/txt/qukankan.png")
    else
        self.btn_txt:setSpriteFrame("Resources/common/txt/zhidaole.png")
    end
end

return FunctionOpenDialog
