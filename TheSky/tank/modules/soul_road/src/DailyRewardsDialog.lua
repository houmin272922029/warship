local DailyRewardsDialog = qy.tank.module.BaseUI.class(
    "DailyRewardsDialog",
    "soul_road.ui.DailyRewardsDialog",
    qy.tank.module.DialogExt
)

local Model = qy.tank.model.SoulRoadModel
local service = qy.tank.service.SoulRoadService

function DailyRewardsDialog:ctor()
    DailyRewardsDialog.super.ctor(self)

    local entity = Model:atCheckpoint(Model.complete)
    self.ui.level:setString(qy.TextUtil:substitute(67011) .. Model.complete .. qy.TextUtil:substitute(67012))
    self.ui.reward:setString("x" .. entity.daily_award[1].num)
end

function DailyRewardsDialog:onReceive(sender)
    if Model.is_draw_daily_award ~= 1 then
        service:drawAward(self.ui.selected == self.ui.CheckBox_1 and 2 or self.ui.selected == self.ui.CheckBox_2 and 5 or 1, function(award)
            self:onDismiss()
            qy.tank.command.AwardCommand:add(award)
            qy.tank.command.AwardCommand:show(award)
        end)
    else
        qy.hint:show(qy.TextUtil:substitute(67013))
    end
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
