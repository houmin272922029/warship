local RewardPointsCell = qy.class("RewardPointsCell", qy.tank.view.BaseView, "inter_service_arena.ui.RewardPointsCell")

function RewardPointsCell:ctor(callback)
   	RewardPointsCell.super.ctor(self)

    self.model = qy.tank.model.InterServiceArenaModel
    self.service = qy.tank.service.InterServiceArenaService

    self:InjectView("Btn_receive")
    self:InjectView("Node_1")
    self:InjectView("Img_num1")
    self:InjectView("Img_num2")
    self:InjectView("Img_receive")

    self:InjectView("Txt_lingqu")
    self:InjectView("Txt_weidacheng")


    self:OnClick("Btn_receive", function()
        if self.Btn_receive:isBright() then
            self.service:getSourceAward(function(data)
                if callback then
                    callback()
                end

                if data.award then
                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award)
                    data.award = nil
                end
            end, 100, self.source)
        end
    end)

end

function RewardPointsCell:render(idx)
    local data = self.model:getScoreAwardByScore(idx)

    if self.award_1 then
        self.Node_1:removeChild(self.award_1)
    end

    self.award_1 = qy.AwardList.new({
        ["award"] = data["award"],
        ["cellSize"] = cc.size(90,180),
        ["type"] = 1,
        ["itemSize"] = 2,
        ["hasName"] = false,
    })
    self.award_1:setPosition(60,225)
    self.Node_1:addChild(self.award_1)

    local source = data["source"]
    self.source = source
    
    local lingqu = self.model.source_award[tostring(source)]
    if source >= 10 then
        self.Img_num1:loadTexture("inter_service_arena/res/".. math.floor(source / 10) .."-".. math.floor(source / 10) ..".png",0)
        self.Img_num1:setVisible(true)
        self.Img_num2:setPositionX(90)
    else
        self.Img_num1:setVisible(false)
        self.Img_num2:setPositionX(75)
    end

    self.Img_num2:loadTexture("inter_service_arena/res/".. math.floor(source % 10) .."-".. math.floor(source % 10) ..".png",0)


    self.Img_receive:setVisible(false)
    self.Btn_receive:setVisible(true)

    if lingqu == 0 and self.model.source >= source then
        self.Btn_receive:setBright(true)
        self.Txt_weidacheng:setVisible(false)
        self.Txt_lingqu:setVisible(true)
    elseif self.model.source < source then
        self.Btn_receive:setBright(false)
        self.Txt_weidacheng:setVisible(true)
        self.Txt_lingqu:setVisible(false)
    elseif lingqu == 2 then
        self.Img_receive:setVisible(true)
        self.Btn_receive:setVisible(false)
    end

end

return RewardPointsCell
