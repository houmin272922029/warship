--[[
    每日检阅
]]
local InspectionDialog = qy.class("InspectionDialog", qy.tank.view.BaseDialog)

function InspectionDialog:ctor(delegate)
    InspectionDialog.super.ctor(self)

    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(1074,578),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "Resources/common/title/Daily-review_0001.png",


        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(self.style , -1)

    local view = qy.tank.view.inspection.InspectionDialog2.new(self)
    local winSize = cc.Director:getInstance():getWinSize()
    local fix = (winSize.width - 1080) / 2
	view:setPosition(-10 - fix, -70)
	self.style.bg:addChild(view)
end

return InspectionDialog
