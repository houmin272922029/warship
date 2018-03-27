local ItemList2 = qy.class("ItemList2", qy.tank.view.BaseView, "help.ui.ItemList2")

-- local model = qy.tank.model.AdvanceModel
-- local service = require("help.src.AdvanceService")

function ItemList2:ctor(delegate)
   	ItemList2.super.ctor(self)

   	self:InjectView("Title")
    self:InjectView("Image_1")
    self.Image_1:setSwallowTouches(false)

    -- -- self.Btn_check:setVisible(false)
    -- -- self.fightList = {}

    -- -- self.ResourceNum:setString(qy.tank.model.UserInfoModel.userInfoEntity.advanceMaterial)

   	self:OnClick("Btn_check", function()
        local dialog = require("help.src.DesDialog").new(delegate)
        dialog:render(self.titleContent)
        dialog:show()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
end

function ItemList2:render(title)
	self.Title:setString(title)
  self.titleContent = title
end

return ItemList2
