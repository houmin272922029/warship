--[[
    成就 升级属性预览表
    Author: mingming
    Date: 2015-08-21 16:28:15
]]

local AttributeListDialog = qy.class("AttributeListDialog", qy.tank.view.BaseDialog)

function AttributeListDialog:ctor(entity)
    AttributeListDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
    -- self:InjectView("Name")
    -- self:InjectView("Panel_1")
    -- -- self:InjectView("Title")
    -- self:InjectView("BZ_1_1")

    -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(870, 500),
        position = cc.p(0, 0),
        offset = cc.p(0, 0),
        titleUrl = "Resources/common/title/shuxingyulan.png",

        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style)
    style:setLocalZOrder(-1)
    self.style = style

    local view = qy.tank.view.achievement.AttributeListDialog2.new(entity)
    view:setPosition(-5, 15)
    style:addChild(view)
    -- local winSize = cc.Director:getInstance():getWinSize()

    -- self.Panel_1:addChild(self:createView(entity))

    -- self.Name:setString(entity.name)
end

return AttributeListDialog
