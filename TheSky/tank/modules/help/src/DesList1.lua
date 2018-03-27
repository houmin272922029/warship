local DesList1 = qy.class("DesList1", qy.tank.view.BaseView, "help.ui.DesList1")

-- local model = qy.tank.model.AdvanceModel
-- local service = require("help.src.AdvanceService")

function DesList1:ctor(delegate)
   	DesList1.super.ctor(self)

   	self:InjectView("Title")
    self.Title:getVirtualRenderer():setMaxLineWidth(540)
    self:InjectView("Line1")

    -- -- -- self.Btn_check:setVisible(false)
    -- -- -- self.fightList = {}

    -- -- -- self.ResourceNum:setString(qy.tank.model.UserInfoModel.userInfoEntity.advanceMaterial)

   	-- self:OnClickForBuilding("Panel_1", function()
    --     delegate.callBack(delegate.data.id)
    -- end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
    -- self.h = 60

    self:render(delegate.data)
end

function DesList1:render(data)
	 self.Title:setString(data.title3)

   self.Line1:setPositionY(self.Title:getContentSize().height + 20)
   self.h = self.Title:getContentSize().height + 25
end

return DesList1
