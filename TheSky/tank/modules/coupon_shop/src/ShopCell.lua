--[[--
	
--]]--

local ShopCell = qy.class("ShopCell", qy.tank.view.BaseView, "coupon_shop/ui/ShopCell")
local model = qy.tank.model.CouponShopModel

function ShopCell:ctor(delegate)
    ShopCell.super.ctor(self)
    self:InjectView("ConNum_0")
    self:InjectView("bg")
    self:InjectView("guang")
    self:InjectView("ConNum")
    self:InjectView("Node_1")
    self:InjectView("Image_23")
    self:InjectView("Sprite_2")
    self:InjectView("Sprite_1")
    self:InjectView("closebtn")
    self:InjectView("Day")

   
	self.guang:setVisible( false )
	self.closebtn:setVisible( false )

	self:OnClick("closebtn", function()
        model:RemoveGwcDataInid( self.closeIndex )
        model:GetModleMainlayer():UpdateTableViewInAll()
    end,{["isScale"] = false})



end

function ShopCell:renderdata(num, data)

    if data == nil then
        print("ShopCellsssssssss---nil")
        return
    end
	self.data = data
	self.ConNum_0:setString(self.data["buy_num"])
	if model:GetAtType() == 1 then
		self.ConNum:setString(self.data["diamond_num"])
		self.Sprite_1:setVisible(true)
		self.Sprite_2:setVisible(false)
	else
		self.ConNum:setString(self.data["shop_card_num"])

		self.Sprite_1:setVisible(false)
		self.Sprite_2:setVisible(true)
	end

	--self.ConNum:setString(self.data["id"])
	self.Day:setString("可购买数量")

	self:ShowItem( self.data )
end
function ShopCell:ShowItem( data )
	local itmedata = {}
	itmedata.type = data.shop_type
	itmedata.num = data.max_buy_limit
	itmedata.id = data.shop_id
	if itmedata.type == 41 then
		itmedata.type = 42
	end



    if self.mitem == nil then
	 	local item = qy.tank.view.common.AwardItem.createAwardView(itmedata ,1)
	  	item:setPosition(self.Node_1:getPosition())
	  	item:setScale(0.5)
	  	item.fatherSprite:setSwallowTouches(false)
	  	self.mitem = item
        item.name:setVisible(false)
        if item then
	  		self.bg:addChild(item)
	  	end
    end
end

function ShopCell:render(data,index)
	self.closeIndex = index

	self.ConNum_0:setString("1")
	if model:GetAtType() == 1 then
		self.ConNum:setString(data["diamond_num"])
		self.Sprite_1:setVisible(true)
		self.Sprite_2:setVisible(false)
	else
		self.ConNum:setString(data["shop_card_num"])
		self.Sprite_1:setVisible(false)
		self.Sprite_2:setVisible(true)
	end
	self.Day:setString("当前购买数量")
	self.closebtn:setVisible(true)
	self:ShowItem( data )
	--self.ConNum:setString(data["id"])

end


function ShopCell:IsShowguang( visbile )
	self.guang:setVisible( visbile )
end
return ShopCell