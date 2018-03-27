local RewardsPreviewItem = qy.tank.module.BaseUI.class("RewardsPreviewItem", "gold_bunker.ui.RewardsPreviewItem")

local Model = require("gold_bunker.src.Model")

function RewardsPreviewItem:ctor()
    RewardsPreviewItem.super.ctor(self)

    local levelLabel = ccui.TextAtlas:create("300", "gold_bunker/fx/rewards_number.png", 30, 28, '0')
    levelLabel:setAnchorPoint(1, 0.5)
    levelLabel:setPosition(5, qy.language == "cn" and 25 or 33)
    levelLabel:addTo(self.ui.level_rewards)

    self.ui.label = levelLabel

    local awardList = qy.AwardList.new({
        ["award"] = {},
        ["type"] = 1
    })
    awardList:setPosition(100, 280)
    awardList:addTo(self.ui.Image_3)

    self.ui.awardList = awardList
end

function RewardsPreviewItem:setIdx(idx)
    local reward = Model:getRewards()[idx + 1]
    self.ui.label:setString(reward.id)

    self.ui.awardList:update(reward.award)
end

local Cell = class("Cell", cc.TableViewCell)

function Cell:ctor()
    self._item = RewardsPreviewItem.new()
    self._item:addTo(self)
end

function Cell:setIdx(idx)
    self._item:setIdx(idx)
    return self
end

return Cell
