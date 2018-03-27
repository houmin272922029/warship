local AchievementDialog = qy.class("AchievementDialog", qy.tank.view.BaseDialog)

local model = qy.tank.model.OperatingActivitiesModel
function AchievementDialog:ctor(delegate)
   	AchievementDialog.super.ctor(self)
    self:InjectView("BG")

    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(1020,600),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "earth_soul/res/8.png",
        ["onClose"] = function()
            self:dismiss()
        end
    })

    self:addChild(self.style)
    self.style:setLocalZOrder(-1)
    self.style:setPositionY(-15)

    local view = require("earth_soul.src.AchievementDialog2").new()

    view:setPosition(-40 - (display.width - 1080) / 2, -60)
    self.style.bg:addChild(view)
end

return AchievementDialog
