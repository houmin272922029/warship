--[[--
--]]--


local AwardDialog = qy.class("AwardDialog", qy.tank.view.BaseAwardDialog, "battlefield_store/ui/AwardDialog")

function AwardDialog:ctor(delegate)
    AwardDialog.super.ctor(self)

    self.model = qy.tank.model.BattleFieldStoreModel
    self.service = qy.tank.service.BattleFieldStoreService

    self:InjectView("Btn_close")
    self:InjectView("Node1")
    self:InjectView("Node2")

	self:OnClick(self.Btn_close, function(sender)
        self:removeSelf()
    end,{["isScale"] = false})


    self.award_1 = qy.AwardList.new({
        ["award"] = data["award"],
        ["cellSize"] = cc.size(90,180),
        ["type"] = 1,
        ["itemSize"] = 2,
        ["hasName"] = false,
    })
    self.award_1:setPosition(60,225)
    self.Node1:addChild(self.award_1)




    self.award_2 = qy.AwardList.new({
        ["award"] = data["award"],
        ["cellSize"] = cc.size(90,180),
        ["type"] = 1,
        ["itemSize"] = 2,
        ["hasName"] = false,
    })
    self.award_2:setPosition(60,225)
    self.Node2:addChild(self.award_2)

end





return AwardDialog