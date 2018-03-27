local RewardStageCell_1 = qy.class("RewardStageCell_1", qy.tank.view.BaseView, "inter_service_arena.ui.RewardStageCell_1")

function RewardStageCell_1:ctor(callback)
   	RewardStageCell_1.super.ctor(self)

    self:InjectView("Img_stage_icon_1")
    self:InjectView("Img_stage_name_1")
    self:InjectView("Img_stage_num_1")
    self:InjectView("Img_receive_1")
    self:InjectView("Btn_receive_1")
    self:InjectView("Txt_lingqu_1")
    self:InjectView("Txt_weidacheng_1")


    self:InjectView("Img_stage_icon_2")
    self:InjectView("Img_stage_name_2")
    self:InjectView("Img_stage_num_2")
    self:InjectView("Img_receive_2")
    self:InjectView("Btn_receive_2")
    self:InjectView("Txt_lingqu_2")
    self:InjectView("Txt_weidacheng_2")
    

    self:InjectView("Node_1")
    self:InjectView("Node_2")
    self:InjectView("Text_day_1")
    self:InjectView("Text_day_2")


    self.model = qy.tank.model.InterServiceArenaModel
    self.service = qy.tank.service.InterServiceArenaService




    -- for i = 1, 2 do
    --     self:OnClick("Btn_receive_"..i, function()
    --         if self["Btn_receive_"..i]:isBright() then
    --             self.service:getDayAward(function(data)
    --                 if callback then
    --                     callback()
    --                 end

    --                 if data.award then
    --                     qy.tank.command.AwardCommand:add(data.award)
    --                     qy.tank.command.AwardCommand:show(data.award)
    --                     data.award = nil
    --                 end
    --             end, i * 7)
    --         end
    --     end,{["isScale"] = false})
    -- end 
    --哎我偏不这么写，任性


    self:OnClick("Btn_receive_1", function()
        if self.Btn_receive_1:isBright() then
            self.service:getDayAward(function(data)
                if callback then
                    callback()
                end

                if data.award then
                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award)
                    data.award = nil
                end
            end, 7)
        end
    end,{["isScale"] = false})


    self:OnClick("Btn_receive_2", function()
        if self.Btn_receive_2:isBright() then
            self.service:getDayAward(function(data)
                if callback then
                    callback()
                end

                if data.award then
                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award)
                    data.award = nil
                end
            end, 14)
        end
    end,{["isScale"] = false})


end





function RewardStageCell_1:render()
    self.day_7_stage = self.model.day_7_stage == 0 and self.model.stage_num or self.model.day_7_stage
    self.day_14_stage = self.model.day_14_stage == 0 and self.model.stage_num or self.model.day_14_stage
    local data_7 = self.model:getStageAwardByStage(self.day_7_stage)
    local data_14 = self.model:getStageAwardByStage(self.day_14_stage)

    if self.award_7 then
        self.Node_1:removeChild(self.award_7)
    end

    self.award_7 = qy.AwardList.new({
        ["award"] = data_7["award_7"],
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
        ["award"] = data_14["award_14"],
        ["cellSize"] = cc.size(110,180),
        ["type"] = 1,
        ["itemSize"] = 2,
        ["hasName"] = false,
    })
    self.award_14:setPosition(50,230)
    self.Node_2:addChild(self.award_14)

    local day = self.model:getTime()

    
    self.Text_day_2:setString(day)


    function function1()
        self.Img_receive_1:setVisible(false)
        self.Btn_receive_1:setVisible(true)

        if self.model.day_7_get == 1 and tonumber(day) >= 7 then
            self.Btn_receive_1:setBright(true)
            self.Txt_weidacheng_1:setVisible(false)
            self.Txt_lingqu_1:setVisible(true)
        elseif tonumber(day) < 7 or self.model.day_7_get == 0 then
            self.Btn_receive_1:setBright(false)
            self.Txt_weidacheng_1:setVisible(true)
            self.Txt_lingqu_1:setVisible(false)
        elseif self.model.day_7_get == 2 then
            self.Img_receive_1:setVisible(true)
            self.Btn_receive_1:setVisible(false)
        end

        local icon, num = self.model:getStageIcon(self.day_7_stage)

        self.Img_stage_icon_1:loadTexture("inter_service_arena/res/stage_icon_".. icon ..".png",0)
        self.Img_stage_name_1:loadTexture("inter_service_arena/res/stage_name2_".. icon ..".png",0)
        if num and num > 0 then
            self.Img_stage_num_1:loadTexture("inter_service_arena/res/stage_num2_".. num ..".png",0)
            self.Img_stage_num_1:setVisible(true)
            self.Img_stage_name_1:setPositionX(39)
        else
            self.Img_stage_num_1:setVisible(false)
            self.Img_stage_name_1:setPositionX(55)
        end

        self.Text_day_1:setString((tonumber(day) > 7 and "7" or tonumber(day)).." / 7")

    end


    function  function2()
        self.Img_receive_2:setVisible(false)
        self.Btn_receive_2:setVisible(true)

        if self.model.day_14_get == 1 and tonumber(day) >= 14 then
            self.Btn_receive_2:setBright(true)
            self.Txt_weidacheng_2:setVisible(false)
            self.Txt_lingqu_2:setVisible(true)
        elseif tonumber(day) < 14 or self.model.day_14_get == 0 then
            self.Btn_receive_2:setBright(false)
            self.Txt_weidacheng_2:setVisible(true)
            self.Txt_lingqu_2:setVisible(false)
        elseif self.model.day_14_get == 2 then
            self.Img_receive_2:setVisible(true)
            self.Btn_receive_2:setVisible(false)
        end


        local icon, num = self.model:getStageIcon(self.day_14_stage)

        self.Img_stage_icon_2:loadTexture("inter_service_arena/res/stage_icon_".. icon ..".png",0)
        self.Img_stage_name_2:loadTexture("inter_service_arena/res/stage_name2_".. icon ..".png",0)
        if num and num > 0 then
            self.Img_stage_num_2:loadTexture("inter_service_arena/res/stage_num2_".. num ..".png",0)
            self.Img_stage_num_2:setVisible(true)
            self.Img_stage_name_2:setPositionX(39)
        else
            self.Img_stage_num_2:setVisible(false)
            self.Img_stage_name_2:setPositionX(55)
        end

        self.Text_day_2:setString((tonumber(day) > 14 and "14" or tonumber(day)).."/14")
    end

    function1()
    function2()
end



return RewardStageCell_1
