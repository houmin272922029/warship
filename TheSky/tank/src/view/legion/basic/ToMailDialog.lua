--[[
	调职
	Author: H.X.Sun
]]

local ToMailDialog = qy.class("ToMailDialog", qy.tank.view.BaseDialog, "legion/ui/basic/ToMailDialog")

function ToMailDialog:ctor(delegate)
    ToMailDialog.super.ctor(self)

    local style = qy.tank.view.style.DialogStyle1.new({
        titleUrl = "legion/res/basic/mail_title.png",
        size = cc.size(620,400),
        position = cc.p(0,0),
        offset = cc.p(0,0),

        ["onClose"] = function()
            self:dismiss()
        end
    })
    -- style.closeBtn:setVisible(false)
    self:addChild(style,-1)
    local service = qy.tank.service.LegionService
    local model = qy.tank.model.LegionModel

    for i = 1, 2 do
        self:InjectView("rot_" .. i)
        self:OnClick("select_" .. i .."_btn",function()
            self:__selectLogic(i)
        end,{["isScale"] = false})
    end

    -- self:OnClick("cancel_btn", function()
    --     self:dismiss()
    -- end)
    --
    --
    self:OnClick("confirm_btn", function()
        local selectIdx = self.selectIdx
        self:dismiss()
        qy.tank.view.legion.basic.MailDialog.new({["selectIdx"]=selectIdx}):show(true)
    end)
end

function ToMailDialog:__selectLogic(i)
    self.selectIdx = i
    self.rot_1:setVisible(i==1)
    self.rot_2:setVisible(i==2)
end

function ToMailDialog:onEnter()
    self:__selectLogic(1)
end

return ToMailDialog
