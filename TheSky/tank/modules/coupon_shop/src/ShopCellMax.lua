--[[--
--开服礼包cell
--Author: H.X.Sun
--Date: 2015-06-24
--]]--
local model = qy.tank.model.CouponShopModel

local ShopCellMax = qy.class("ShopCellMax", qy.tank.view.BaseView, "coupon_shop/ui/ShopCellMax")

function ShopCellMax:ctor(delegate)
    ShopCellMax.super.ctor(self)
    self:InjectView("ProjectNode_1")
    self:InjectView("ProjectNode_2")
    self:InjectView("Image_1")
    self:InjectView("Image_2")


    for i = 1,2 do
        self:InjectCustomView("ProjectNode_" .. i, require("coupon_shop/src/ShopCell", {}))
    end
    self:InjectView("Panel_1")


    self.Image_1:setTouchEnabled(true)
    self.Image_1:setSwallowTouches(false)

    self.Image_1:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.began then

            local node = model:GetLastClickItem()
            if node then
                node:UpdateGuangImage(0)
            end
            model:SetLastClickItem( self )
            self:UpdateGuangImage(0)



        elseif eventType == ccui.TouchEventType.moved then

        else
            model:SetClikIndex( self.mClikIndex*2-1 )
            self:UpdateGuangImage(1)
        end
    end)

    self.Image_2:setTouchEnabled(true)
    self.Image_2:setSwallowTouches(false)
    self.Image_2:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.began then


            local node = model:GetLastClickItem()
            if node then
                node:UpdateGuangImage(0)
            end
            model:SetLastClickItem( self )
            self:UpdateGuangImage(0)

        elseif eventType == ccui.TouchEventType.moved then

        else
            self:UpdateGuangImage(2)
            model:SetClikIndex( self.mClikIndex*2 )
        end
    end)

end

function ShopCellMax:render( idx )

    self.mClikIndex = idx
    local data1 = model.mShopCf[idx*2-1]
    local data2 = model.mShopCf[idx*2]
    if data2 == nil or data1 == nil then
        print("data2========nil")
        return
    end

        local a = idx
        print("a========"..a)


    self["ProjectNode_1"]:renderdata(-1,data1)
    self["ProjectNode_2"]:renderdata(-1,data2)
end


function ShopCellMax:UpdateGuangImage(  num  )
    for i = 1,2 do
        self["ProjectNode_"..i]:IsShowguang(false)
    end
    if num > 0 then
        self["ProjectNode_"..num]:IsShowguang(true)
    end

end

return ShopCellMax