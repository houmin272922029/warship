local BuyDialog = qy.class("BuyDialog", qy.tank.view.BaseDialog, "war_picture.ui.BuyDialog")


local model = qy.tank.model.WarPictureModel
local service = qy.tank.service.WarPictureService
function BuyDialog:ctor(_type, delegate)
   	BuyDialog.super.ctor(self)

   	self:InjectView("Num")
   	self:InjectView("Times")
    self:InjectView("Type")
    self:InjectView("Type2")

    self:OnClick("Btn_close", function()
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("Btn_buy", function()
        local p = ""
        if _type == "lock" then
          p = "200"
        elseif _type == "reset" then
          p = "100"
        end

        service:pay(function()
            self:update()
            delegate:update()
        end, p)
    end,{["isScale"] = false})

    self.type = _type

    if _type == "lock" then
      self.Num:setString("100")
      self.Type:setString(qy.TextUtil:substitute(90087))
      self.Type2:setString(qy.TextUtil:substitute(90088))
    elseif _type == "reset" then
      self.Num:setString("10")
      self.Type:setString(qy.TextUtil:substitute(90089))
      self.Type2:setString(qy.TextUtil:substitute(90090))
    end

    self:update()
end

function BuyDialog:update()
    local times = 0
    if self.type == "lock" then
      times = model.locking_num
    elseif self.type == "reset" then
      times = model.update_num
    end    

    self.Times:setString(times .. qy.TextUtil:substitute(67009))
end

return BuyDialog
