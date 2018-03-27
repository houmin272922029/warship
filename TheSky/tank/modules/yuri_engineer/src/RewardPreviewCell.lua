--[[--

--]]--

local RewardPreviewCell = qy.class("RewardPreviewCell", qy.tank.view.BaseView, "yuri_engineer/ui/RewardPreviewCell")

local _moduleType = qy.tank.view.type.ModuleType.PAY_REBATE_VIP

function RewardPreviewCell:ctor(delegate)
    RewardPreviewCell.super.ctor(self)

    self:InjectView("bg")
    self:InjectView("Text")

end




function RewardPreviewCell:render(data, idx)
    self.idx = idx
    if self.awardList then
        self.bg:removeChild(self.awardList)
    end

    self.awardList = qy.AwardList.new({
        ["award"] = data.award,
        ["hasName"] = true,
        ["cellSize"] = cc.size(120,180),
        ["type"] = 1,
        ["itemSize"] = 2,
    })
    self.awardList:setPosition(150,250)
    self.bg:addChild(self.awardList)

    if data.rank_min == data.rank_max then
        self.Text:setString("第"..data.rank_min.."名奖励")
    else
        self.Text:setString("第"..data.rank_min.."~"..data.rank_max.."名奖励")
    end
end



return RewardPreviewCell
