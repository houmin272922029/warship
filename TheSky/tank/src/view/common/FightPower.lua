--[[
    用于显示 战斗力，例如  战斗力 1948
]]
local FightPower = qy.class("FightPower", qy.tank.view.BaseView)

function FightPower:ctor()
    FightPower.super.ctor(self)

    self.model = qy.tank.model.UserInfoModel
    self.fightPowerNum = self.model.userInfoEntity.fightPower
    self.fightView = qy.tank.widget.Attribute.new({
        ["attributeImg"] = qy.ResConfig.IMG_FIGHT_POWER, --属性字：例如攻击力
        ["numType"] = 20, --num_6.png
        ["hasMark"] = 0, --0没有加减号，1:有 默认为0
        ["value"] = self.fightPowerNum,--支持正负，但图必须是由加减号 ["hasMark"] = 1
        ["picType"] = 2, --1：- + 0123456789，2：+ - 0123456789 默认是1 
    })
    self:addChild(self.fightView)
end

function FightPower:update(value)
    if value ~= nil then
        self.fightView:update(value)
    else
        self.fightPowerNum = self.model.userInfoEntity.fightPower
        self.fightView:update(self.fightPowerNum)
    end
end

return FightPower