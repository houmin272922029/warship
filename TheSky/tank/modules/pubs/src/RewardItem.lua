--[[
--成就
--Author: mingming
--Date:
]]

local RewardItem = qy.class("RewardItem", qy.tank.view.BaseView, "pubs.ui.RewardItem")

function RewardItem:ctor(delegate)
    RewardItem.super.ctor(self)
    -- self.delegate = delegate

    self:InjectView("GetReward")
    -- self:InjectView("Name")
    self:InjectView("Times")
    self:InjectView("HadGot")
    -- self:InjectView("Num")
    -- self:InjectView("Award")


    self:OnClick("GetReward", function()
        if self.entity.status == 1 then
            delegate.onReward(self.entity, function()
                self:update()
            end)
        elseif self.entity.status == 2 then
            qy.hint:show(qy.TextUtil:substitute(59010))
        elseif self.entity.status == 0 then
            qy.hint:show(qy.TextUtil:substitute(59011))
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
end

function RewardItem:setData(data, idx)
	self.Times:setString(qy.TextUtil:substitute(59012) .. data.times)
    self.entity = data

    for i, v in pairs(data.award) do
        if not self["item" .. i] then
            local item = qy.tank.view.common.AwardItem.createAwardView(v, 1)
            self:addChild(item)
            item:setPosition(120 * i + 160, 85)
            item:setScale(0.824)
            self["item" .. i] = item
        else
            self["item" .. i]:setData(qy.tank.view.common.AwardItem.getItemData(v))
        end
    end

    self:update()
end

function RewardItem:update()
    self.GetReward:setBright(self.entity.status == 1)

    if self.entity.status == 2 then
        self.HadGot:setVisible(true)
        self.GetReward:setVisible(false)
    else
        self.HadGot:setVisible(false)
        self.GetReward:setVisible(true)
    end
end

return RewardItem