local RewardStageCell = qy.class("RewardStageCell", qy.tank.view.BaseView, "inter_service_arena.ui.RewardStageCell")

function RewardStageCell:ctor(delegate)
   	RewardStageCell.super.ctor(self)

    self:InjectView("Img_stage_icon")
    self:InjectView("Img_stage_name")
    self:InjectView("Img_stage_num")
    self:InjectView("Node_1")
    self:InjectView("Node_2")

    self.model = qy.tank.model.InterServiceArenaModel
end

function RewardStageCell:render(data, idx)


    if self.award_7 then
        self.Node_1:removeChild(self.award_7)
    end

    self.award_7 = qy.AwardList.new({
        ["award"] = data["award_7"],
        ["cellSize"] = cc.size(110,180),
        ["type"] = 1,
        ["itemSize"] = 2,
        ["hasName"] = false,
    })
    self.award_7:setPosition(50,230)
    self.Node_1:addChild(self.award_7)



    if self.award_14 then
        self.Node_2:removeChild(self.award_14)
    end

    self.award_14 = qy.AwardList.new({
        ["award"] = data["award_14"],
        ["cellSize"] = cc.size(110,180),
        ["type"] = 1,
        ["itemSize"] = 2,
        ["hasName"] = false,
    })
    self.award_14:setPosition(50,230)
    self.Node_2:addChild(self.award_14)


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

return RewardStageCell
