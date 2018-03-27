local RewardsDialog = qy.tank.module.BaseUI.class(
    "RewardsDialog",
    "gold_bunker.ui.RewardsDialog",
    qy.tank.module.DialogExt
)

local Model = require("gold_bunker.src.Model")

function RewardsDialog:ctor()
    RewardsDialog.super.ctor(self)
end

-- auto: 自动完成获取奖励时
function RewardsDialog:setData(rewards)
    self.ui.level:setString(Model:getInitData().max_id)
    self.ui.level2:setString(qy.TextUtil:substitute(46015) .. Model:getInitData().max_id .. qy.TextUtil:substitute(46016))

    local awardList = qy.AwardList.new({
        ["award"] = rewards,
        ["len"] = 4,
        ["type"] = 1,
        ["cellSize"] = cc.size(155, 160)
    })

    
    awardList:addTo(self.ui.ScrollView_1)
    local height = math.floor((#rewards - 1) / 4 + 1) * 170
    if height < 340 then
        height = 340
    end
    self.ui.ScrollView_1:setInnerContainerSize(cc.size(690, height))

    awardList:setPosition(100, 780 - (700 - height))

    return self
end

return RewardsDialog