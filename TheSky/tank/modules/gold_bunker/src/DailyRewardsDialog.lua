local DailyRewardsDialog = qy.tank.module.BaseUI.class(
    "DailyRewardsDialog",
    "gold_bunker.ui.DailyRewardsDialog",
    qy.tank.module.DialogExt
)

local Model = require("gold_bunker.src.Model")

function DailyRewardsDialog:ctor()
    DailyRewardsDialog.super.ctor(self)

    self.ui.level:setString(qy.TextUtil:substitute(46008) .. Model:getInitData().max_id .. qy.TextUtil:substitute(46009))

    local daily_award = Model:getLevels()[Model:getInitData().max_id].daily_award

    self.ui.Img_reward_1:setVisible(false)
    self.ui.Img_reward_2:setVisible(false)
    self.ui.reward_1:setVisible(false)
    self.ui.reward_2:setVisible(false)

    for i = 1, #daily_award do
        if daily_award[i].type == 20 then
            self.ui.reward_1:setString("x" .. daily_award[i].num)
            self.ui.Img_reward_1:setVisible(true)
            self.ui.reward_1:setVisible(true)
        elseif daily_award[i].type == 42 then
            self.ui.reward_2:setString("x" .. daily_award[i].num)
            self.ui.Img_reward_2:setVisible(true)
            self.ui.reward_2:setVisible(true)
        end
    end
end

function DailyRewardsDialog:onReceive(sender)
    Model:receiveDailyRewards(self.ui.selected == self.ui.CheckBox_1 and 2 or self.ui.selected == self.ui.CheckBox_2 and 5 or 1, function(award)
        self:onDismiss()
        qy.tank.command.AwardCommand:add(award)
        qy.tank.command.AwardCommand:show(award)
    end)
end

function DailyRewardsDialog:onCheckbox(sender)
    self.ui.selected = sender

    if sender ~= self.ui.CheckBox_1 then
        self.ui.CheckBox_1:setSelected(false)
    end
    if sender ~= self.ui.CheckBox_2 then
        self.ui.CheckBox_2:setSelected(false)
    end
    -- 说明什么都没有选择
    if false ==  self.CheckBox_1:isSelected() 
    and false == self.CheckBox_2:isSelected() then
        self.ui.selected = cc.Node:create()
    end
end

return DailyRewardsDialog
