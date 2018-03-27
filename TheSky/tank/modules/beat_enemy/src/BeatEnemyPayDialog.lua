--[[
    战争图卷
    2016年07月26日17:42:39
]]
local BeatEnemyPayDialog = qy.class("BeatEnemyPayDialog", qy.tank.view.BaseDialog, "beat_enemy.ui.BeatEnemyPayDialog")

local model = qy.tank.model.BeatEnemyModel
local service = qy.tank.service.BeatEnemyService
function BeatEnemyPayDialog:ctor(delegate)
    BeatEnemyPayDialog.super.ctor(self)

    self:InjectView("Pay_num")
    self:InjectView("Point_num")

    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(540,340),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "Resources/common/title/beat_enemy_title2.png",


        ["onClose"] = function()
            self:removeSelf()
        end
    })
    self:addChild(self.style , -1)

    self.Pay_num:setString(model.diamond)
    self.Point_num:setString(model.recharge_point)
end






return BeatEnemyPayDialog
