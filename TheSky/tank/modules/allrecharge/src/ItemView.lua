local ItemView = qy.class("ItemView", qy.tank.view.BaseView, "allrecharge.ui.ItemView")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
function ItemView:ctor(delegate)
   	ItemView.super.ctor(self)
   	self:InjectView("Image_2")
   	self:InjectView("Button_1")
   	self:InjectView("Sprite_9")
   	self.delegate = delegate

   	self:OnClick("Button_1", function()
   		local aType = qy.tank.view.type.ModuleType
   			service:getCommonGiftAward({
                ["type"] = self.awardType,
                ["id"] = self.data.id,
                ["activity_name"] = aType.ALL_RECHARGE
            }, aType.ALL_RECHARGE,false, function(reData)
                self:update()
        	end)
   	end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
end

function ItemView:update()
	if table.keyof(model.award_list[tostring(self.awardType)], self.data.id) == nil then
		self.Button_1:setEnabled(true)
	else
		self.Sprite_9:setVisible(true)
    	self.Button_1:setVisible(false)
	end
end

function ItemView:setData(data, awardType)
	self.awardType = awardType == "recharge_award" and 2 or 1
	self.data = data
	local awardData = data[awardType]

	self.Image_2:removeAllChildren()
	print("数据",json.encode(awardData))
	for i=1,#awardData do
		local item = qy.tank.view.common.AwardItem.createAwardView(awardData[i] ,1)
	    self.Image_2:addChild(item)
	    item:setPosition(70 + 120*(i - 1), 60)
	    item:setScale(0.8)
	    item.name:setVisible(false)
	end

	self.richText = ccui.RichText:create()
	self.richText:setPosition(self.Image_2:getContentSize().width/2 + 20, 115)
	self.richText:setAnchorPoint(0.5, 0.5)
	self.richText:ignoreContentAdaptWithSize(false)
    self.richText:setContentSize(cc.size(500, 50))
    
    local num = data.num

	local info1 = self:makeText(qy.TextUtil:substitute(90003), cc.c3b(224, 222, 187))
    local info2 = self:makeText(num, cc.c3b(240, 79, 0))
    local info3 = self:makeText(qy.TextUtil:substitute(90004), cc.c3b(224, 222, 187))
    local info4 = awardType == "recharge_award" and self:makeText(qy.TextUtil:substitute(90005), cc.c3b(240, 79, 0)) or self:makeText(qy.TextUtil:substitute(90007), cc.c3b(240, 79, 0))
    local info5 = self:makeText(qy.TextUtil:substitute(90006), cc.c3b(224, 222, 187))
    
    self.richText:pushBackElement(info1)
    self.richText:pushBackElement(info2)
    self.richText:pushBackElement(info3)
    self.richText:pushBackElement(info4)
    self.richText:pushBackElement(info5)
    self.Image_2:addChild(self.richText)

    self.Sprite_9:setVisible(false)
    self.Button_1:setEnabled(false)
    self.Button_1:setVisible(true)
    if awardType == "recharge_award" then
    	if model.amount > 0 then
			if model.nums >= num then
				if table.keyof(model.award_list[tostring(self.awardType)], self.data.id) == nil then
					self.Button_1:setEnabled(true)
				else
					self.Button_1:setVisible(false)
					self.Sprite_9:setVisible(true)
				end
			else
			end
		else
		end
	else
		if model.nums >= num then
			if table.keyof(model.award_list[tostring(self.awardType)], self.data.id) == nil then
				self.Button_1:setEnabled(true)
			else
				self.Button_1:setVisible(false)
				self.Sprite_9:setVisible(true)
			end
		else
		end
    end
end

function ItemView:makeText(text, color)
    return ccui.RichElementText:create(1, color or display.COLOR_WHITE, 255, text, qy.res.FONT_NAME, 22)
end

return ItemView