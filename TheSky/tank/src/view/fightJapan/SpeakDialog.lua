--[[
    远征敌军说话
    Author: H.X.Sun
]]
local SpeakDialog = qy.class("SpeakDialog", qy.tank.view.BaseDialog, "view/fightJapan/SpeakDialog")

function SpeakDialog:ctor(delegate)
    SpeakDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
    self:InjectView("tips")
    local moveUp = cc.MoveBy:create(0.2, cc.p(0, 5))
    local moveDown = cc.MoveBy:create(0.2, cc.p(0, -5))
    local seq = cc.Sequence:create(moveUp, moveDown)
    self.tips:runAction(cc.RepeatForever:create(seq))
    self:setBGOpacity(0)
end

return SpeakDialog
