--[[
--排名
--Author: mingming
--Date:
]]

local RankItem = qy.class("RankItem", qy.tank.view.BaseView, "pubs.ui.RankItem")

function RankItem:ctor(delegate)
    RankItem.super.ctor(self)
    self.delegate = delegate

    self:InjectView("Rank")
    self:InjectView("Name")
    self:InjectView("Times")
    self:InjectView("Num")
    self:InjectView("Award")


    -- self:OnClick("Btn_upgrade", function()
 
    -- end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
end

function RankItem:setData(data, idx)
	self.Rank:setString(idx + 1)
	self.Name:setString(data.nickname)
	self.Times:setString(data.times)

	local award = qy.Config.pub_rank[tostring(idx + 1)].award[1]
	local item = qy.tank.view.common.AwardItem.getItemData(award)
	self.Award:setTexture(item.icon)
	self.Num:setString(award.num)

	local kid = qy.tank.model.UserInfoModel.userInfoEntity.kid
	local color = kid == data.kid and cc.c3b(220, 219, 49) or cc.c3b(255, 255, 255)


	self.Rank:setTextColor(color)
	self.Name:setTextColor(color)
	self.Times:setTextColor(color)
	self.Num:setTextColor(color)
end
return RankItem