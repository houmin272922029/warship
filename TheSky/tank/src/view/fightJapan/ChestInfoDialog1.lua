--[[
    关卡信息
]]
local ChestInfoDialog1 = qy.class("ChestInfoDialog1", qy.tank.view.BaseDialog, "view/fightJapan/ChestInfoDialog1")

function ChestInfoDialog1:ctor(delegate)
    ChestInfoDialog1.super.ctor(self)
    self:setCanceledOnTouchOutside(true)

    local model = qy.tank.model.FightJapanModel
    -- self.userInfoModel = qy.tank.model.UserInfoModel
    -- self.pointUserData = delegate.pointUserData
    local num = model:getChestAwardById(delegate.id)
    self:InjectView("coinTxt")
    self.coinTxt:setString(num or 0)
    self.style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(238,150),
        position = cc.p(0,0),
        offset = cc.p(0,0),

        -- ["onClose"] = function()
        --     self:dismiss()
        -- end
    })
    self:addChild(self.style , -1)
end

-- function ChestInfoDialog1:updateAll()

-- end

return ChestInfoDialog1
