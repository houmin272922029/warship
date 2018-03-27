local RewardSeasonCell = qy.class("RewardSeasonCell", qy.tank.view.BaseView, "inter_service_arena.ui.RewardSeasonCell")

function RewardSeasonCell:ctor(callback)
   	RewardSeasonCell.super.ctor(self)

    self.model = qy.tank.model.InterServiceArenaModel
    self.service = qy.tank.service.InterServiceArenaService

    self:InjectView("Img_stage_icon")
    self:InjectView("Img_stage_name")
    self:InjectView("Img_stage_num")
    self:InjectView("Node_1")


end

function RewardSeasonCell:render(idx, data)
    self.idx = idx
    local end_award = self.model:getEndAwardByStage(idx)

    if self.award_1 then
        self.Node_1:removeChild(self.award_1)
    end

    self.award_1 = qy.AwardList.new({
        ["award"] = end_award["award"],
        ["cellSize"] = cc.size(115,180),
        ["type"] = 1,
        ["len"] = 4,
        ["itemSize"] = 1,
        ["hasName"] = false,
    })
    self.award_1:setPosition(55,230)
    self.Node_1:addChild(self.award_1)


    local icon, num = self.model:getStageIcon(idx)

    self.Img_stage_icon:loadTexture("inter_service_arena/res/stage_icon_".. icon ..".png",0)
    self.Img_stage_name:loadTexture("inter_service_arena/res/stage_name2_".. icon ..".png",0)

    if num and num > 0 then
        self.Img_stage_num:loadTexture("inter_service_arena/res/stage_num2_".. num ..".png",0)
        self.Img_stage_num:setVisible(true)
        self.Img_stage_name:setPositionX(39 + (3 - num) * 5)
    else
        self.Img_stage_num:setVisible(false)
        self.Img_stage_name:setPositionX(55)
    end





end

return RewardSeasonCell
