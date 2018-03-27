--[[
    补给
    Author: H.X.Sun
    Date: 2015-04-29
]]

local SupplyDialog = qy.class("SupplyDialog", qy.tank.view.BaseDialog)

function SupplyDialog:ctor(delegate)
    SupplyDialog.super.ctor(self)
    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(776,480),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "Resources/common/title/supply_title.png",

        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style)

    if delegate == nil then
        delegate = {}
    end
    delegate.callback = function()
        self:dismiss()
    end
    local infoCell = qy.tank.view.supply.SupplyInfoCell.new(delegate)
    infoCell:setPosition(-179,-138)
    style.bg:setContentSize(720,390)
    style.bg:addChild(infoCell)
end

return SupplyDialog
