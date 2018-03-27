
local DetailsDialog = qy.class("DetailsDialog", qy.tank.view.BaseDialog, "offer_a_reward.ui.DetailsDialog")

local model = qy.tank.model.OfferARewardModel
local service = qy.tank.service.OfferARewardService
local NumberUtil = qy.tank.utils.NumberUtil
function DetailsDialog:ctor(delegate, data, idx)
    DetailsDialog.super.ctor(self)

    self:InjectView("Text_task_name")
    self:InjectView("Text_task_information")
    self:InjectView("Text_time")
    self:InjectView("Text_reward_num")
    self:InjectView("Text_reward_add")
    self:InjectView("Img_icon")
    self:InjectView("Text_num")

    self:InjectView("Btn_begin")
    self:InjectView("Btn_intelligence")
    self:InjectView("Btn_close")

    self.parent = delegate


    self:OnClick(self.Btn_begin, function()
        service:dispatch(function(_data)
            self.parent:switchTo(2)
            self.parent:update(_data)
            self:removeSelf()
        end, idx-1) 
    end,{["isScale"] = false})

    self:OnClick(self.Btn_intelligence, function()
        service:getInformation(function()            
            local plus = model:getNewList()[idx].plus
            if plus > 0 then
                data.reward_intell_content.plus = plus
                require("offer_a_reward.src.IntelligenceDialog").new(data.reward_intell_content):show()
                self.Text_reward_add:setString("军功奖励加成："..(plus / 10).."%")
                self.Text_reward_add:setVisible(true)
                self.Btn_intelligence:setVisible(false)
                self.parent:update()
            end
        end, idx-1)
    end,{["isScale"] = false})

    self:OnClick(self.Btn_close, function()
        self:removeSelf()
    end,{["isScale"] = false})


    self.Text_task_name:setString(data.reward.title)
    self.Text_task_information:setString(data.reward.content)
    self.Text_time:setString(NumberUtil.secondsToTimeStr(data.reward.time, 3))
    self.Text_reward_num:setString("x "..data.reward.military_exploit)
    if data.plus > 0 then
        self.Text_reward_add:setString("军功奖励加成："..(data.plus / 10).."%")
        self.Text_reward_add:setVisible(true)
        self.Btn_intelligence:setVisible(false)
    end



    if qy.tank.view.type.AwardType.DIAMOND == data.reward_intell_consume.type then
        --钻石
        self.Img_icon:loadTexture(qy.tank.utils.AwardUtils.getSmallDiamond())
    else
        --其他
        self.Img_icon:loadTexture(qy.tank.utils.AwardUtils.getAwardIconByType(data.reward_intell_consume.type))
    end
    self.Text_num:setString("x" .. data.reward_intell_consume.param)
    
end






return DetailsDialog
