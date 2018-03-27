local RewardRiseInRankCell = qy.class("RewardRiseInRankCell", qy.tank.view.BaseView, "inter_service_arena.ui.RewardRiseInRankCell")

function RewardRiseInRankCell:ctor(callback)
   	RewardRiseInRankCell.super.ctor(self)

    self.model = qy.tank.model.InterServiceArenaModel
    self.service = qy.tank.service.InterServiceArenaService

    self:InjectView("Img_stage_icon")
    self:InjectView("Img_stage_name")
    self:InjectView("Img_stage_num")
    self:InjectView("Node_2")
    self:InjectView("Img_receive")
    self:InjectView("Btn_receive")

    self:InjectView("Txt_lingqu")
    self:InjectView("Txt_weidacheng")


    self:OnClick("Btn_receive", function()
        if self.Btn_receive:isBright() then
            self.service:getStageAward(function(data)
                if callback then
                    callback()
                end

                if data.award then
                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award)
                    data.award = nil
                end
            end, 100, self.idx)
        end
    end)

end

function RewardRiseInRankCell:render(idx, data)
    self.idx = idx
    local up_award = self.model:getUpAwardByStage(idx)

    if self.award_2 then
        self.Node_2:removeChild(self.award_2)
    end


    if up_award then
        if self.award_2 then
            self.Node_2:removeChild(self.award_2)
        end

        self.award_2 = qy.AwardList.new({
            ["award"] = up_award["award"],
            ["cellSize"] = cc.size(115,180),
            ["type"] = 1,
            ["len"] = 4,
            ["itemSize"] = 1,
            ["hasName"] = false,
        })
        self.award_2:setPosition(55,230)
        self.Node_2:addChild(self.award_2)
    end


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


    self.Img_receive:setVisible(false)
    self.Btn_receive:setVisible(true)

    if data == 0 and self.model.max_stage <= idx then
        self.Btn_receive:setBright(true)
        self.Txt_weidacheng:setVisible(false)
        self.Txt_lingqu:setVisible(true)
    elseif self.model.max_stage > idx then
        self.Btn_receive:setBright(false)
        self.Txt_weidacheng:setVisible(true)
        self.Txt_lingqu:setVisible(false)
    elseif data == 2 then
        self.Img_receive:setVisible(true)
        self.Btn_receive:setVisible(false)
    end



end

return RewardRiseInRankCell
