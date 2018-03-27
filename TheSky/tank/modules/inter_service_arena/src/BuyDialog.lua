local BuyDialog = qy.class("BuyDialog", qy.tank.view.BaseDialog, "inter_service_arena.ui.BuyDialog")



function BuyDialog:ctor(callback)
   	BuyDialog.super.ctor(self)

    self.model = qy.tank.model.InterServiceArenaModel
    self.service = qy.tank.service.InterServiceArenaService

   	self:InjectView("Text_consume")

    self:OnClick("Btn_close", function()
        self:dismiss()
    end,{["isScale"] = false})

    self:OnClick("Btn_buy", function()
        self.service:attendnumserver(function(data)
            if data.pay then
                if callback then
                    callback()
                end
                self:dismiss()
            end
        end, 1)
    end,{["isScale"] = false})


    self.Text_consume:setString(self.model.diamond_consume)
end



return BuyDialog
