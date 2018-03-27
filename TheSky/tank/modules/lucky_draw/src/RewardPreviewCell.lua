--[[--

--]]--

local RewardPreviewCell = qy.class("RewardPreviewCell", qy.tank.view.BaseView, "lucky_draw/ui/RewardPreviewCell")

local service = qy.tank.service.LuckyDrawService
local model = qy.tank.model.LuckyDrawModel

function RewardPreviewCell:ctor(delegate)
    RewardPreviewCell.super.ctor(self)
    self.model = qy.tank.model.CombatCastingModel
    self.service = qy.tank.service.CombatCastingService

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


    self.Text:setString(qy.TextUtil:substitute(50011)..idx..qy.TextUtil:substitute(90324))
end



return RewardPreviewCell
