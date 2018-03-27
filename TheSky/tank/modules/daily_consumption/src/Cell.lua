local Cell = qy.class("Cell", qy.tank.view.BaseView, "daily_consumption.ui.Cell")

function Cell:ctor(delegate)
   	Cell.super.ctor(self)
   	self.delegate = delegate
    self.model = qy.tank.model.DailyConsumptionModel
    self.service = qy.tank.service.DailyConsumptionService

    for i = 1, 4 do 
    	self:InjectView("Img_"..i)
    end
    self:InjectView("Btn_1")
    self:InjectView("Btn_2")
    self:InjectView("Text_title")
end

function Cell:render(data, _idx)
	self.Text_title:setString("每日累计消费"..data.diamond.."钻石可领取")
	
	if self.awardList then
        self.Img_1:removeChild(self.awardList)
    end

    self.awardList = qy.AwardList.new({
        ["award"] = data.award_1,
        ["hasName"] = false,
        ["cellSize"] = cc.size(90,180),
        ["type"] = 1,
        ["itemSize"] = 2,
    })
    self.awardList:setPosition(50,290)
    self.Img_1:addChild(self.awardList)




    if self.awardList2 then
        self.Img_2:removeChild(self.awardList2)
    end

    self.awardList2 = qy.AwardList.new({
        ["award"] = data.award_2,
        ["hasName"] = false,
        ["cellSize"] = cc.size(90,180),
        ["type"] = 1,
        ["itemSize"] = 2,
    })
    self.awardList2:setPosition(50,290)
    self.Img_2:addChild(self.awardList2)

    if self.model.diamond < data.diamond then
    	self.Btn_1:setBright(false)
    	self.Btn_2:setBright(false)
    else
    	self.Btn_1:setBright(true)
    	self.Btn_2:setBright(true)
    end


    for i = 1, #self.model.score_award do 
    	if self.model.receive_log[tostring(data.diamond)] == "award_1" then
    		self.Btn_1:setBright(false)
            self.Btn_2:setBright(false)
    		self.Img_3:setTexture("daily_consumption/res/yilingqu.png")
            self.Img_4:setTexture("daily_consumption/res/lingqu.png")
    		break
    	elseif self.model.receive_log[tostring(data.diamond)] == "award_2" then
            self.Btn_2:setBright(false)
            self.Btn_1:setBright(false)
            self.Img_3:setTexture("daily_consumption/res/lingqu.png")
            self.Img_4:setTexture("daily_consumption/res/yilingqu.png")
            break
        else
    		self.Img_3:setTexture("daily_consumption/res/lingqu.png")
    		self.Img_4:setTexture("daily_consumption/res/lingqu.png")
    	end
    end


    



    self:OnClick("Btn_2", function(sender)       
        if self.Btn_2:isBright() then
            self:alert(function()
                self.service:getAward(function(data)
                    if data.award then
                        self.delegate:update()

                        qy.tank.command.AwardCommand:add(data.award)
                        qy.tank.command.AwardCommand:show(data.award)
                    end
                end, data.diamond, 2)
            end)            
        end
    end) 

    self:OnClick("Btn_1", function(sender)       
        if self.Btn_1:isBright() then
            self:alert(function()
                self.service:getAward(function(data)
                    if data.award then
                        self.delegate:update()

                        qy.tank.command.AwardCommand:add(data.award)
                        qy.tank.command.AwardCommand:show(data.award)
                    end
                end, data.diamond, 1)
            end)            
        end
    end) 
end



function Cell:alert(callback)
    qy.alert:show({"提示",{255, 255, 255}},"是否确认领取此奖励？",cc.size(500,300),{{qy.TextUtil:substitute(9005),4},{qy.TextUtil:substitute(9006),5}},function(label)
                        if label == qy.TextUtil:substitute(9006) then
                            callback()
                        end
                    end)
end

return Cell