local awardCell = qy.class("awardCell", qy.tank.view.BaseView, "searchTreasure.ui.awardCell")

local model = qy.tank.model.OperatingActivitiesModel
function awardCell:ctor(delegate)
   	awardCell.super.ctor(self)
   	self.delegate = delegate
   	self.ItemList = {}
end

function awardCell:setData(data, idx)
	self:removeAllChildren()
	self.ItemList = {}
	local awardData = data.timesAwardList
	for i=1, 3 do
		if awardData[idx * 3 + i] then
			if not tolua.cast(self.ItemList[tostring(i)],"cc.Node") then
				local item = qy.tank.view.common.AwardItem.createAwardView(awardData[idx * 3 + i] ,1)
			    self:addChild(item)
			    self.ItemList[tostring(i)] = item
			    self.ItemList[tostring(i)]:setPosition(-23 + 150 * ( (i > 4) and (i - 5) or (i) ), 55)
		    	self.ItemList[tostring(i)]:setScale(1)
		    	self.ItemList[tostring(i)].name:setVisible(false)
			else
				self.ItemList[tostring(i)]:setData(qy.tank.view.common.AwardItem.getItemData(awardData[idx * 3 + i]))
			end
		end
	    
	end
end
return awardCell