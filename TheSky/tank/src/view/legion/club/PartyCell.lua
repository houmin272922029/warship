--[[
	宴会cell
	Author: H.X.Sun
]]

local PartyCell = qy.class("PartyCell", qy.tank.view.BaseView,"legion/ui/club/PartyCell")

function PartyCell:ctor(delegate)
    PartyCell.super.ctor(self)
    self.model = qy.tank.model.LegionModel
    local service = qy.tank.service.LegionService

    self:InjectView("user_name")
    self:InjectView("num_txt")
    self:InjectView("party_name")
    self:InjectView("join_btn")

    self:OnClick("join_btn",function()
        service:joinParty(self.data, function()
            delegate.callback(self.data.tag)
        end)
    end)

end

function PartyCell:update(_idx)

    local data = self.model:getOpenPartyDataByIndex(_idx)
    if data and data.party_data then
        self.data = data
        self.user_name:setString(data.name)
        self.num_txt:setString(data.len .. "/" .. data.party_data.need_num)
        self.party_name:setString(data.party_data.name)
        self.party_name:setTextColor(data.color)
    end

    if self.model:getCommanderEntity():isInParty() then
        self.join_btn:setBright(false)
        self.join_btn:setTouchEnabled(false)
    else
        self.join_btn:setBright(true)
        self.join_btn:setTouchEnabled(true)
    end
end

return PartyCell
