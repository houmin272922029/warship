--[[
	排行
	Author: H.X.Sun
]]
local RankItem = qy.class("RankItem", qy.tank.view.BaseView, "war_aid/ui/RankItem")

local AwardItem = qy.tank.view.common.AwardItem

function RankItem:ctor(delegate)
   	RankItem.super.ctor(self)
    self:InjectView("Rank")
    self:InjectView("Name")
    self:InjectView("Num")
    self:InjectView("icon")
    self:InjectView("Award_num")
    self.model = qy.tank.model.OperatingActivitiesModel
end

function RankItem:setData(param)
    self.Rank:setString(param.idx)
    if param.data then
        self.Name:setString(param.data.nickname)
        self.Num:setString(param.data.times)
    else
        self.Name:setString(qy.TextUtil:substitute(90117))
        self.Num:setString(0)
    end
    local itemData = AwardItem.getItemData(param.award)
    if self.model.GROUND_AID_ACTION == param.cur_aid then
        self.icon:setVisible(false)
        self.Award_num:setString(itemData.name .. " x" ..param.award.num)
        self.Award_num:setPosition(530,19.5)
    else
        self.icon:setTexture(itemData.icon)
        self.icon:setVisible(true)
        self.Award_num:setString(param.award.num)
        self.Award_num:setPosition(595,19.5)
    end
end

return RankItem
