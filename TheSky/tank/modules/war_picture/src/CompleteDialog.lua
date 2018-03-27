local CompleteDialog = qy.class("CompleteDialog", qy.tank.view.BaseDialog, "war_picture.ui.CompleteDialog")


local model = qy.tank.model.WarPictureModel
local service = qy.tank.service.WarPictureService
function CompleteDialog:ctor(delegate)
   	CompleteDialog.super.ctor(self)

   	self:InjectView("Num")

    self:OnClick("Btn_close", function()
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("Btn_buy", function()
        service:complete(function()            
            self:removeSelf()
            delegate:update()
        end)
    end,{["isScale"] = false})


    self.Num:setString(model:getConsume())
end

return CompleteDialog
