local Cell2 = qy.class("Cell2", qy.tank.view.BaseView, "offer_a_reward.ui.Cell2")

local model = qy.tank.model.OfferARewardModel
function Cell2:ctor()
   	Cell2.super.ctor(self)

    self:InjectView("Text_task_name")
    self:InjectView("Text_num")
    self:InjectView("Img_complete")
    
end

function Cell2:render(data)
    data.reward = model:getRewardById(data.id)

    self.Text_task_name:setString(model:getRewardById(data.id).title)

    if data.times == 1 then
        self.Img_complete:loadTexture("offer_a_reward/res/8.png", 0)
    else
        self.Img_complete:loadTexture("offer_a_reward/res/9.png", 0)
    end

    self.Text_num:setString("x "..data.military_exploit)

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

return Cell2