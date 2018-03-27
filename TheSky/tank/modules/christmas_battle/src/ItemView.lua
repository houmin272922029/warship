--[[
	
]]

local ItemView = qy.class("ItemView", qy.tank.view.BaseDialog, "christmas_battle.ui.ItemView")

function ItemView:ctor()
   self.model = qy.tank.model.ChristmasBattleModel
   self.service = qy.tank.service.ChristmasBattleService
   for i=1,4 do
        self:InjectView("Text_"..i)
   end





end

function ItemView:render(data,type_id,id)--id 从1 开始
	self.Text_4:setVisible(type_id ~= 3)
	self.Text_3:setVisible(type_id == 3)
    if type_id == 1 then
    	if data ~= nil then
	    	for i=1,3 do
	    		self["Text_"..i]:removeAllChildren(true)
	    	end
	    	self.Text_1:setString(data.rank)
	    	self.Text_2:setString(data.nickname)
	    	self.Text_4:setString(data.hurt)
    	end
    elseif type_id == 2 then
    	print("22222item")
    	if data ~= nil then
	    	for i=1,3 do
	    		self["Text_"..i]:removeAllChildren(true)
	    	end
	    	self.Text_1:setString(data.rank)
	    	self.Text_2:setString(data.nickname)
	    	self.Text_4:setString(data.hurt)
    	end
    elseif type_id == 3 then
    	self.Text_3:removeAllChildren(true)
    	local data = self.model:getAward(id)
    	self.Text_1:setString(tostring(data[1].range))
    	self.Text_2:setString(tostring(data[1].limit / 10).."%")

    	local item = qy.tank.view.common.AwardItem.createAwardView(data[1].award[1] ,1)
        self.Text_3:addChild(item)
        item:setScale(0.5)
        item.fatherSprite:setSwallowTouches(false)
        item.name:setVisible(false)
    end
end

return ItemView

