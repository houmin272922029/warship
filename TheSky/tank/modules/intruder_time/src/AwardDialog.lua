--[[--
--]]--


local AwardDialog = qy.class("AwardDialog", qy.tank.view.BaseDialog, "intruder_time/ui/AwardDialog")

function AwardDialog:ctor(delegate)
    AwardDialog.super.ctor(self)

    self.model = qy.tank.model.IntruderTimeModel

    self:InjectView("Btn_close")
    self:InjectView("Node1")
    self:InjectView("Node2")

	self:OnClick(self.Btn_close, function(sender)
        self:removeSelf()
    end,{["isScale"] = false})


    self.award_1 = qy.AwardList.new({
        ["award"] = self.model.monster_list[self.model.intruder.id].award1,
        ["cellSize"] = cc.size(120,180),
        ["type"] = 1,
        ["itemSize"] = 1,
        ["len"] = 4,
        ["hasName"] = false,
    })
    self.award_1:setPosition(30,225)
    self.Node1:addChild(self.award_1)



    self.award_2 = qy.AwardList.new({
        ["award"] = self.model.monster_list[self.model.intruder.id].award2,
        ["cellSize"] = cc.size(120,180),
        ["type"] = 1,
        ["itemSize"] = 1,
        ["len"] = 4,
        ["hasName"] = false,
    })
    self.award_2:setPosition(30,225)
    self.Node2:addChild(self.award_2)

end





return AwardDialog