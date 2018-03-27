--[[
	军团boss
	Author: Aaron Wei
	Date: 2015-12-01 16:10:07
]]

local LegionBossCell = qy.class("LegionBossCell", qy.tank.view.BaseView, "legion_boss.ui.LegionBossCell")

function LegionBossCell:ctor(delegate)
    LegionBossCell.super.ctor(self)
    self.userInfo = qy.tank.model.UserInfoModel

    self:InjectView("rankLabel")
    self:InjectView("nameLabel")
    self:InjectView("hurtLabel")
    self:InjectView("bg")
end

function LegionBossCell:render(data)
    if data.kid == self.userInfo.kid then
        self.bg:setVisible(true)
    else
        self.bg:setVisible(false)
    end
    self.rankLabel:setString(tostring(data.rank))
    self.nameLabel:setString(data.nickname)
    self.hurtLabel:setString(qy.InternationalUtil:getResNumString(data.hurt))
    -- if math.log10(data.hurt) > 10 then
    --     self.hurtLabel:setString(tostring(math.floor(data.hurt/10^8)).."E")
    -- elseif math.log10(data.hurt) > 7 then
    --     self.hurtLabel:setString(tostring(math.floor(data.hurt/10^4)).."W")
    -- else
    --     self.hurtLabel:setString(tostring(data.hurt))
    -- end
end

function LegionBossCell:onEnter()
end

function LegionBossCell:onExit()
end

function LegionBossCell:onCleanup()
    print("LegionBossCell:onCleanup")
end

return LegionBossCell
