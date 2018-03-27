--[[
	军团战-奖励cell
	Author: H.X.Sun
]]

local AwardCell = qy.class("AwardCell", qy.tank.view.BaseView, "legion_war/ui/AwardCell")

function AwardCell:ctor(params)
    AwardCell.super.ctor(self)
    self:InjectView("rank_txt")
    for i = 1, 2 do
        self:InjectView("coin_"..i)
        self:InjectView("num_"..i)
    end
    local datat
    for i = 1, #params.award do
        data = qy.tank.view.common.AwardItem.getItemData(params.award[i])
        self["coin_"..i]:setTexture(data.icon)
        self["num_"..i]:setString(" x "..data.num)
    end

    self.rank_txt:setString(params.title)
end

return AwardCell
