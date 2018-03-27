--[[
	宴会详情item
	Author: H.X.Sun
]]

local PartyItem = qy.class("PartyItem", qy.tank.view.BaseView,"legion/ui/club/PartyItem")

function PartyItem:ctor(delegate)
    PartyItem.super.ctor(self)
    self.model = qy.tank.model.LegionModel
    local userModel = qy.tank.model.UserInfoModel
    local service = qy.tank.service.LegionService
    local NumberUtil = qy.tank.utils.NumberUtil
    self:InjectView("party_icon")
    self:InjectView("party_name")
    self:InjectView("get_num")
    self:InjectView("cost_num")
    self:InjectView("desc_txt")
    self:InjectView("cost_coin")

    local data = self.model:getPartyDescByIdx(delegate.idx)
    local url = "legion/res/club/party_icon_"..data.tag .. ".png"
    if cc.SpriteFrameCache:getInstance():getSpriteFrame(url) then
        self.party_icon:setSpriteFrame(url)
    end
    self.party_name:setString(data.name)
    self.party_name:setTextColor(self.model:getColorByIdx(1,data.tag))
    self.get_num:setString(qy.InternationalUtil:getResNumString(data.money * userModel.userInfoEntity.level))
    if data.cost_num == 0 then
        self.cost_num:setString(qy.TextUtil:substitute(51031))
        self.cost_num:setPosition(self.cost_coin:getPosition())
        self.cost_coin:setVisible(falses)
    else
        self.cost_num:setString(data.cost_num)
        self.cost_num:setVisible(true)
    end
    self.desc_txt:setString(qy.TextUtil:substitute(51032, data.legion_exp))

    self:OnClick("open_btn",function()
        if self.model:getPartyTimes() > 0 then
            service:createParty(delegate.idx,function()
                qy.hint:show(qy.TextUtil:substitute(51034))
                delegate.callback()
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(51035))
        end
    end)

end

return PartyItem
