--[[--

--]]--

local GouWuCheCell = qy.class("GouWuCheCell", qy.tank.view.BaseView, "coupon_shop/ui/GouWuCheCell")

function GouWuCheCell:ctor(delegate)
    GouWuCheCell.super.ctor(self)
    self.model = qy.tank.model.CouponShopModel
    self.service = qy.tank.service.CouponShopService
    self:InjectView("Num")
    self:InjectView("BG")
    --self.BG:setVisible(false)


   
    self:Init()
    self:render()
end

function GouWuCheCell:Init(  )


end


function GouWuCheCell:render(idx)
    self.Num:setString("1")

end

return GouWuCheCell