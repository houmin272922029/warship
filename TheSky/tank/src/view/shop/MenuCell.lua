--[[
	商店 菜单
	Author: Aaron Wei
	Date: 2015-05-13 16:41:49
]]

local MenuCell = qy.class("MenuCell", qy.tank.view.BaseView, "view/shop/MenuCell")

function MenuCell:ctor(entity)
    MenuCell.super.ctor(self)

    self:InjectView("bg")
end

function MenuCell:render(idx)
    self.bg:loadTexture("Resources/shop/shop_"..idx..".jpg")
end


return MenuCell
