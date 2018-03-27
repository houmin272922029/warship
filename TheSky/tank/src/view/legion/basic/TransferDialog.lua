--[[
	调职
	Author: H.X.Sun
]]

local TransferDialog = qy.class("TransferDialog", qy.tank.view.BaseDialog, "legion/ui/basic/TransferDialog")

function TransferDialog:ctor(delegate)
    TransferDialog.super.ctor(self)
    local h = 550
    self:InjectView("cancel_btn")
    self:InjectView("confirm_btn")
    self:InjectView("title_bg")
    if delegate.user_score == 2 then
        for i = 1, 4 do
            self:InjectView("select_" .. i .."_btn")
            if i == 1 then
                self["select_" .. i .."_btn"]:setPosition(0,10)
            else
                self["select_" .. i .."_btn"]:setVisible(false)
            end
        end
        self.confirm_btn:setPosition(95,-90)
        self.cancel_btn:setPosition(-95,-90)
        self.title_bg:setPosition(0,100)
        h = 300
    end

    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(500,h),
        position = cc.p(0,0),
        offset = cc.p(0,0),

        ["onClose"] = function()
            self:dismiss()
        end
    })
    style.title_bg:setVisible(false)
    self:addChild(style,-1)
    local service = qy.tank.service.LegionService
    local model = qy.tank.model.LegionModel

    for i = 1, 4 do
        self:InjectView("rot_" .. i)
        self:OnClick("select_" .. i .."_btn",function()
            self:__selectLogic(i)
        end,{["isScale"] = false})
    end

    self:OnClick("cancel_btn", function()
        self:dismiss()
    end)


    self:OnClick("confirm_btn", function()
        if self.selectIdx == 1 then
            --T人
            service:kick({
                ["id"] = delegate.entity.kid,
            },function()
                qy.hint:show(qy.TextUtil:substitute(50075))
                delegate.updateJob()
                self:dismiss()
            end)
        else
            --调职 boss、vice_boss、staff
            local _job = ""
            local function callback()
                service:changeJob({
                    ["id"] = delegate.entity.kid,
                    ["job"] = _job,
                },function()
                    qy.hint:show(qy.TextUtil:substitute(50076))
                    delegate.updateJob()
                    self:dismiss()
                end)
            end
            if self.selectIdx == 2 then
                _job = "vice_boss"
                callback()
            elseif self.selectIdx == 3 then
                _job = "staff"
                callback()
            else
                _job = "boss"
                qy.tank.view.legion.basic.TipsDialog.new({
                    ["type"] = model.TIPS_BOSS,
                    ["name"] = delegate.entity.name,
                    ["callback"] = callback,
                }):show(true)
            end
        end
    end)
end

function TransferDialog:__selectLogic(i)
    self.selectIdx = i
    for j = 1, 4 do
        if i == j then
            self["rot_" .. j]:setVisible(true)
        else
            self["rot_"..j]:setVisible(false)
        end
    end
end

function TransferDialog:onEnter()
    self:__selectLogic(1)
end

return TransferDialog
