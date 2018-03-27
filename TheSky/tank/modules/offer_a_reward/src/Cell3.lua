local Cell3 = qy.class("Cell3", qy.tank.view.BaseView, "offer_a_reward.ui.Cell3")

local model = qy.tank.model.OfferARewardModel
function Cell3:ctor()
   	Cell3.super.ctor(self)

    self:InjectView("Text_task_name")
    self:InjectView("Text_military_exploit")
    
end

function Cell3:render(data)
    data.reward = model:getRewardById(data.id)
    data.reward_intell_content = model:getRewardContent()
    data.reward_intell_consume = model:getRewardConsumeById(data.information_id)
    
    self.Text_task_name:setString(data.reward.title)
    self.Text_military_exploit:setString("x "..data.military_exploit)

    if data.reward.quality == 1 then
        self.Text_task_name:setColor(cc.c3b(255, 255, 255))
    elseif data.reward.quality == 2 then
        self.Text_task_name:setColor(cc.c3b(46, 190, 83))
    elseif data.reward.quality == 3 then
        self.Text_task_name:setColor(cc.c3b(36, 174, 242))
    elseif data.reward.quality == 4 then
        self.Text_task_name:setColor(cc.c3b(172, 54, 249))
    elseif data.reward.quality == 5 then
        self.Text_task_name:setColor(cc.c3b(255, 153, 0))
    end
end

return Cell3