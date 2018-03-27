local DesList2 = qy.class("DesList2", qy.tank.view.BaseView, "help.ui.DesList2")

-- local model = qy.tank.model.AdvanceModel
-- local service = require("help.src.AdvanceService")

function DesList2:ctor(delegate)
   	DesList2.super.ctor(self)

   	self:InjectView("Title")
    self:InjectView("Icon")
    self:InjectView("Panel_1")
    self.Title:getVirtualRenderer():setMaxLineWidth(350)

    self.Panel_1:setSwallowTouches(false)
    self.Panel_1:setVisible(true)

    self:OnClickForBuilding("Panel_1", function()   --- 注意此处不能使用Onclick  此方法有问题，否则 setSwallowTouches 会失效
        delegate.callBack(delegate.data.id)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
  
    self.h = 130
    self:render(delegate.data)
end

function DesList2:render(data)
    self.Title:setString(data.title3)
    self.Icon:setSpriteFrame("help/res/" .. data.icon  .. ".jpg")
end

return DesList2
