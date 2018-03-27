local ItemView = qy.class("ItemView", qy.tank.view.BaseView, "grouppurchase.ui.ItemView")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
local userInfoEntity = qy.tank.model.UserInfoModel.userInfoEntity
local aType = qy.tank.view.type.ModuleType

function ItemView:ctor(delegate)
   	ItemView.super.ctor(self)
   	self:InjectView("Text_1")
   	self:InjectView("Text_2")
   	self:InjectView("Text_3")
   	self:InjectView("Text_4")
   	self:InjectView("Button_1")

   	self:OnClick("Button_1", function()
   			if (userInfoEntity.vipLevel >= self.vip_limit) then
				service:getGroupPurchase(
	                self.idx,function(reData)
	                    self:update(reData.goodlist)
	            end)
	        else
	        	qy.hint:show(qy.TextUtil:substitute(90032))
	        end
    end,{["isScale"] = false})
end

function ItemView:update(Goodlist)
	local goodlist = Goodlist[self.idx..""]
	self.Text_1:setString(goodlist.title)
	self.Text_3:setString("VIP" .. goodlist.vip_limit .." "..qy.TextUtil:substitute(90033))
	self.vip_limit = goodlist.vip_limit
	self.Text_4:setString("×" .. goodlist.number)
	self.LimitNum = goodlist.number
	local Type = goodlist.shop_type
	if Type == 1 then
		self.Text_2:setString(qy.TextUtil:substitute(90029) .. goodlist.num)
	elseif Type == 2 then
		self.Text_2:setString(qy.TextUtil:substitute(90030) .. goodlist.remain.."/"..goodlist.num)
	elseif Type == 3 then
		self.Text_2:setString(qy.TextUtil:substitute(90031))
	end
	self.Button_1:setEnabled(goodlist.status ~= 300)
	self.Text_4:setColor(goodlist.status == 300 and cc.c3b(220, 220, 220) or cc.c3b(255, 255, 0))
end

function ItemView:setData(data,idx)
	self.idx = idx
	local goodlist = model.goodlist[idx..""]
	self.Text_1:setString(goodlist.title)
	self.Text_3:setString("VIP" .. goodlist.vip_limit .." "..qy.TextUtil:substitute(90033))
	self.vip_limit = goodlist.vip_limit
	self.Text_4:setString("×" .. goodlist.number)
	self.LimitNum = goodlist.number
	local Type = goodlist.shop_type
	if Type == 1 then
		self.Text_2:setString(qy.TextUtil:substitute(90029) .. goodlist.num)
	elseif Type == 2 then
		self.Text_2:setString(qy.TextUtil:substitute(90030) .. goodlist.remain.."/"..goodlist.num)
	elseif Type == 3 then
		self.Text_2:setString(qy.TextUtil:substitute(90031))
	end
	

	local awardData = goodlist.award
	self.Button_1:setEnabled(goodlist.status ~= 300)
	self.Text_4:setColor(goodlist.status == 300 and cc.c3b(220, 220, 220) or cc.c3b(255, 255, 0))
	self.Text_1:removeAllChildren()
	
	for i=1,#awardData do
		local item = qy.tank.view.common.AwardItem.createAwardView(awardData[i] ,1)
	    self.Text_1:addChild(item)
	    item:setPosition(35 + 90*(i - 1), -62)
	    item:setScale(0.75)
	    item.name:setVisible(false)
	end
end


return ItemView