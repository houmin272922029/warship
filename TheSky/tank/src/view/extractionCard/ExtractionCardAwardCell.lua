--[[
	军资基地(领奖页面)
	Date: 2016-04-28 16:52:17
]]
local ExtractionCardAwardCell = qy.class("ExtractionCardAwardCell", qy.tank.view.BaseView, "view/extractionCard/ExtractionCardAwardCell")

local model = qy.tank.model.ExtractionCardModel
local service = qy.tank.service.ExtractionCardService
local TankSHopModel = qy.tank.model.TankShopModel

function ExtractionCardAwardCell:ctor(delegate)
	ExtractionCardAwardCell.super.ctor(self)
	self:InjectView("Button_1")
	self:InjectView("frame")
	self:InjectView("D_12")
	self:InjectView("Text_13")
	self.delegate = delegate
	
	self:OnClick("Button_1", function()
   		local aType = qy.tank.view.type.ModuleType
   			service:getChievementAwards({
                ["id"] = self.data.id
            }, function(reData)
                self:dealResult(reData)
        	end)
   	end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
end

function ExtractionCardAwardCell:dealResult(data)
	qy.tank.command.AwardCommand:add(data.award)
	qy.tank.command.AwardCommand:show(data.award)
	if table.keyof(model.achievement_award_list, self.data.id) == nil then
		self.Button_1:setEnabled(true)
	else
		self.Button_1:setVisible(false)
		self.D_12:setVisible(true)
	end
end

function ExtractionCardAwardCell:render(data)
	self.data = data
	self.D_12:setVisible(false)
	self.Button_1:setVisible(true)
	self.Button_1:setEnabled(false)
	self.Text_13:setString(qy.TextUtil:substitute(90011, data.times))

	local awards = data.award
	self.frame:removeAllChildren()
	if #awards == 1 then
		if awards[1].type == 11 then
			local tank = qy.tank.entity.TankEntity.new(awards[1].id, 0)
			local tankCard
	        if not tolua.cast(tankCard,"cc.Node") then
		        tankCard =  qy.tank.view.common.ItemCard.new({
		            ["entity"] = tank,
		        })
		        self.frame:addChild(tankCard)
		        tankCard:setPosition(142,315)
		        tankCard:setScale(0.7)
		        tankCard.name:enableOutline(cc.c4b(0,0,0,255),1)

		        local nums = TankSHopModel:getTankNeedMeterials(awards[1].id)
	    		local meterials
	    		if tank.quality == 2 then
	    			meterials = qy.TextUtil:substitute(90012) .. nums .. qy.TextUtil:substitute(44016)
	    		elseif tank.quality == 3 then
	    			meterials = qy.TextUtil:substitute(90012) .. nums .. qy.TextUtil:substitute(70017)
    			elseif tank.quality == 4 then
	    			meterials = qy.TextUtil:substitute(90013)
	    		else
	    			meterials = qy.TextUtil:substitute(90014)
	    		end
	    		local des = cc.Label:createWithTTF(meterials,qy.res.FONT_NAME_2, 22.0,cc.size(220,0),1)
   				des:enableOutline(cc.c4b(0,0,0,255),1)
   				self.frame:addChild(des)
		        des:setPosition(142,tank.quality == 4 and 207 or 190)
		        des:setColor(tank:getFontColor())

		        if  tank.quality == 4 then
			        local deses = cc.Label:createWithTTF(qy.TextUtil:substitute(90015),qy.res.FONT_NAME_2, 22.0,cc.size(220,0),1)
	   				deses:enableOutline(cc.c4b(0,0,0,255),1)
	   				self.frame:addChild(deses)
			        deses:setPosition(142,178)
			        deses:setColor(cc.c4b(255, 153, 0,255))
			    end
		    else
		    	tankCard:update({["entity"] = tank,})
	    	end
	    	
	    	self:OnClickForBuilding(tankCard.fatherSprite, function (sendr)
	            if not self.delegate:isTouchMoved() then
	                qy.alert:showTip(qy.tank.view.tip.TankTip.new(tank))
	            end
	        end)
	    else
			self.awardList = qy.AwardList.new({
		        ["award"] = awards,
		        ["cellSize"] = cc.size(148, 148),
		        ["type"] = 1,
		        ["itemSize"] = 2,
		        ["hasName"] = true,
		    })
		    self.awardList:setPosition(147,500)
		    self.awardList:setScale(1.3)
		    self.frame:addChild(self.awardList)
		end
	else
		for i=1,#awards do
			local item = qy.tank.view.common.AwardItem.createAwardView(awards[i] ,1)
			self.frame:addChild(item)
			item:setPosition(85 + 115 *(i > 2 and (i - 3) or (i - 1)), 340 - 115* ( i > 2 and 1 or 0))
			item.name:setVisible(false)
		end
	end

	if model.total_times >= data.times then
		if table.keyof(model.achievement_award_list, data.id) == nil then
			self.Button_1:setEnabled(true)
		else
			self.Button_1:setVisible(false)
			self.D_12:setVisible(true)
		end
	end

	if  self.delegate:isTouchMoved() then
	    -- self.delegate.Left:setVisible(true)
     --    self.delegate.Right:setVisible(true)
    else
        self.delegate.Left:setVisible(false)
        self.delegate.Right:setVisible(false)
    end
end

return ExtractionCardAwardCell