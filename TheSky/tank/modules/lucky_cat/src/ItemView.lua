local ItemView = qy.class("ItemView", qy.tank.view.BaseView, "lucky_cat.ui.ItemView")

function ItemView:ctor(delegate)
   	ItemView.super.ctor(self)

   	self:InjectView("Name")
   	self:InjectView("Num")   	
end

function ItemView:setData(data)
	self.data = data
	self.Name:setString(data.nickname)
	self.Num:setString(data.num)
end


return ItemView
