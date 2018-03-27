--[[--
	
--]]--

local ShangChengCellMax = qy.class("ShangChengCellMax", qy.tank.view.BaseView, "legion_generaltion/ui/ShangChengCellMax")

function ShangChengCellMax:ctor(delegate)
    ShangChengCellMax.super.ctor(self)


    self.model = qy.tank.model.LegionGeneraltionModel

    for i = 1,3 do
		self:InjectCustomView("ProjectNode_" .. i, require("legion_generaltion/src/ShangChengCell", {}))
    end

end


function ShangChengCellMax:render(idx, _sdata )

	local data1,data2,data3 = nil
	local _num = idx * 3
	if _sdata.mIndexShop == 1 then
		data1 = self.model.DiamondShop[_num-2]
		data2 = self.model.DiamondShop[_num-1]
		data3 = self.model.DiamondShop[_num]
	else
		data1 = self.model.BuyShop[_num-2]
		data2 = self.model.BuyShop[_num-1]
		data3 = self.model.BuyShop[_num]
	end


	if data1 then
		self["ProjectNode_1"]:setVisible(true)
		self["ProjectNode_1"]:render(_sdata,data1)
	else
		self["ProjectNode_1"]:setVisible(false)
	end
	if data2 then
		self["ProjectNode_2"]:setVisible(true)
		self["ProjectNode_2"]:render(_sdata,data2)
	else
		self["ProjectNode_2"]:setVisible(false)

	end
	if data3 then
		self["ProjectNode_3"]:setVisible(true)
		self["ProjectNode_3"]:render(_sdata,data3)
	else
		self["ProjectNode_3"]:setVisible(false)
	end



	-- self.Sprite_1:setVisible(false)
 --    self.ConNum:setString("")
 --    self.Day:setString("第"..idx.."天")

 --    if self.mitem == nil then
	--  	local item = qy.tank.view.common.AwardItem.createAwardView(data ,1)
	--   	item:setPosition(self.Sprite_1:getPosition())
	--   	item:setScale(0.7)
	--   	item.fatherSprite:setSwallowTouches(false)
	--   	item.name:setVisible(false)
	--   	self.bg:addChild(item)
	--   	self.mitem = item
	-- end

end
function ShangChengCellMax:SetBgCentSize(size)
    --self.bg:setString("cc")
end
return ShangChengCellMax