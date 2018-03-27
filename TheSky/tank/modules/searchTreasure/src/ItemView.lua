local ItemView = qy.class("ItemView", qy.tank.view.BaseView, "searchTreasure.ui.ItemView")

local model = qy.tank.model.OperatingActivitiesModel
function ItemView:ctor(delegate)
   	ItemView.super.ctor(self)
   	self.delegate = delegate
   	self:InjectView("Image_1")
   	self:InjectView("Text_1")
   	self:InjectView("Text_2")
   	

end

function ItemView:setData(data)
	self.Image_1:removeAllChildren()

	local awardData = data.rankAwardList
	for i=1, #awardData do
		local item = qy.tank.view.common.AwardItem.createAwardView(awardData[i] ,1)
	    self:addChild(item)
	    item:setPosition(200 + 110 * i, 60)
	    item:setScale(0.8)
	    item.name:setVisible(false)
	end

	local idx = data.rank
   	if model.searchRankList[idx] then
   		self.Text_1:setString(model.searchRankList[idx].nickname.."   "..qy.TextUtil:substitute(51007, model.searchRankList[idx].rank))
    	self.Text_2:setString(model.searchRankList[idx].cost)
    else
    	self.Text_1:setString(qy.TextUtil:substitute(51007, idx))
    	self.Text_2:setString(qy.TextUtil:substitute(40031))
   	end
end
return ItemView